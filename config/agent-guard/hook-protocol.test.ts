import { describe, expect, test } from 'bun:test';
import { handleClaudeHook, handleCodexHook } from './hook-protocol';

const unsafeResult = {
  tool_name: 'Bash',
  tool_response: { stdout: 'TOKEN=dummy-token', stderr: '', interrupted: false, isImage: false },
};

describe('agent hook protocols', () => {
  const sitesTool = 'mcp__codex_apps__sites__create_source_repository_write_credential';
  const sitesResponse = {
    app_repository_id: 'test-repo',
    auth_mode: 'https',
    remote_url: 'https://example.test/test-repo.git',
    token: 'synthetic-upload-value',
  };

  test('Codex allows the credential in a successful Sites response envelope', () => {
    const envelope = {
      content: [{ type: 'text', text: 'Action completed.' }],
      structuredContent: sitesResponse,
      isError: false,
    };
    const event = { tool_name: sitesTool, tool_response: envelope };
    expect(handleCodexHook(event)).toBeUndefined();
    expect(handleCodexHook({ ...event, tool_response: { ...envelope, isError: true } })).toMatchObject({
      decision: 'block',
    });
    expect(
      handleCodexHook({
        ...event,
        tool_response: { ...envelope, _meta: { password: 'synthetic-other-value' } },
      }),
    ).toMatchObject({ decision: 'block' });
  });

  test('Codex allows the Sites write credential for any project', () => {
    expect(handleCodexHook({ tool_name: sitesTool, tool_response: sitesResponse })).toBeUndefined();
    expect(
      handleCodexHook({
        tool_name: sitesTool,
        tool_input: { project_id: 'another-test-project' },
        tool_response: [{ type: 'input_text', text: JSON.stringify(sitesResponse, null, 2) }],
      }),
    ).toBeUndefined();
  });

  test('Codex still blocks other secrets in Sites responses and credentials from other tools', () => {
    const response = { ...sitesResponse, extra: { password: 'synthetic-other-value' } };
    expect(
      handleCodexHook({
        tool_name: sitesTool,
        tool_response: [{ type: 'input_text', text: JSON.stringify(response) }],
      }),
    ).toMatchObject({ decision: 'block' });
    expect(
      handleCodexHook({
        tool_name: `${sitesTool}_other`,
        tool_response: sitesResponse,
      }),
    ).toMatchObject({ decision: 'block' });
    expect(handleClaudeHook({ tool_name: sitesTool, tool_response: sitesResponse })).toBeDefined();
  });

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
