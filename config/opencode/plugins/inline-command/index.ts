import { Plugin } from '@opencode/plugin';
import { preparePrompt } from '../../../inline-command/core';

export default Plugin.define({
  id: 'inline-command',
  async setup(ctx) {
    await ctx.session.hook('prompt', async (event) => {
      if (!event.prompt.text.includes('!`')) return;
      const session = await ctx.session.get({ sessionID: event.sessionID });
      const { text } = await preparePrompt(event.prompt.text, session.location.directory);
      if (text === event.prompt.text) return;
      event.prompt.text = text;
      // Keep attachments, but discard composer offsets invalidated by expansion.
      for (const attachment of [
        ...(event.prompt.files ?? []),
        ...(event.prompt.skills ?? []),
        ...(event.prompt.agents ?? []),
      ])
        delete attachment.mention;
    });
  },
});
