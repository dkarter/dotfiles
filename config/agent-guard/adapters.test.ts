import { describe, expect, test } from 'bun:test';
import ampPlugin from '../amp/plugins/credential-guard';
import opencodePlugin from '../opencode/plugins/credential-guard';
import piPlugin from '../pi/agent/extensions/credential-guard';

describe('native agent adapters', () => {
  test('OpenCode redacts shell output', async () => {
    let hook: (event: any) => void = () => {
      throw new Error('hook not registered');
    };
    await opencodePlugin.setup({
      tool: {
        hook: async (name: string, callback: typeof hook) => {
          expect(name).toBe('execute.after');
          hook = callback;
        },
      },
    } as never);
    const file = { type: 'file', url: 'file:///example.png', mediaType: 'image/png' };
    const event = {
      tool: 'bash',
      status: 'completed',
      result: {
        output: 'TOKEN=dummy-opencode-token',
        content: [{ type: 'text', text: 'rk_live_' + 'aB3dE5fG7hI9jK1mN3pQ5rS7' }, file],
      },
    };
    hook(event);
    expect(event.result.output).toBe('TOKEN=[REDACTED]');
    expect(event.result.content[0]).toEqual({ type: 'text', text: '[REDACTED]' });
    expect(event.result.content[1]).toBe(file);
    const safeResult = { output: 'safe output', content: [{ type: 'text', text: 'safe text' }, file] };
    const safeEvent = { tool: 'bash', status: 'completed', result: safeResult };
    hook(safeEvent);
    expect(safeEvent.result).toBe(safeResult);
  });

  test('Pi replaces text content in tool results', async () => {
    let handler: ((event: any) => unknown) | undefined;
    piPlugin({
      on(event: string, candidate: (event: any) => unknown) {
        if (event === 'tool_result') handler = candidate;
      },
    } as never);

    expect(await handler?.({ content: [{ type: 'text', text: 'TOKEN=dummy-pi-token' }] })).toEqual({
      content: [{ type: 'text', text: 'TOKEN=[REDACTED]' }],
    });
  });

  test('Amp replaces credential-bearing tool output', async () => {
    let handler: ((event: any) => unknown) | undefined;
    ampPlugin({
      on(event: string, candidate: (event: any) => unknown) {
        if (event === 'tool.result') handler = candidate;
      },
    } as never);

    expect(await handler?.({ status: 'done', output: 'TOKEN=dummy-amp-token' })).toEqual({
      status: 'done',
      output: 'TOKEN=[REDACTED]',
    });
  });

  test('Pi and Amp leave safe results untouched', async () => {
    let piHandler: ((event: any) => unknown) | undefined;
    let ampHandler: ((event: any) => unknown) | undefined;
    piPlugin({
      on(event: string, candidate: (event: any) => unknown) {
        if (event === 'tool_result') piHandler = candidate;
      },
    } as never);
    ampPlugin({
      on(event: string, candidate: (event: any) => unknown) {
        if (event === 'tool.result') ampHandler = candidate;
      },
    } as never);

    expect(await piHandler?.({ content: [{ type: 'text', text: 'safe output' }] })).toBeUndefined();
    expect(await ampHandler?.({ status: 'done', output: 'safe output' })).toBeUndefined();
  });
});
