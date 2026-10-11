import { Plugin } from '@opencode/plugin';
import { redactCredentialValue } from '../../agent-guard/core';

const CredentialGuardPlugin = Plugin.define({
  id: 'credential-guard',
  async setup(ctx) {
    await ctx.tool.hook('execute.after', (event) => {
      if ((event.tool !== 'bash' && event.tool !== 'shell') || event.status !== 'completed') {
        return;
      }

      const texts: string[] = [];
      if (typeof event.result.output === 'string') texts.push(event.result.output);
      if (typeof event.result.content === 'string') texts.push(event.result.content);
      else
        for (const item of event.result.content ?? []) {
          if (item.type === 'text') texts.push(item.text);
        }
      const redacted = redactCredentialValue(texts);
      if (redacted === texts) return;
      let index = 0;
      const output = typeof event.result.output === 'string' ? redacted[index++] : event.result.output;
      const content =
        typeof event.result.content === 'string'
          ? redacted[index++]
          : event.result.content?.map((item) => (item.type === 'text' ? { ...item, text: redacted[index++] } : item));

      event.result = { ...event.result, output, content };
    });
  },
});

export default CredentialGuardPlugin;
