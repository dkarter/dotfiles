import { describe, expect, test } from 'bun:test';
import { handleClaudeHook, handleCodexHook } from './hook-protocol';

const unsafeResult = {
  tool_name: 'Bash',
  tool_response: { stdout: 'TOKEN=dummy-token', stderr: '', interrupted: false, isImage: false },
};

describe('agent hook protocols', () => {
  test('Claude replaces tool output with a redacted value', () => {
    expect(handleClaudeHook(unsafeResult)).toEqual({
      hookSpecificOutput: {
        hookEventName: 'PostToolUse',
        updatedToolOutput: { stdout: 'TOKEN=[REDACTED]', stderr: '', interrupted: false, isImage: false },
      },
    });
  });

  test('Codex withholds credential-bearing tool output', () => {
    expect(handleCodexHook(unsafeResult)).toEqual({
      decision: 'block',
      reason:
        'Credential guard redacted the tool output:\n{"stdout":"TOKEN=[REDACTED]","stderr":"","interrupted":false,"isImage":false}',
    });
  });
});
