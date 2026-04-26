import type { ExtensionAPI, ExtensionCommandContext } from '@mariozechner/pi-coding-agent';

type Decision = 'allow' | 'ask' | 'deny';

type BashRule = {
  pattern: string;
  decision: Decision;
};

let pairModeEnabled = false;

const BASH_RULES: BashRule[] = [
  { pattern: 'kubectl get secrets', decision: 'deny' },
  { pattern: 'kubectl get secret', decision: 'deny' },
  { pattern: 'bun run *', decision: 'allow' },
  { pattern: 'git diff *', decision: 'allow' },
  { pattern: 'git log *', decision: 'allow' },
  { pattern: 'git show *', decision: 'allow' },
  { pattern: 'git status', decision: 'allow' },
  { pattern: 'kubectl get *', decision: 'allow' },
  { pattern: 'ls', decision: 'allow' },
  { pattern: 'mix *', decision: 'allow' },
  { pattern: 'npm run *', decision: 'allow' },
  { pattern: 'pnpm run *', decision: 'allow' },
  { pattern: 'pwd', decision: 'allow' },
  { pattern: 'rg *', decision: 'allow' },
  { pattern: 'head *', decision: 'allow' },
  { pattern: 'tail *', decision: 'allow' },
  { pattern: 'task *', decision: 'allow' },
  { pattern: '*', decision: 'ask' },
];

function escapeRegex(text: string): string {
  return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function globToRegExp(pattern: string): RegExp {
  const escaped = escapeRegex(pattern).replace(/\\\*/g, '[\\s\\S]*');
  return new RegExp(`^${escaped}$`);
}

function matchesPattern(value: string, pattern: string): boolean {
  return globToRegExp(pattern).test(value.trim());
}

function getBashDecision(command: string): { decision: Decision; pattern: string } {
  for (const rule of BASH_RULES) {
    if (matchesPattern(command, rule.pattern)) {
      return { decision: rule.decision, pattern: rule.pattern };
    }
  }
  return { decision: 'ask', pattern: '*' };
}

function summarizeEdit(params: any): string {
  const edits = Array.isArray(params.edits) ? params.edits.length : 0;
  return `File: ${params.path || '(unknown)'}\nReplacements: ${edits}`;
}

function summarizeWrite(params: any): string {
  const content = typeof params.content === 'string' ? params.content : '';
  const lines = content.length === 0 ? 0 : content.split('\n').length;
  return `File: ${params.path || '(unknown)'}\nLines: ${lines}`;
}

function setPairStatus(ctx: ExtensionCommandContext | any): void {
  ctx.ui.setStatus('pair-mode', pairModeEnabled ? ctx.ui.theme.fg('warning', '● pair') : undefined);
}

async function handlePairCommand(args: string | undefined, ctx: ExtensionCommandContext): Promise<void> {
  const action = (args ?? '').trim().toLowerCase();

  if (action === 'on') {
    pairModeEnabled = true;
    setPairStatus(ctx);
    ctx.ui.notify('Pair mode enabled', 'success');
    return;
  }

  if (action === 'off') {
    pairModeEnabled = false;
    setPairStatus(ctx);
    ctx.ui.notify('Pair mode disabled', 'info');
    return;
  }

  if (action === 'status') {
    ctx.ui.notify(`Pair mode is ${pairModeEnabled ? 'on' : 'off'}`, 'info');
    return;
  }

  pairModeEnabled = !pairModeEnabled;
  setPairStatus(ctx);
  ctx.ui.notify(`Pair mode ${pairModeEnabled ? 'enabled' : 'disabled'}`, pairModeEnabled ? 'success' : 'info');
}

export default function (pi: ExtensionAPI) {
  pi.on('session_start', async (_event, ctx) => {
    setPairStatus(ctx);
  });

  pi.on('before_agent_start', async () => {
    if (!pairModeEnabled) return undefined;

    return {
      message: {
        customType: 'pair-mode-context',
        content: `[PAIR MODE ACTIVE]
You are in pair programming mode.

Rules:
- Before making changes, explain briefly what you want to do.
- Most bash commands require user approval unless they match the allowlist.
- All edit and write tool calls require user approval.
- Keep changes small and easy to review.
- Prefer read-only exploration first, then ask-backed execution.`,
      },
    };
  });

  pi.on('tool_call', async (event, ctx) => {
    if (!pairModeEnabled) return undefined;

    if (event.toolName === 'bash') {
      const command = String(event.input.command ?? '');
      const { decision, pattern } = getBashDecision(command);

      if (decision === 'allow') return undefined;
      if (decision === 'deny') {
        return {
          block: true,
          reason: `Pair mode blocked bash command (rule: ${pattern})\n\n${command}`,
        };
      }

      if (!ctx.hasUI) {
        return {
          block: true,
          reason: `Pair mode requires confirmation for bash command, but no UI is available.\n\n${command}`,
        };
      }

      const confirmed = await ctx.ui.confirm('Allow bash command?', `Rule: ${pattern}\n\n${command}`);
      if (!confirmed) {
        return { block: true, reason: 'Blocked by user (pair mode)' };
      }
      return undefined;
    }

    if (event.toolName === 'edit') {
      if (!ctx.hasUI) {
        return { block: true, reason: 'Pair mode requires confirmation for edit, but no UI is available.' };
      }

      const confirmed = await ctx.ui.confirm('Allow edit?', summarizeEdit(event.input));
      if (!confirmed) {
        return { block: true, reason: 'Blocked by user (pair mode)' };
      }
      return undefined;
    }

    if (event.toolName === 'write') {
      if (!ctx.hasUI) {
        return { block: true, reason: 'Pair mode requires confirmation for write, but no UI is available.' };
      }

      const confirmed = await ctx.ui.confirm('Allow write?', summarizeWrite(event.input));
      if (!confirmed) {
        return { block: true, reason: 'Blocked by user (pair mode)' };
      }
      return undefined;
    }

    return undefined;
  });

  pi.registerCommand('pair', {
    description: 'Toggle pair mode, or use /pair on, /pair off, /pair status',
    handler: async (args, ctx) => {
      await handlePairCommand(args, ctx);
    },
  });
}
