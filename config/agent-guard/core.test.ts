import { describe, expect, test } from 'bun:test';
import { containsCredential, redactCredentialValue, redactCredentials } from './core';

describe('credential policy', () => {
  test('redacts structured credentials and common token formats', () => {
    const githubToken = `gho_${'a'.repeat(36)}`;
    const output = [
      'Authorization: Bearer dummy-bearer-value',
      'Set-Cookie: session=dummy-cookie; Secure',
      'PASSWORD="dummy password"',
      '"refresh_token": "dummy-refresh-value"',
      `token: ${githubToken}`,
    ].join('\n');

    expect(redactCredentials(output)).toBe(
      [
        'Authorization: Bearer [REDACTED]',
        'Set-Cookie: [REDACTED]',
        'PASSWORD="[REDACTED]"',
        '"refresh_token": "[REDACTED]"',
        'token: [REDACTED]',
      ].join('\n'),
    );
  });

  test('recursively redacts structured tool output', () => {
    const output = {
      stdout: 'api_key=dummy-value',
      metadata: ['safe', 'password: dummy-value'],
      access_token: 'opaque-dummy-value',
      nested: { AWS_SECRET_ACCESS_KEY: 'another-opaque-value' },
    };
    expect(redactCredentialValue(output)).toEqual({
      stdout: 'api_key=[REDACTED]',
      metadata: ['safe', 'password: [REDACTED]'],
      access_token: '[REDACTED]',
      nested: { AWS_SECRET_ACCESS_KEY: '[REDACTED]' },
    });
    expect(containsCredential(output)).toBe(true);
  });

  test('leaves ordinary output unchanged', () => {
    const output = 'Build completed successfully';
    const structured = { output };
    expect(redactCredentials(output)).toBe(output);
    expect(containsCredential(output)).toBe(false);
    expect(redactCredentialValue(structured)).toBe(structured);
  });
});
