import { Plugin } from '@opencode/plugin';
import { redactCredentials } from '../../agent-guard/core';

const CredentialGuardPlugin = Plugin.define({
  id: 'credential-guard',
  async setup(ctx) {
    await ctx.tool.hook('execute.after', (event) => {
      if ((event.tool !== 'bash' && event.tool !== 'shell') || event.status !== 'completed') {
        return;
      }

      const output =
        typeof event.result.output === 'string' ? redactCredentials(event.result.output) : event.result.output;
      const content =
        typeof event.result.content === 'string'
          ? redactCredentials(event.result.content)
          : event.result.content?.map((item) =>
              item.type === 'text' ? { ...item, text: redactCredentials(item.text) } : item,
            );

      event.result = { ...event.result, output, content };
    });
  },
});

export default CredentialGuardPlugin;
