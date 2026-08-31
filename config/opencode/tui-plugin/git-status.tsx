/** @jsxImportSource @opentui/solid */
import type { Plugin } from '@opencode-ai/plugin-v2/tui';
import type { RGBA } from '@opentui/core';
import { useTerminalDimensions } from '@opentui/solid';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { createSignal, onCleanup, onMount } from 'solid-js';

type GitStatus = {
  branch: string;
  ahead: number;
  behind: number;
  staged: number;
  modified: number;
  untracked: number;
  conflicted: number;
};

type GitTheme = {
  hue: {
    blue: Record<500, RGBA>;
    green: Record<500, RGBA>;
    purple: Record<500, RGBA>;
    red: Record<500, RGBA>;
    yellow: Record<500, RGBA>;
  };
  text: {
    default: RGBA;
  };
};

const execFileAsync = promisify(execFile);
const CONFLICTED = new Set(['DD', 'AU', 'UD', 'UA', 'DU', 'AA', 'UU']);

const truncateMiddle = (value: string, maxLength: number) => {
  if (value.length <= maxLength) {
    return value;
  }

  const startLength = Math.ceil((maxLength - 1) / 2);
  const endLength = Math.floor((maxLength - 1) / 2);
  return `${value.slice(0, startLength)}…${value.slice(-endLength)}`;
};

const parseStatus = (output: string): GitStatus | undefined => {
  const status: GitStatus = {
    branch: '',
    ahead: 0,
    behind: 0,
    staged: 0,
    modified: 0,
    untracked: 0,
    conflicted: 0,
  };
  let oid = '';

  for (const line of output.split('\n')) {
    if (line.startsWith('# branch.head ')) {
      status.branch = line.slice(14);
      continue;
    }
    if (line.startsWith('# branch.oid ')) {
      oid = line.slice(13, 20);
      continue;
    }
    if (line.startsWith('# branch.ab ')) {
      const match = line.match(/\+(\d+) -(\d+)/);
      status.ahead = Number(match?.[1] ?? 0);
      status.behind = Number(match?.[2] ?? 0);
      continue;
    }
    if (line.startsWith('? ')) {
      status.untracked += 1;
      continue;
    }
    if (!/^[12u] /.test(line)) {
      continue;
    }

    const state = line.slice(2, 4);
    if (line.startsWith('u ') || CONFLICTED.has(state)) {
      status.conflicted += 1;
      continue;
    }
    if (state[0] !== '.') {
      status.staged += 1;
    }
    if (state[1] !== '.') {
      status.modified += 1;
    }
  }

  if (!status.branch) {
    return undefined;
  }
  if (status.branch === '(detached)') {
    status.branch = oid || 'detached';
  }
  return status;
};

const GitStatusPlugin = {
  id: 'dkarter.git-status',
  setup(ctx: Plugin.Context) {
    const location = ctx.location ?? ctx.data.location.default();
    const [status, setStatus] = createSignal<GitStatus>();
    let refreshID = 0;

    const refresh = async () => {
      const id = ++refreshID;
      try {
        const { stdout } = await execFileAsync('git', ['--no-optional-locks', 'status', '--porcelain=v2', '--branch'], {
          cwd: location.directory,
          timeout: 2_000,
          maxBuffer: 1024 * 1024,
        });
        if (id === refreshID) {
          setStatus(parseStatus(stdout));
        }
      } catch {
        if (id === refreshID) {
          setStatus(undefined);
        }
      }
    };

    const stopFilesystem = ctx.data.on('filesystem.changed', (event) => {
      if (!event.location || event.location.directory === location.directory) {
        void refresh();
      }
    });
    const stopBranch = ctx.data.on('vcs.branch.updated', (event) => {
      if (!event.location || event.location.directory === location.directory) {
        void refresh();
      }
    });

    const unregister = ctx.ui.slot({
      append: 'prompt.footer.status',
      render: ({ mode }) => {
        const dimensions = useTerminalDimensions();
        onMount(() => {
          void refresh();
          const timer = setInterval(refresh, 3_000);
          onCleanup(() => clearInterval(timer));
        });

        const theme = ctx.theme as unknown as GitTheme;
        const showBranch = () => dimensions().width >= 100;
        const branch = () =>
          truncateMiddle(status()?.branch ?? '', Math.max(12, Math.min(28, dimensions().width - 90)));
        const clean = () => {
          const value = status();
          return (
            value !== undefined &&
            value.staged === 0 &&
            value.modified === 0 &&
            value.untracked === 0 &&
            value.conflicted === 0
          );
        };

        return (
          mode !== 'shell' &&
          status() && (
            <box flexShrink={0}>
              <text>
                {showBranch() && <span style={{ fg: theme.hue.purple[500] }}>{`  ${branch()}`}</span>}
                {status()!.ahead > 0 && <span style={{ fg: theme.hue.green[500] }}>{` ⇡${status()!.ahead}`}</span>}
                {status()!.behind > 0 && <span style={{ fg: theme.hue.red[500] }}>{` ⇣${status()!.behind}`}</span>}
                {status()!.staged > 0 && <span style={{ fg: theme.hue.green[500] }}>{` +${status()!.staged}`}</span>}
                {status()!.modified > 0 && (
                  <span style={{ fg: theme.hue.yellow[500] }}>{` !${status()!.modified}`}</span>
                )}
                {status()!.untracked > 0 && (
                  <span style={{ fg: theme.hue.blue[500] }}>{` ?${status()!.untracked}`}</span>
                )}
                {status()!.conflicted > 0 && (
                  <span style={{ fg: theme.hue.red[500] }}>{` ${status()!.conflicted}`}</span>
                )}
                {clean() && <span style={{ fg: theme.hue.green[500] }}> </span>}
              </text>
            </box>
          )
        );
      },
    });

    return () => {
      refreshID += 1;
      stopFilesystem();
      stopBranch();
      unregister();
    };
  },
} satisfies Plugin.Definition;

export default GitStatusPlugin;
