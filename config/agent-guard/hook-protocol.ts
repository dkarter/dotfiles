import { redactCredentialValue } from './core';

type HookEvent = {
  hook_event_name?: string;
  tool_name?: string;
  tool_input?: unknown;
  tool_response?: unknown;
};

export const handleClaudeHook = (event: HookEvent): unknown => {
  const redacted = redactCredentialValue(event.tool_response);
  if (redacted === event.tool_response) return undefined;
  return {
    hookSpecificOutput: {
      hookEventName: 'PostToolUse',
      updatedToolOutput: redacted,
    },
  };
};

export const handleCodexHook = (event: HookEvent): unknown => {
  const redacted = redactCredentialValue(event.tool_response);
  if (redacted === event.tool_response) return undefined;
  return {
    decision: 'block',
    reason: `Credential guard redacted the tool output:\n${
      typeof redacted === 'string' ? redacted : JSON.stringify(redacted)
    }`,
  };
};
