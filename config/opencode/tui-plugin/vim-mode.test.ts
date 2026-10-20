import { afterEach, describe, expect, mock, test } from 'bun:test';
import type { Plugin } from '@opencode/plugin/tui';
import * as core from '@opentui/core';
import { createRoot } from 'solid-js';
import { createStore, produce } from 'solid-js/store';

import VimModePlugin from './vim-mode';

const cleanups: Array<() => void> = [];
afterEach(() => {
  cleanups
    .splice(0)
    .reverse()
    .forEach((cleanup) => cleanup());
  mock.restore();
});

const setup = () => {
  const layers: Array<() => { enabled: () => boolean; commands: Array<{ bind: string; run: () => void }> }> = [];
  const listeners = new Map<string, (editor: unknown) => void>();
  const buffer = core.EditBuffer.create('wcwidth');
  buffer.setText('hello');
  cleanups.push(() => buffer.destroy());
  let selection: { start: number; end: number } | null = null;
  const editor = {
    traits: { owner: 'opencode', role: 'prompt' },
    cursorStyle: { style: 'line' },
    isDestroyed: false,
    get cursorOffset() {
      return buffer.getCursorPosition().offset;
    },
    set cursorOffset(offset: number) {
      buffer.setCursorByOffset(offset);
    },
    get plainText() {
      return buffer.getText();
    },
    hasSelection: false,
    lineCount: 1,
    editBuffer: buffer,
    setSelection(start: number, end: number) {
      selection = { start, end };
      this.hasSelection = true;
    },
    getSelectedText() {
      return selection ? buffer.getTextRange(selection.start, selection.end) : '';
    },
    insertText(text: string) {
      if (selection) {
        const start = buffer.offsetToPosition(selection.start)!;
        const end = buffer.offsetToPosition(selection.end)!;
        buffer.deleteRange(start.row, start.col, end.row, end.col);
        this.cursorOffset = selection.start;
        selection = null;
        this.hasSelection = false;
      }
      buffer.insertText(text);
    },
    undo: () => buffer.undo(),
    redo: () => buffer.redo(),
    clear() {
      buffer.clear();
    },
    clearSelectionCount: 0,
    clearSelection() {
      this.clearSelectionCount += 1;
      this.hasSelection = false;
      selection = null;
    },
  };
  let focusedEditor: unknown = editor;
  let appSlot: (() => unknown) | undefined;
  const dispatch = mock((command: string) => {
    if (command === 'prompt.submit') editor.clear();
    if (command === 'prompt.paste') editor.insertText('clipboard');
  });
  const toast = mock(() => {});
  const copy = mock((_text: string) => true);

  createRoot((dispose) => {
    cleanups.push(dispose);
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
        capabilities: { remote: false, osc52_support: 'supported' },
        copyToClipboardOSC52: copy,
        get currentFocusedEditor() {
          return focusedEditor;
        },
        on: (event: string, listener: (editor: unknown) => void) => listeners.set(event, listener),
        off: (event: string) => listeners.delete(event),
      },
      ui: {
        toast: { show: toast },
        router: { current: () => ({ type: 'home' }) },
        slot: ({ append, render }: { append: string; render: () => unknown }) => {
          if (append === 'app') appSlot = render;
        },
      },
      keymap: { layer: (layer: (typeof layers)[number]) => layers.push(layer), dispatch },
    } as unknown as Plugin.Context;
    VimModePlugin.setup(ctx);
    appSlot?.();
    listeners.get('focused_editor')?.(editor);
    Object.defineProperty(editor, 'mode', { get: () => state.mode });
  });

  const press = (bind: string) => {
    const command = layers
      .map((layer) => layer())
      .filter((layer) => layer.enabled())
      .flatMap((layer) => layer.commands)
      .find((command) => command.bind === bind);
    expect(command).toBeDefined();
    return command!.run();
  };
  return {
    editor: editor as typeof editor & { mode: string },
    press,
    dispatch,
    toast,
    copy,
    listeners,
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
      editor.cursorOffset = editor.plainText.length;
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
      editor.cursorOffset = editor.plainText.length;
      editor.insertText('!');
      expect(editor.mode).toBe('insert');
      expect(editor.clearSelectionCount).toBe(1);
      expect(editor.plainText).toBe('hello!');
    });
  }
});

describe('vim clipboard', () => {
  for (const mode of ['v', 'shift+v']) {
    test(`${mode}: y copies selected text and exits without editing`, async () => {
      const { editor, press, copy } = setup();
      expect(copy).not.toHaveBeenCalled();
      press('escape');
      press(mode);
      editor.setSelection(1, 4);
      await press('y');
      expect(copy).toHaveBeenCalledWith('ell');
      expect(editor.plainText).toBe('hello');
      expect(editor.mode).toBe('normal');
      expect(editor.hasSelection).toBe(false);
      expect(editor.editBuffer.canUndo()).toBe(false);
    });

    test(`${mode}: p sends the intact selection to the built-in paste command`, () => {
      const { editor, press, dispatch } = setup();
      press('escape');
      press(mode);
      editor.setSelection(1, 4);
      press('p');
      expect(dispatch).toHaveBeenLastCalledWith('prompt.paste');
      expect(editor.plainText).toBe('hclipboardo');
      expect(editor.mode).toBe('normal');
    });
  }

  test('normal p inserts at the cursor and replaces mouse selections too', () => {
    const { editor, press } = setup();
    press('escape');
    editor.cursorOffset = 2;
    press('p');
    expect(editor.plainText).toBe('heclipboardllo');
    editor.setSelection(0, editor.plainText.length);
    press('p');
    expect(editor.plainText).toBe('clipboard');
  });

  test('failed yank keeps the selection and reports an error', async () => {
    const { editor, press, toast, copy } = setup();
    copy.mockReturnValue(false);
    press('escape');
    press('v');
    editor.setSelection(0, 2);
    await press('y');
    expect(editor.mode).toBe('visual');
    expect(editor.hasSelection).toBe(true);
    expect(toast).toHaveBeenCalledTimes(1);
  });

  test('no selection does not touch the clipboard', async () => {
    const { press, copy } = setup();
    press('escape');
    await press('y');
    expect(copy).not.toHaveBeenCalled();
  });
});

describe('vim native history', () => {
  test('u undoes edits and ctrl+r redoes them without dispatching nonexistent commands', () => {
    const { editor, press, dispatch } = setup();
    editor.cursorOffset = 5;
    editor.insertText('!');
    press('escape');
    press('u');
    expect(editor.plainText).toBe('hello');
    press('ctrl+r');
    expect(editor.plainText).toBe('hello!');
    expect(dispatch.mock.calls.map(([command]) => command)).toEqual(['input.move.left']);
  });

  test('empty undo/redo stacks still consume the key instead of invoking session shortcuts', () => {
    const { press } = setup();
    press('escape');
    expect(press('u')).toBeUndefined();
    expect(press('ctrl+r')).toBeUndefined();
  });

  for (const submit of ['return', 'enter']) {
    test(`${submit} submission resets both native history stacks`, () => {
      const { editor, press } = setup();
      editor.insertText('!');
      press('escape');
      press('u');
      expect(editor.editBuffer.canRedo()).toBe(true);
      press(submit);
      expect(editor.plainText).toBe('');
      expect(editor.editBuffer.canUndo()).toBe(false);
      expect(editor.editBuffer.canRedo()).toBe(false);
      press('u');
      press('ctrl+r');
      expect(editor.plainText).toBe('');
    });
  }

  test('insert-mode submission reset clears history without intercepting enter', () => {
    const { editor } = setup();
    editor.insertText('!');
    editor.clear();
    expect(editor.editBuffer.canUndo()).toBe(false);
    expect(editor.editBuffer.canRedo()).toBe(false);
  });

  test('deleting all text remains undoable; new edits discard redo', () => {
    const { editor, press } = setup();
    press('escape');
    editor.setSelection(0, 5);
    editor.insertText('');
    press('u');
    expect(editor.plainText).toBe('hello');
    editor.insertText('new');
    expect(editor.editBuffer.canRedo()).toBe(false);
  });

  test('focus cleanup restores the original clear method', () => {
    const { editor, blur, focus } = setup();
    const wrapped = editor.clear;
    blur();
    expect(editor.clear).not.toBe(wrapped);
    focus();
    editor.insertText('!');
    editor.clear();
    expect(editor.editBuffer.canUndo()).toBe(false);
  });
});
