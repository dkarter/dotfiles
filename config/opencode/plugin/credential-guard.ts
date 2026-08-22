import type { Plugin } from '@opencode-ai/plugin';
import { redactCredentials } from '../../agent-guard/core';

const CredentialGuardPlugin: Plugin = async () => ({
  'tool.execute.after': async (input, output) => {
    if ((input.tool === 'bash' || input.tool === 'shell') && typeof output.output === 'string') {
      output.output = redactCredentials(output.output);
    }
  },
});

export default CredentialGuardPlugin;
