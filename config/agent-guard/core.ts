import { redactBatchWithBetterleaks, redactWithBetterleaks } from './betterleaks';

const MAY_CONTAIN_CREDENTIAL =
  /authorization|cookie|token|secret|password|api[_-]?key|private[_-]?key|\bgh[pousr]_|\bgithub_pat_|\bglpat-|\bnpm_|\bpypi-|\bsk-|\bxox[baprs]-|\bAKIA|\beyJ|-----BEGIN/i;

const SECRET_VALUE_PATTERNS = [
  /((?:authorization|proxy-authorization)["']?\s*[:=]\s*["']?(?:basic|bearer)\s+)[^\s"',}]+()/gi,
  /((?:cookie|set-cookie)["']?\s*[:=]\s*)[^\r\n]+()/gi,
  /((?:access[_-]?token|refresh[_-]?token|api[_-]?key|client[_-]?secret|password)["']?\s*[:=]\s*["'])[^"'\r\n]*(["'])/gi,
  /((?:access[_-]?token|refresh[_-]?token|api[_-]?key|client[_-]?secret|password)["']?\s*[:=]\s*)(?!["'])[^\s"',}]+()/gi,
  /(\b(?:[A-Z][A-Z0-9_]*_)?(?:TOKEN|SECRET|PASSWORD|API_KEY|PRIVATE_KEY)=["'])[^"'\r\n]*(["'])/g,
  /(\b(?:[A-Z][A-Z0-9_]*_)?(?:TOKEN|SECRET|PASSWORD|API_KEY|PRIVATE_KEY)=)(?!["'])[^\s]+()/g,
] as const;

const TOKEN_PATTERNS = [
  /\bgh[pousr]_[A-Za-z0-9]{20,}\b/g,
  /\bgithub_pat_[A-Za-z0-9_]{20,}\b/g,
  /\bglpat-[A-Za-z0-9_-]{20,}\b/g,
  /\bnpm_[A-Za-z0-9]{20,}\b/g,
  /\bpypi-[A-Za-z0-9_-]{20,}\b/g,
  /\bsk-[A-Za-z0-9_-]{20,}\b/g,
  /\bxox[baprs]-[A-Za-z0-9-]{20,}\b/g,
  /\bAKIA[A-Z0-9]{16}\b/g,
  /\beyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\b/g,
] as const;

const CREDENTIAL_KEY =
  /(?:^|[_-])(?:authorization|cookie|token|secret|secret[_-]?access[_-]?key|password|api[_-]?key|private[_-]?key)$/i;

const redactKnownCredentials = (value: string): string => {
  if (!MAY_CONTAIN_CREDENTIAL.test(value)) return value;

  let redacted = value;
  for (const pattern of SECRET_VALUE_PATTERNS) redacted = redacted.replace(pattern, '$1[REDACTED]$2');
  for (const pattern of TOKEN_PATTERNS) redacted = redacted.replace(pattern, '[REDACTED]');
  return redacted.replace(
    /-----BEGIN (?:[A-Z ]+ )?PRIVATE KEY-----[\s\S]*?-----END (?:[A-Z ]+ )?PRIVATE KEY-----/g,
    '[REDACTED PRIVATE KEY]',
  );
};

export const redactCredentials = (value: string): string => redactWithBetterleaks(redactKnownCredentials(value));

const mapTextValues = <T>(value: T, transform: (text: string, key: string) => string, key = ''): T => {
  if (typeof value === 'string') {
    return transform(value, key) as T;
  }
  if (Array.isArray(value)) {
    let changed = false;
    const redacted = value.map((item) => {
      const next = mapTextValues(item, transform);
      changed ||= next !== item;
      return next;
    });
    return (changed ? redacted : value) as T;
  }
  if (value && typeof value === 'object') {
    let changed = false;
    const redacted = Object.fromEntries(
      Object.entries(value).map(([childKey, item]) => {
        const next = mapTextValues(item, transform, childKey);
        changed ||= next !== item;
        return [childKey, next];
      }),
    );
    return (changed ? redacted : value) as T;
  }
  return value;
};

export const redactCredentialValue = <T>(value: T, key = ''): T => {
  const texts: string[] = [];
  const masked = mapTextValues(
    value,
    (text, childKey) => {
      if (CREDENTIAL_KEY.test(childKey)) return '[REDACTED]';
      const redacted = redactKnownCredentials(text);
      texts.push(redacted);
      return redacted;
    },
    key,
  );
  const redacted = redactBatchWithBetterleaks(texts);
  if (redacted === texts) return masked;
  let index = 0;
  return mapTextValues(masked, (text, childKey) => (CREDENTIAL_KEY.test(childKey) ? text : redacted[index++]), key);
};

export const containsCredential = (value: unknown): boolean => redactCredentialValue(value) !== value;
