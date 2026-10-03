import { describe, expect, test } from 'bun:test';
import type { Plugin } from '@opencode/plugin/tui';
import { createRoot } from 'solid-js';
import { createStore, produce } from 'solid-js/store';

import VimModePlugin from './vim-mode';

const setup = () => {
  const layers: Array<() => { enabled: () => boolean; commands: Array<{ bind: string; run: () => void }> }> = [];
  const listeners = new Map<string, (editor: unknown) => void>();
  const editor = {
    traits: { owner: 'opencode', role: 'prompt' },
    cursorStyle: { style: 'line' },
    isDestroyed: false,
    cursorOffset: 0,
    plainText: 'hello',
    hasSelection: false,
    lineCount: 1,
    editBuffer: {
      offsetToPosition: () => ({ row: 0 }),
      getLineStartOffset: () => 0,
    },
    setSelection(_start: number, _end: number) {
      this.hasSelection = true;
    },
    insertText(text: string) {
      this.plainText = this.hasSelection ? text : this.plainText + text;
    },
    clearSelectionCount: 0,
    clearSelection() {
      this.clearSelectionCount += 1;
      this.hasSelection = false;
    },
  };
  let focusedEditor: unknown = editor;
  let appSlot: (() => unknown) | undefined;

  createRoot(() => {
    const [state, update] = createStore({
      mode: 'insert',
      operator: undefined as string | undefined,
      textObjectModifier: undefined as string | undefined,
    });
    const ctx = {
      storage: {
        memory: () => [state, (callback: (draft: typeof state) => void) => update(produce(callback))],
      },
      renderer: {
        get currentFocusedEditor() {
          return focusedEditor;
        },
        on: (event: string, listener: (editor: unknown) => void) => listeners.set(event, listener),
        off: (event: string) => listeners.delete(event),
      },
      ui: {
        router: { current: () => ({ type: 'home' }) },
        slot: ({ append, render }: { append: string; render: () => unknown }) => {
          if (append === 'app') appSlot = render;
        },
      },
      keymap: { layer: (layer: (typeof layers)[number]) => layers.push(layer), dispatch: () => {} },
    } as unknown as Plugin.Context;
    VimModePlugin.setup(ctx);
    appSlot?.();
    Object.defineProperty(editor, 'mode', { get: () => state.mode });
  });

  const press = (bind: string) => {
    const command = layers
      .map((layer) => layer())
      .filter((layer) => layer.enabled())
      .flatMap((layer) => layer.commands)
      .find((command) => command.bind === bind);
    expect(command).toBeDefined();
    command!.run();
  };
  return {
    editor: editor as typeof editor & { mode: string },
    press,
    blur: () => {
      focusedEditor = null;
      listeners.get('focused_editor')?.(null);
    },
    focus: () => {
      focusedEditor = editor;
      listeners.get('focused_editor')?.(editor);
    },
  };
};

describe('vim visual mode recovery', () => {
  for (const visualKey of ['v', 'shift+v']) {
    test(`${visualKey} followed by i returns to insert mode without deleting the selection`, () => {
      const { editor, press } = setup();
      press('escape');
      press(visualKey);
      editor.setSelection(0, 2);
      expect(editor.mode).toBe(visualKey === 'v' ? 'visual' : 'visual-line');
      press('i');
      editor.insertText('!');
      expect(editor.mode).toBe('insert');
      expect(editor.clearSelectionCount).toBe(1);
      expect(editor.plainText).toBe('hello!');
    });

    test(`${visualKey} does not remain active after the prompt loses focus`, () => {
      const { editor, press, blur, focus } = setup();
      press('escape');
      press(visualKey);
      editor.setSelection(0, 2);
      blur();
      focus();
      expect(editor.mode).toBe('normal');
      press('i');
      editor.insertText('!');
      expect(editor.mode).toBe('insert');
      expect(editor.clearSelectionCount).toBe(1);
      expect(editor.plainText).toBe('hello!');
    });
  }
});
