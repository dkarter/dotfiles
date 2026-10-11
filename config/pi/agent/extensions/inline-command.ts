import type { ExtensionAPI } from '@earendil-works/pi-coding-agent';
import { preparePrompt } from '../../../inline-command/core';

export default function (pi: ExtensionAPI) {
  pi.on('input', async (event, ctx) => {
    if (event.source === 'extension' || !event.text.includes('!`')) return { action: 'continue' };
    const { text } = await preparePrompt(event.text, ctx.cwd);
    return text === event.text ? { action: 'continue' } : { action: 'transform', text, images: event.images };
  });
}
