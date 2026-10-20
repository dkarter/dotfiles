import { describe, expect, spyOn, test } from 'bun:test';
import * as scanner from '../agent-guard/betterleaks';
import { expandCommands, runCommand } from './core';

describe('inline commands', () => {
  test('expands in prose and keeps command, output and status', async () => {
    const result = await expandCommands('Before !`date` after', async () => ({
      status: '0',
      stdout: 'today\n',
      stderr: '',
    }));
    expect(result).toContain('Before');
    expect(result).toContain('Executed command: date\nExit status: 0');
    expect(result).toContain('    today');
    expect(result).toContain('after');
  });

  test('leaves escaped, quoted and fenced examples alone', async () => {
    const text = '\\!`date`\n``!`date```\n```sh\n!`date`\n```\n~~~\n!`date`\n~~~\n    !`date`';
    expect(
      await expandCommands(text, async () => {
        throw new Error('must not run');
      }),
    ).toBe(text);
  });

  test('does not recursively execute output and caps executions', async () => {
    // Real scanner coverage lives in agent-guard; this test checks command expansion only.
    const scan = spyOn(scanner, 'redactWithBetterleaks').mockImplementation((value) => value);
    try {
      let calls = 0;
      const result = await expandCommands(Array(5).fill('!`date`').join(' '), async () => {
        calls++;
        return { status: '0', stdout: '!`date`', stderr: 'warning' };
      });
      expect(calls).toBe(4);
      expect(result).toContain('four-command limit');
      expect(result).toContain('Stderr:\n    warning');
      expect(scan).toHaveBeenCalled();
    } finally {
      scan.mockRestore();
    }
  });

  test('leaves multiline code spans and blockquoted examples literal', async () => {
    const text = '``example\n!`date`\n``\n> ~~~sh\n> !`date`\n> ~~~';
    expect(
      await expandCommands(text, async () => {
        throw new Error('must not run');
      }),
    ).toBe(text);
  });

  test('runs date and arbitrary shell expressions', async () => {
    const result = await runCommand('date', process.cwd());
    expect(result.status).toBe('0');
    expect(result.stdout.trim()).not.toBe('');
    expect((await runCommand("printf '%s' $(printf hello) | tr a-z A-Z", process.cwd())).stdout).toBe('HELLO');
  });

  test('leaves list-nested fences and lazy blockquote continuations literal', async () => {
    for (const text of ['- ~~~sh\n  !`printf unintended`\n  ~~~', '> example\n!`printf unintended`']) {
      expect(
        await expandCommands(text, async () => {
          throw new Error('must not run');
        }),
      ).toBe(text);
    }
  });

  test('captures nonzero exit status and stderr', async () => {
    const result = await runCommand('printf warning >&2; exit 7', process.cwd());
    expect(result.status).toBe('7');
    expect(result.stderr).toBe('warning');
  });

  test('bounds runtime and combined output', async () => {
    expect((await runCommand('sleep 10', process.cwd(), { timeoutMs: 50, maxBytes: 64 })).status).toContain('timeout');
    const result = await runCommand('yes output', process.cwd(), { timeoutMs: 5_000, maxBytes: 64 });
    expect(result.status).toContain('output limit');
    expect(Buffer.byteLength(result.stdout + result.stderr)).toBeLessThanOrEqual(64);
  });
});
