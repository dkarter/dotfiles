import { expect, test } from 'bun:test';
import plugin from '../plugins/inline-command/index';

test('prompt hook expands date using session location and preserves attachments', async () => {
  let hook: (event: any) => Promise<void> = async () => {
    throw new Error('hook not registered');
  };
  await plugin.setup({
    session: {
      hook: async (name: string, callback: typeof hook) => {
        expect(name).toBe('prompt');
        hook = callback;
      },
      get: async () => ({ location: { directory: process.cwd() } }),
    },
  } as never);
  const event = {
    sessionID: 'ses_test',
    prompt: {
      text: 'Time? !`date`',
      files: [{ uri: 'file:///example.txt', mention: { start: 0, end: 1 } }],
      skills: [{ id: 'example', mention: { start: 0, end: 1 } }],
      agents: [{ id: 'example', mention: { start: 0, end: 1 } }],
    },
  };
  await hook(event);
  expect(event.prompt.text).toContain('Executed command: date\nExit status: 0');
  expect(event.prompt.files).toEqual([{ uri: 'file:///example.txt' }]);
  expect(event.prompt.skills).toEqual([{ id: 'example' }]);
  expect(event.prompt.agents).toEqual([{ id: 'example' }]);
  const expanded = event.prompt.text;
  await hook(event);
  expect(event.prompt.text).toBe(expanded);
});
