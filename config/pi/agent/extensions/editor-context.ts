import { chmodSync, mkdirSync, watch, type FSWatcher } from 'node:fs';
import { readFile } from 'node:fs/promises';
import { homedir } from 'node:os';
import { basename, dirname, join } from 'node:path';
import type { ExtensionAPI, ExtensionContext } from '@earendil-works/pi-coding-agent';

type Position = { line: number; character: number };
type EditorRange = {
  text: string;
  selection: { start: Position; end: Position; isEmpty?: boolean };
};
type EditorSelection = {
  filePath: string;
  text?: string;
  selection?: EditorRange['selection'];
  ranges?: EditorRange[];
};
type EditorContextFile = {
  version: 1;
  herdrTabId: string;
  pid: number;
  updatedAt: number;
  selection: EditorSelection;
};

const tabId = process.env.HERDR_TAB_ID;
const contextFile = tabId
  ? join(
      process.env.XDG_CACHE_HOME || join(homedir(), '.cache'),
      'pi',
      'editor-context',
      `${tabId.replace(/[^A-Za-z0-9_.-]/g, '_')}.json`,
    )
  : undefined;

function ranges(selection: EditorSelection): EditorRange[] {
  if (selection.ranges?.length) return selection.ranges;
  if (selection.selection) return [{ text: selection.text ?? '', selection: selection.selection }];
  return [];
}

function selectionKey(selection: EditorSelection | undefined): string {
  if (!selection) return '';
  return [
    selection.filePath,
    ...ranges(selection).flatMap((range) => [
      range.selection.start.line,
      range.selection.start.character,
      range.selection.end.line,
      range.selection.end.character,
      range.text,
    ]),
  ].join('\0');
}

function hasRange(range: EditorRange): boolean {
  return (
    range.selection.start.line !== range.selection.end.line ||
    range.selection.start.character !== range.selection.end.character
  );
}

function rangeLabel(range: EditorRange): string {
  const { start, end } = range.selection;
  return start.line === end.line ? `#${start.line}` : `#${start.line}-${end.line}`;
}

function formatEditorContext(selection: EditorSelection): string {
  const selected = ranges(selection).filter(hasRange);
  if (selected.length === 0) {
    return `<system-reminder>Note: The user opened the file "${selection.filePath}". This may or may not be relevant to the current task.</system-reminder>`;
  }

  const formatted = selected.map((range, index) => {
    const prefix = selected.length > 1 ? `Selection ${index + 1}: ` : '';
    return `Note: The user selected ${prefix}${rangeLabel(range)} from "${selection.filePath}". \`\`\`${range.text}\`\`\``;
  });
  return `<system-reminder>${formatted.join('\n\n')}\n\nThis may or may not be relevant to the current task.</system-reminder>`;
}

function parseContext(content: string): EditorContextFile | undefined {
  try {
    const value = JSON.parse(content) as Partial<EditorContextFile>;
    if (
      value.version !== 1 ||
      value.herdrTabId !== tabId ||
      typeof value.pid !== 'number' ||
      typeof value.updatedAt !== 'number' ||
      !value.selection ||
      typeof value.selection.filePath !== 'string' ||
      value.selection.filePath.length === 0
    ) {
      return undefined;
    }
    process.kill(value.pid, 0);
    return value as EditorContextFile;
  } catch {
    return undefined;
  }
}

function label(selection: EditorSelection): string {
  const filename = basename(selection.filePath);
  const file = /^index\.[^./]+$/.test(filename)
    ? [basename(dirname(selection.filePath)), filename].filter(Boolean).join('/')
    : filename;
  const selected = ranges(selection).filter(hasRange);
  if (selected.length === 0) return file;
  const additional = selected.length > 1 ? ` +${selected.length - 1}` : '';
  return `${file}${rangeLabel(selected[0])}${additional}`;
}

export default function (pi: ExtensionAPI) {
  if (process.env.HERDR_ENV !== '1' || !contextFile || !tabId) return;

  let current: EditorContextFile | undefined;
  let currentKey = '';
  let pending = false;
  let watcher: FSWatcher | undefined;
  let refreshTimer: ReturnType<typeof setTimeout> | undefined;
  let activeContext: ExtensionContext | undefined;

  const updateIndicator = () => {
    if (!activeContext?.hasUI) return;
    const value = current?.selection;
    if (!value) {
      activeContext.ui.setWidget('editor-context', undefined);
      return;
    }
    const text = pending
      ? activeContext.ui.theme.fg('accent', label(value))
      : activeContext.ui.theme.fg('dim', label(value));
    activeContext.ui.setWidget('editor-context', [text], { placement: 'belowEditor' });
  };

  const setCurrent = (value: EditorContextFile | undefined) => {
    const nextKey = value ? `${value.pid}\0${selectionKey(value.selection)}` : '';
    if (nextKey !== currentKey) {
      currentKey = nextKey;
      pending = value !== undefined;
    }
    current = value;
    updateIndicator();
  };

  const refresh = () => {
    void readFile(contextFile, 'utf8')
      .then((content) => {
        setCurrent(parseContext(content));
      })
      .catch(() => {
        setCurrent(undefined);
      });
  };

  const scheduleRefresh = () => {
    if (refreshTimer) clearTimeout(refreshTimer);
    refreshTimer = setTimeout(() => {
      refreshTimer = undefined;
      refresh();
    }, 25);
    refreshTimer.unref?.();
  };

  pi.on('session_start', (_event, ctx) => {
    if (ctx.mode !== 'tui') return;
    activeContext = ctx;
    refresh();
    watcher?.close();
    try {
      mkdirSync(dirname(contextFile), { recursive: true, mode: 0o700 });
      chmodSync(dirname(contextFile), 0o700);
      const target = basename(contextFile);
      watcher = watch(dirname(contextFile), (_event, filename) => {
        const changed = filename?.toString();
        if (!changed || changed === target || changed.startsWith(`${target}.tmp.`)) scheduleRefresh();
      });
    } catch {
      // The directory is created when Neovim first publishes editor context.
    }
  });

  pi.on('before_agent_start', async () => {
    let value = current;
    try {
      value = parseContext(await readFile(contextFile, 'utf8'));
    } catch {
      value = undefined;
    }
    setCurrent(value);
    if (!value || !pending) return;

    pending = false;
    updateIndicator();
    return {
      message: {
        customType: 'editor-context',
        content: formatEditorContext(value.selection),
        display: false,
      },
    };
  });

  pi.on('session_shutdown', () => {
    watcher?.close();
    watcher = undefined;
    if (refreshTimer) clearTimeout(refreshTimer);
    refreshTimer = undefined;
    activeContext?.ui.setWidget('editor-context', undefined);
    activeContext = undefined;
  });
}
