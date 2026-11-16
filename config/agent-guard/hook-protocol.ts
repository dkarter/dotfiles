import { redactCredentialValue } from './core';

type HookEvent = {
  hook_event_name?: string;
  tool_name?: string;
  tool_input?: unknown;
  tool_response?: unknown;
};

const sitesWriteCredentialTool = 'mcp__codex_apps__sites__create_source_repository_write_credential';

const unwrapSitesResponse = (response: unknown): unknown => {
  if (Array.isArray(response)) {
    if (response.length !== 1) return response;
    const [block] = response;
    if (
      !block ||
      typeof block !== 'object' ||
      typeof block.text !== 'string' ||
      (block.type !== 'text' && block.type !== 'input_text')
    )
      return response;
    const { text, ...metadata } = block;
    if (redactCredentialValue(metadata) !== metadata) return response;

    try {
      const parsed: unknown = JSON.parse(text);
      // Require an unambiguous JSON payload. Re-encoding also rejects duplicate keys.
      if (text.trim() === JSON.stringify(parsed) || text.trim() === JSON.stringify(parsed, null, 2)) return parsed;
    } catch {
      return response;
    }
  }
  return response;
};

const hasOnlySitesWriteCredential = (response: unknown): boolean => {
  if (!response || typeof response !== 'object' || Array.isArray(response)) return false;
  const { token, ...metadata } = response as Record<string, unknown>;
  return (
    typeof token === 'string' &&
    token.length > 0 &&
    typeof metadata.auth_mode === 'string' &&
    metadata.auth_mode !== 'work_proxy' &&
    typeof metadata.app_repository_id === 'string' &&
    typeof metadata.remote_url === 'string' &&
    redactCredentialValue(metadata) === metadata
  );
};

const isSitesWriteCredentialResponse = (response: unknown): boolean => {
  if (!response || typeof response !== 'object' || Array.isArray(response)) return false;
  const { structuredContent, ...envelope } = response as Record<string, unknown>;
  if (!Object.hasOwn(response, 'structuredContent')) return hasOnlySitesWriteCredential(response);
  return (
    envelope.isError === false &&
    hasOnlySitesWriteCredential(structuredContent) &&
    redactCredentialValue(envelope) === envelope
  );
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
  let response = event.tool_response;
  if (event.tool_name === sitesWriteCredentialTool) {
    response = unwrapSitesResponse(response);
    if (isSitesWriteCredentialResponse(response)) return undefined;
  }
  const redacted = redactCredentialValue(response);
  if (redacted === response) return undefined;
  return {
    decision: 'block',
    reason: `Credential guard redacted the tool output:\n${
      typeof redacted === 'string' ? redacted : JSON.stringify(redacted)
    }`,
  };
};
