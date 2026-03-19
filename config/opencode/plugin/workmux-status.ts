import type { Plugin } from '@opencode-ai/plugin';

export const WorkmuxStatusPlugin: Plugin = async ({ $ }) => {
  const setStatus = async (status: 'working' | 'waiting' | 'done') => {
    await $`workmux set-window-status ${status}`.quiet();
  };

  return {
    event: async ({ event }) => {
      const eventType = event.type as string;

      if (eventType === 'session.status') {
        const statusType = (event as { properties?: { status?: { type?: string } } }).properties?.status?.type;

        if (statusType === 'busy') {
          await setStatus('working');
        } else if (statusType === 'waiting') {
          await setStatus('waiting');
        }
        return;
      }

      if (eventType === 'permission.asked' || eventType === 'permission.updated') {
        await setStatus('waiting');
        return;
      }

      if (eventType === 'permission.replied') {
        await setStatus('working');
        return;
      }

      if (eventType === 'session.idle') {
        await setStatus('done');
      }
    },
  };
};
