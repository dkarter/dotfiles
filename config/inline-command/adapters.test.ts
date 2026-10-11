import { expect, test } from 'bun:test';
import { handlePromptHook } from './hook-protocol';
import piExtension from '../pi/agent/extensions/inline-command';

test('Claude/Codex hook injects only executed results, not the full prompt', async () => {
  const result = await handlePromptHook({
    hook_event_name: 'UserPromptSubmit',
    cwd: process.cwd(),
    prompt: 'Explain this output !`printf hook-ok` without running tools',
  });
  expect(result?.hookSpecificOutput.hookEventName).toBe('UserPromptSubmit');
  expect(result?.hookSpecificOutput.additionalContext).toContain('    hook-ok');
  expect(result?.hookSpecificOutput.additionalContext).toContain('do not run them again');
  expect(result?.hookSpecificOutput.additionalContext).not.toContain('Explain this output');
});

test('hook is silent for other events, ordinary prompts and quoted examples', async () => {
  expect(await handlePromptHook({ hook_event_name: 'Stop', prompt: '!`date`' })).toBeUndefined();
  expect(await handlePromptHook({ hook_event_name: 'UserPromptSubmit', prompt: 'hello' })).toBeUndefined();
  expect(
    await handlePromptHook({ hook_event_name: 'UserPromptSubmit', prompt: '``!`date```', cwd: process.cwd() }),
  ).toBeUndefined();
});

test('Pi transforms user input and preserves images, but skips injected messages', async () => {
  let handler: (event: any, ctx: any) => Promise<any> = async () => {
    throw new Error('not registered');
  };
  piExtension({
    on: (name: string, callback: typeof handler) => {
      expect(name).toBe('input');
      handler = callback;
    },
  } as never);
  const images = [{ type: 'image', data: 'dummy', mimeType: 'image/png' }];
  const result = await handler({ text: '!`printf pi-ok`', source: 'interactive', images }, { cwd: process.cwd() });
  expect(result.action).toBe('transform');
  expect(result.text).toContain('    pi-ok');
  expect(result.images).toBe(images);
  expect(await handler({ text: '!`date`', source: 'extension' }, {})).toEqual({ action: 'continue' });
});
