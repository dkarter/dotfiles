import type { PluginAPI } from '@ampcode/plugin';
import { redactCredentialValue } from '../../agent-guard/core';

export const description = 'Blocks direct credential reads and redacts credential-like tool output.';

export default function (amp: PluginAPI) {
  amp.on('tool.result', (event) => {
    const output = redactCredentialValue(event.output);
    if (output === event.output) return undefined;
    if (event.status === 'done') return { status: 'done', output };
    return { status: event.status, error: event.error, output };
  });
}
