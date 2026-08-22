import { describe, expect, test } from 'bun:test';
import ampPlugin from '../amp/plugins/credential-guard';
import opencodePlugin from '../opencode/plugin/credential-guard';
import piPlugin from '../pi/agent/extensions/credential-guard';

describe('native agent adapters', () => {
  test('OpenCode redacts shell output', async () => {
    const hooks = await opencodePlugin({} as never);
    const output = { output: 'TOKEN=dummy-opencode-token' };
    await hooks['tool.execute.after']?.({ tool: 'bash' } as never, output as never);
    expect(output.output).toBe('TOKEN=[REDACTED]');
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
