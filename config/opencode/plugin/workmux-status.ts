import type { Plugin } from '@opencode-ai/plugin';

const debugLogPath =
  process.env.WORKMUX_STATUS_PLUGIN_LOG_PATH || `${process.env.HOME}/.local/state/workmux/workmux-status-plugin.log`;

const writeDebugLog = async (line: string) => {
  if (process.env.WORKMUX_STATUS_PLUGIN_DEBUG !== '1') {
    return;
  }

  await Bun.write(Bun.file(debugLogPath), `${line}\n`);
};

export const WorkmuxStatusPlugin: Plugin = async ({ $ }) => {
  const setStatus = async (status: 'working' | 'waiting' | 'done', eventType: string) => {
    await $`workmux set-window-status ${status}`.quiet();
    await writeDebugLog(
      JSON.stringify({
        ts: new Date().toISOString(),
        event: eventType,
        status,
      }),
    );
  };

  return {
    event: async ({ event }) => {
      switch (event.type) {
        case 'session.status':
          if (event.properties.status.type === 'busy') {
            await setStatus('working', event.type);
          } else if (event.properties.status.type === 'waiting') {
            await setStatus('waiting', event.type);
          }
          break;
        case 'permission.asked':
        case 'permission.updated':
          await setStatus('waiting', event.type);
          break;
        case 'permission.replied':
          await setStatus('working', event.type);
          break;
        case 'session.idle':
          await setStatus('done', event.type);
          break;
      }
    },
  };
};
