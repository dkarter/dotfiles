import { describe, expect, test } from 'bun:test';
import { exposesResolvedConfig, redactCredentials } from './credential-guard';

describe('credential guard', () => {
  test('blocks resolved OpenCode config dumps', () => {
    expect(exposesResolvedConfig('opencode debug config')).toBe(true);
    expect(exposesResolvedConfig('OPENCODE_DB=/tmp/test opencode2 --standalone debug config')).toBe(true);
    expect(exposesResolvedConfig('/usr/local/bin/opencode2 debug config | jq .')).toBe(true);
    expect(exposesResolvedConfig("'/usr/local/bin/opencode' --config /tmp/opencode.json debug config")).toBe(true);
    expect(exposesResolvedConfig('opencode2 debug agents')).toBe(false);
  });

  test('redacts structured credentials and common token formats', () => {
    const output = [
      'Authorization: Bearer secret-value',
      'Proxy-Authorization: Basic c2VjcmV0',
      'Set-Cookie: session=secret value; Secure',
      'GITHUB_TOKEN=secret-value',
      'PASSWORD="correct horse battery staple"',
      '"refresh_token": "secret-value"',
      `token: ${'gho_' + 'a'.repeat(36)}`,
    ].join('\n');

    expect(redactCredentials(output)).toBe(
      [
        'Authorization: Bearer [REDACTED]',
        'Proxy-Authorization: Basic [REDACTED]',
        'Set-Cookie: [REDACTED]',
        'GITHUB_TOKEN=[REDACTED]',
        'PASSWORD="[REDACTED]"',
        '"refresh_token": "[REDACTED]"',
        'token: [REDACTED]',
      ].join('\n'),
    );
  });

  test('returns ordinary output unchanged', () => {
    const output = 'Build completed successfully';
    expect(redactCredentials(output)).toBe(output);
  });
});
