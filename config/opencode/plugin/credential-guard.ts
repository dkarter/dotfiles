import type { Plugin } from '@opencode-ai/plugin';

const RESOLVED_CONFIG_COMMAND =
  /(?:^|[\s;|&])(?:"[^"]*opencode2?"|'[^']*opencode2?'|(?:[^\s"'|;&]+\/)?opencode2?)(?=\s)(?:(?![|;&]).)*?\sdebug\s+config(?:\s|$|[|;&])/i;

const MAY_CONTAIN_CREDENTIAL =
  /authorization|cookie|token|secret|password|api[_-]?key|private[_-]?key|\bgh[pousr]_|\bgithub_pat_|\bsk-|\bxox[baprs]-|\beyJ|-----BEGIN/i;

const SECRET_VALUE_PATTERNS = [
  /((?:authorization|proxy-authorization)["']?\s*[:=]\s*["']?(?:basic|bearer)\s+)[^\s"',}]+()/gi,
  /((?:cookie|set-cookie)["']?\s*[:=]\s*)[^\r\n]+()/gi,
  /((?:access[_-]?token|refresh[_-]?token|api[_-]?key|client[_-]?secret|password)["']?\s*[:=]\s*["'])[^"'\r\n]*(["'])/gi,
  /((?:access[_-]?token|refresh[_-]?token|api[_-]?key|client[_-]?secret|password)["']?\s*[:=]\s*["']?)[^\s"',}]+()/gi,
  /(\b(?:[A-Z][A-Z0-9_]*(?:TOKEN|SECRET|PASSWORD|API_KEY|PRIVATE_KEY))=["'])[^"'\r\n]*(["'])/g,
  /(\b(?:[A-Z][A-Z0-9_]*(?:TOKEN|SECRET|PASSWORD|API_KEY|PRIVATE_KEY))=)[^\s]+()/g,
] as const;

const TOKEN_PATTERNS = [
  /\bgh[pousr]_[A-Za-z0-9]{20,}\b/g,
  /\bgithub_pat_[A-Za-z0-9_]{20,}\b/g,
  /\bsk-[A-Za-z0-9_-]{20,}\b/g,
  /\bxox[baprs]-[A-Za-z0-9-]{20,}\b/g,
  /\beyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\b/g,
] as const;

export const exposesResolvedConfig = (command: string) => RESOLVED_CONFIG_COMMAND.test(command);

export const redactCredentials = (value: string) => {
  if (!MAY_CONTAIN_CREDENTIAL.test(value)) {
    return value;
  }

  let redacted = value;
  for (const pattern of SECRET_VALUE_PATTERNS) {
    redacted = redacted.replace(pattern, '$1[REDACTED]$2');
  }
  for (const pattern of TOKEN_PATTERNS) {
    redacted = redacted.replace(pattern, '[REDACTED]');
  }
  return redacted.replace(
    /-----BEGIN (?:[A-Z ]+ )?PRIVATE KEY-----[\s\S]*?-----END (?:[A-Z ]+ )?PRIVATE KEY-----/g,
    '[REDACTED PRIVATE KEY]',
  );
};

const CredentialGuardPlugin: Plugin = async () => ({
  'tool.execute.before': async (input, output) => {
    if (input.tool !== 'bash' && input.tool !== 'shell') {
      return;
    }

    const command = (output.args as { command?: unknown } | undefined)?.command;
    if (typeof command === 'string' && exposesResolvedConfig(command)) {
      throw new Error('Resolved OpenCode configuration may contain expanded credentials and cannot be displayed.');
    }
  },
  'tool.execute.after': async (input, output) => {
    if ((input.tool === 'bash' || input.tool === 'shell') && typeof output.output === 'string') {
      output.output = redactCredentials(output.output);
    }
  },
});

export default CredentialGuardPlugin;
