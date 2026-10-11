import { describe, expect, test } from 'bun:test';
import { redactBatchWithBetterleaks, redactFindingLines, redactWithBetterleaks } from './betterleaks';
import { redactCredentials } from './core';

describe('Betterleaks redaction', () => {
  // Synthetic credential with a provider prefix not covered by core's regexes.
  const stripeKey = `rk_live_${'aB3dE5fG7hI9jK1mN3pQ5rS7'}`;

  test('redacts provider secrets while preserving surrounding lines', () => {
    expect(redactCredentials(`before\n${stripeKey}\nafter`)).toBe('before\n[REDACTED]\nafter');
  });

  test('does not let inline scanner allow comments bypass agent redaction', () => {
    expect(redactWithBetterleaks(`${stripeKey} # betterleaks:allow`)).toBe('[REDACTED]');
  });

  test('scans text with binary-looking prefixes instead of silently skipping it', () => {
    for (const prefix of ['%PDF-1.7', 'PK\u0003\u0004']) {
      expect(redactWithBetterleaks(`${prefix}\n${stripeKey}\nafter`)).toBe(`${prefix}\n[REDACTED]\nafter`);
    }
  });

  test('preserves absolute line numbers across scanner fragments', () => {
    const prefix = 'ordinary output\n'.repeat(10_000);
    expect(redactWithBetterleaks(`${prefix}${stripeKey}\nafter`)).toBe(`${prefix}[REDACTED]\nafter`);
  });

  test('maps batch findings back to multiline fields including empty boundaries', () => {
    expect(redactBatchWithBetterleaks(['', 'before\n', stripeKey, '\n', 'after', ''])).toEqual([
      '',
      'before\n',
      '[REDACTED]',
      '\n',
      'after',
      '',
    ]);
  });

  test('returns the original batch when nothing needs masking', () => {
    const texts = ['safe\noutput', '', '\n', 'more safe text'];
    expect(redactBatchWithBetterleaks(texts)).toBe(texts);
  });

  test('withholds every nonempty batch field when scanning fails', () => {
    const path = process.env.PATH;
    try {
      process.env.PATH = '';
      expect(redactBatchWithBetterleaks(['safe', stripeKey, '', '\n'])).toEqual([
        '[REDACTED: secret scan unavailable]',
        '[REDACTED: secret scan unavailable]',
        '',
        '\n',
      ]);
      expect(redactBatchWithBetterleaks([])).toEqual([]);
    } finally {
      process.env.PATH = path;
    }
  });

  test('redacts every affected line and multipart component', () => {
    expect(
      redactFindingLines('before\nfirst\nsecond\ncomponent\nafter', [
        {
          StartLine: 2,
          EndLine: 3,
          ComponentSets: [{ components: [{ StartLine: 4, EndLine: 4 }] }],
        },
      ]),
    ).toBe('before\n[REDACTED]\n[REDACTED]\n[REDACTED]\nafter');
  });

  test('fails closed on malformed or out-of-range findings', () => {
    for (const findings of [null, {}, [null], [{}], [{ StartLine: 0, EndLine: 1 }], [{ StartLine: 1, EndLine: 2 }]]) {
      expect(redactFindingLines('unsafe output', findings)).toBe('[REDACTED: secret scan unavailable]');
    }
  });

  test('fails closed when the scanner cannot be launched', () => {
    const path = process.env.PATH;
    try {
      process.env.PATH = '';
      expect(redactWithBetterleaks(stripeKey)).toBe('[REDACTED: secret scan unavailable]');
    } finally {
      process.env.PATH = path;
    }
  });
});
