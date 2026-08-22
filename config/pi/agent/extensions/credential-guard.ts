import type { ExtensionAPI } from '@earendil-works/pi-coding-agent';
import { redactCredentialValue } from '../../../agent-guard/core';

export default function (pi: ExtensionAPI) {
  pi.on('tool_result', (event) => {
    const content = redactCredentialValue(event.content);
    return content === event.content ? undefined : { content };
  });
}
