/** @jsxImportSource @opentui/solid */
import type { Plugin } from '@opencode-ai/plugin-v2/tui';
import type { CursorStyleOptions, EditBufferRenderable, RGBA } from '@opentui/core';
import { onCleanup } from 'solid-js';

type Mode = 'normal' | 'insert' | 'visual';
type Operator = 'change' | 'delete' | undefined;
type TextObjectModifier = 'around' | 'inner' | undefined;
type TextRange = { start: number; end: number };
type ThemeScale = Record<500, RGBA>;

type VimTheme = {
  hue: {
    blue: ThemeScale;
    green: ThemeScale;
    purple: ThemeScale;
  };
  text: {
    default: RGBA;
  };
};

type PromptEditor = EditBufferRenderable & {
  traits: {
    owner?: string;
    role?: string;
  };
};

const PRINTABLE_KEYS = [
  ...'abcdefghijklmnopqrstuvwxyz',
  ...[...'abcdefghijklmnopqrstuvwxyz'].map((key) => `shift+${key}`),
  ...'0123456789',
  ...[...'0123456789'].map((key) => `shift+${key}`),
  'shift+`',
  'shift+-',
  'shift+=',
  'shift+[',
  'shift+]',
  'shift+\\',
  'shift+;',
  "shift+'",
  'shift+,',
  'shift+.',
  'shift+/',
  'space',
  '`',
  '~',
  '!',
  '@',
  '#',
  '$',
  '%',
  '^',
  '&',
  '*',
  '(',
  ')',
  '-',
  '_',
  '=',
  '+',
  '[',
  ']',
  '{',
  '}',
  '\\',
  '|',
  ';',
  ':',
  "'",
  '"',
  ',',
  '<',
  '.',
  '>',
  '/',
  '?',
];

const PENDING_CANCEL_KEYS = [
  'return',
  'enter',
  'backspace',
  'delete',
  'left',
  'right',
  'up',
  'down',
  'tab',
  ...[...'abcdefghijklmnopqrstuvwxyz'].map((key) => `ctrl+${key}`),
];

const CLOSURE_OBJECTS = [
  { binds: ['(', ')', 'shift+9', 'shift+0'], open: '(', close: ')', title: 'parentheses' },
  { binds: ['[', ']'], open: '[', close: ']', title: 'brackets' },
  { binds: ['{', '}', 'shift+[', 'shift+]'], open: '{', close: '}', title: 'braces' },
  { binds: ['"', "shift+'"], open: '"', close: '"', title: 'double quotes' },
  { binds: ["'"], open: "'", close: "'", title: 'single quotes' },
  { binds: ['`'], open: '`', close: '`', title: 'backticks' },
] as const;

const VimModePlugin = {
  id: 'dkarter.vim-mode',
  setup(ctx: Plugin.Context) {
    const [state, update] = ctx.storage.memory('vim-mode', {
      initial: {
        mode: 'insert' as Mode,
        operator: undefined as Operator,
        textObjectModifier: undefined as TextObjectModifier,
      },
    });

    let styledEditor: PromptEditor | undefined;
    let originalCursorStyle: CursorStyleOptions['style'];

    const promptEditor = (editor = ctx.renderer.currentFocusedEditor) => {
      const candidate = editor as PromptEditor | null;
      if (candidate?.traits.owner !== 'opencode' || candidate.traits.role !== 'prompt') {
        return undefined;
      }

      return candidate;
    };

    const restoreCursorStyle = () => {
      if (styledEditor && !styledEditor.isDestroyed) {
        styledEditor.cursorStyle = {
          ...styledEditor.cursorStyle,
          style: originalCursorStyle,
        };
      }
      styledEditor = undefined;
      originalCursorStyle = undefined;
    };

    const updateCursorStyle = (mode: Mode, editor = promptEditor()) => {
      if (editor !== styledEditor) {
        restoreCursorStyle();
        if (!editor) {
          return;
        }
        styledEditor = editor;
        originalCursorStyle = editor.cursorStyle.style;
      }
      if (!editor) {
        return;
      }

      editor.cursorStyle = {
        ...editor.cursorStyle,
        style: mode === 'insert' ? 'line' : 'block',
      };
    };

    const setMode = (mode: Mode) => {
      update((draft) => {
        draft.mode = mode;
        draft.operator = undefined;
        draft.textObjectModifier = undefined;
      });
      updateCursorStyle(mode);
    };

    const setOperator = (operator: Operator) => {
      update((draft) => {
        draft.operator = operator;
        draft.textObjectModifier = undefined;
      });
    };

    const setTextObjectModifier = (modifier: TextObjectModifier) => {
      update((draft) => {
        draft.textObjectModifier = modifier;
      });
    };

    const dispatch = (command: string) => {
      ctx.keymap.dispatch(command);
    };

    const promptFocused = () => {
      const route = ctx.ui.router.current();
      if (route.type !== 'home' && route.type !== 'session') {
        return false;
      }

      return promptEditor() !== undefined;
    };

    const moveWordEnd = (select = false) => {
      const editor = promptEditor();
      if (!editor || editor.cursorOffset >= editor.plainText.length - 1) {
        return;
      }

      const text = editor.plainText;
      let offset = editor.cursorOffset + 1;
      while (/\s/.test(text[offset] ?? '')) {
        offset += 1;
      }
      if (offset >= text.length) {
        return;
      }

      const wordCharacter = /[\p{L}\p{N}_]/u.test(text[offset] ?? '');
      while (offset + 1 < text.length) {
        const next = text[offset + 1] ?? '';
        if (/\s/.test(next) || /[\p{L}\p{N}_]/u.test(next) !== wordCharacter) {
          break;
        }
        offset += 1;
      }

      const destination = select ? offset + 1 : offset;
      while (editor.cursorOffset < destination) {
        editor.moveCursorRight({ select });
      }
    };

    const characterKind = (character: string) => {
      if (/\s/u.test(character)) {
        return 'space';
      }
      return /[\p{L}\p{N}_]/u.test(character) ? 'word' : 'punctuation';
    };

    const innerWordRange = (editor: PromptEditor): TextRange | undefined => {
      const text = editor.plainText;
      if (!text) {
        return undefined;
      }

      const cursor = Math.min(editor.cursorOffset, text.length - 1);
      const kind = characterKind(text[cursor] ?? '');
      let start = cursor;
      let end = cursor + 1;
      while (start > 0 && characterKind(text[start - 1] ?? '') === kind) {
        start -= 1;
      }
      while (end < text.length && characterKind(text[end] ?? '') === kind) {
        end += 1;
      }
      return { start, end };
    };

    const aroundWordRange = (editor: PromptEditor): TextRange | undefined => {
      const inner = innerWordRange(editor);
      if (!inner) {
        return undefined;
      }

      const text = editor.plainText;
      if (characterKind(text[inner.start] ?? '') === 'space') {
        let end = inner.end;
        if (end < text.length) {
          const kind = characterKind(text[end] ?? '');
          while (end < text.length && characterKind(text[end] ?? '') === kind) {
            end += 1;
          }
        }
        return { start: inner.start, end };
      }

      let end = inner.end;
      while (end < text.length && characterKind(text[end] ?? '') === 'space') {
        end += 1;
      }
      if (end > inner.end) {
        return { start: inner.start, end };
      }

      let start = inner.start;
      while (start > 0 && characterKind(text[start - 1] ?? '') === 'space') {
        start -= 1;
      }
      return { start, end: inner.end };
    };

    const isEscaped = (text: string, offset: number) => {
      let backslashes = 0;
      for (let index = offset - 1; index >= 0 && text[index] === '\\'; index -= 1) {
        backslashes += 1;
      }
      return backslashes % 2 === 1;
    };

    const quoteRange = (text: string, cursor: number, quote: string, around: boolean): TextRange | undefined => {
      const quotes: number[] = [];
      const lineStart = text.lastIndexOf('\n', cursor - 1) + 1;
      const nextNewline = text.indexOf('\n', cursor);
      const lineEnd = nextNewline === -1 ? text.length : nextNewline;
      for (let index = lineStart; index < lineEnd; index += 1) {
        if (text[index] === quote && !isEscaped(text, index)) {
          quotes.push(index);
        }
      }

      for (let index = 0; index + 1 < quotes.length; index += 2) {
        const start = quotes[index];
        const end = quotes[index + 1];
        if (start <= cursor && cursor <= end) {
          return around ? { start, end: end + 1 } : { start: start + 1, end };
        }
      }
      return undefined;
    };

    const closureRange = (
      editor: PromptEditor,
      open: string,
      close: string,
      around: boolean,
    ): TextRange | undefined => {
      const text = editor.plainText;
      if (!text) {
        return undefined;
      }

      const cursor = Math.min(editor.cursorOffset, text.length - 1);
      if (open === close) {
        return quoteRange(text, cursor, open, around);
      }

      const stack: number[] = [];
      const pairs: TextRange[] = [];
      let quote: string | undefined;
      for (let index = 0; index < text.length; index += 1) {
        const character = text[index] ?? '';
        if (character === '\n') {
          quote = undefined;
          continue;
        }
        if (quote) {
          if (character === quote && !isEscaped(text, index)) {
            quote = undefined;
          }
          continue;
        }
        if ((character === '"' || character === "'" || character === '`') && !isEscaped(text, index)) {
          quote = character;
          continue;
        }
        if (character === open) {
          stack.push(index);
        } else if (character === close) {
          const start = stack.pop();
          if (start !== undefined) {
            pairs.push({ start, end: index });
          }
        }
      }

      let enclosing: TextRange | undefined;
      for (const pair of pairs) {
        if (pair.start <= cursor && cursor <= pair.end && (!enclosing || pair.start > enclosing.start)) {
          enclosing = pair;
        }
      }
      if (!enclosing) {
        return undefined;
      }
      return around
        ? { start: enclosing.start, end: enclosing.end + 1 }
        : { start: enclosing.start + 1, end: enclosing.end };
    };

    const applyTextObject = (range: TextRange | undefined) => {
      const editor = promptEditor();
      const operator = state.operator;
      if (!editor || !operator || !range) {
        setMode('normal');
        return;
      }

      if (range.start < range.end) {
        editor.setSelection(range.start, range.end);
        editor.deleteSelection();
      }
      setMode(operator === 'change' ? 'insert' : 'normal');
    };

    const insert = (before?: string) => {
      if (before) {
        dispatch(before);
      }
      setMode('insert');
    };

    const normalCommands = [
      { bind: 'h', title: 'Move left', run: () => dispatch('input.move.left') },
      { bind: 'j', title: 'Move down', run: () => dispatch('input.move.down') },
      { bind: 'k', title: 'Move up', run: () => dispatch('input.move.up') },
      { bind: 'l', title: 'Move right', run: () => dispatch('input.move.right') },
      { bind: 'space', title: 'Move right', run: () => dispatch('input.move.right') },
      { bind: 'w', title: 'Move word forward', run: () => dispatch('input.word.forward') },
      { bind: 'e', title: 'Move to word end', run: () => moveWordEnd() },
      { bind: 'b', title: 'Move word backward', run: () => dispatch('input.word.backward') },
      { bind: '0', title: 'Move to line start', run: () => dispatch('input.line.home') },
      { bind: '$', title: 'Move to line end', run: () => dispatch('input.line.end') },
      { bind: 'g', title: 'Move to buffer start', run: () => dispatch('input.buffer.home') },
      { bind: 'shift+g', title: 'Move to buffer end', run: () => dispatch('input.buffer.end') },
      { bind: 'i', title: 'Enter insert mode', run: () => setMode('insert') },
      { bind: 'a', title: 'Append', run: () => insert('input.move.right') },
      { bind: 'shift+i', title: 'Insert at line start', run: () => insert('input.line.home') },
      { bind: 'shift+a', title: 'Append at line end', run: () => insert('input.line.end') },
      {
        bind: 'o',
        title: 'Open line below',
        run: () => {
          dispatch('input.line.end');
          dispatch('input.newline');
          setMode('insert');
        },
      },
      {
        bind: 'shift+o',
        title: 'Open line above',
        run: () => {
          dispatch('input.line.home');
          dispatch('input.newline');
          dispatch('input.move.up');
          setMode('insert');
        },
      },
      { bind: 'x', title: 'Delete character', run: () => dispatch('input.delete') },
      {
        bind: 's',
        title: 'Substitute character',
        run: () => {
          dispatch('input.delete');
          setMode('insert');
        },
      },
      { bind: 'shift+d', title: 'Delete to line end', run: () => dispatch('input.delete.to.line.end') },
      {
        bind: 'shift+c',
        title: 'Change to line end',
        run: () => {
          dispatch('input.delete.to.line.end');
          setMode('insert');
        },
      },
      { bind: 'd', title: 'Delete operator', run: () => setOperator('delete') },
      { bind: 'c', title: 'Change operator', run: () => setOperator('change') },
      { bind: 'u', title: 'Undo', run: () => dispatch('input.undo') },
      { bind: 'ctrl+r', title: 'Redo', run: () => dispatch('input.redo') },
      { bind: 'v', title: 'Enter visual mode', run: () => setMode('visual') },
      { bind: 'return', title: 'Submit prompt', run: () => dispatch('prompt.submit') },
      { bind: 'enter', title: 'Submit prompt', run: () => dispatch('prompt.submit') },
      {
        bind: 'escape',
        title: 'Interrupt session',
        run: () => dispatch('session.interrupt'),
      },
    ];

    const normalBindings = new Set(normalCommands.map((command) => command.bind));
    const normalNoops = PRINTABLE_KEYS.filter((key) => !normalBindings.has(key)).map((bind) => ({
      bind,
      title: 'Vim normal mode',
      run: () => {},
    }));
    const normalLayerCommands = [...normalCommands, ...normalNoops];

    ctx.ui.slot('app', () => {
      let disposed = false;
      const handleFocusedEditor = (editor: EditBufferRenderable | null) => {
        updateCursorStyle(state.mode, promptEditor(editor));
      };
      ctx.renderer.on('focused_editor', handleFocusedEditor);
      queueMicrotask(() => {
        if (!disposed) {
          updateCursorStyle(state.mode);
        }
      });
      onCleanup(() => {
        disposed = true;
        ctx.renderer.off('focused_editor', handleFocusedEditor);
        restoreCursorStyle();
      });

      ctx.keymap.layer(() => ({
        enabled: () => state.mode === 'insert' && promptFocused(),
        priority: 100,
        commands: [
          {
            bind: 'escape',
            title: 'Enter Vim normal mode',
            run: () => {
              dispatch('input.move.left');
              setMode('normal');
            },
          },
        ],
      }));

      ctx.keymap.layer(() => ({
        enabled: () => state.mode === 'normal' && state.operator === undefined && promptFocused(),
        priority: 100,
        commands: normalLayerCommands,
      }));

      const finishOperator = (command: string, mode: Mode = 'normal') => {
        dispatch(command);
        setMode(mode);
      };

      const createOperatorCommands = (operator: Exclude<Operator, undefined>) => {
        const changing = operator === 'change';
        const verb = changing ? 'Change' : 'Delete';
        const mode: Mode = changing ? 'insert' : 'normal';
        const finish = (command: string) => finishOperator(command, mode);
        return [
          { bind: operator[0], title: `${verb} line`, run: () => finish('input.delete.line') },
          { bind: 'w', title: `${verb} word`, run: () => finish('input.delete.word.forward') },
          { bind: 'b', title: `${verb} previous word`, run: () => finish('input.delete.word.backward') },
          { bind: '$', title: `${verb} to line end`, run: () => finish('input.delete.to.line.end') },
          { bind: '0', title: `${verb} to line start`, run: () => finish('input.delete.to.line.start') },
          { bind: 'i', title: `${verb} inner text object`, run: () => setTextObjectModifier('inner') },
          { bind: 'a', title: `${verb} around text object`, run: () => setTextObjectModifier('around') },
          { bind: 'escape', title: `Cancel ${operator}`, run: () => setOperator(undefined) },
        ];
      };

      const cancelCommands = (commands: Array<{ bind: string }>, title: string) => {
        const bindings = new Set(commands.map((command) => command.bind));
        return [...new Set([...PRINTABLE_KEYS, ...PENDING_CANCEL_KEYS])]
          .filter((key) => !bindings.has(key))
          .map((bind) => ({
            bind,
            title,
            run: () => setOperator(undefined),
          }));
      };

      const deleteCommands = createOperatorCommands('delete');
      const deleteLayerCommands = [...deleteCommands, ...cancelCommands(deleteCommands, 'Cancel delete')];

      ctx.keymap.layer(() => ({
        enabled: () =>
          state.mode === 'normal' &&
          state.operator === 'delete' &&
          state.textObjectModifier === undefined &&
          promptFocused(),
        priority: 110,
        commands: deleteLayerCommands,
      }));

      const changeCommands = createOperatorCommands('change');
      const changeLayerCommands = [...changeCommands, ...cancelCommands(changeCommands, 'Cancel change')];

      ctx.keymap.layer(() => ({
        enabled: () =>
          state.mode === 'normal' &&
          state.operator === 'change' &&
          state.textObjectModifier === undefined &&
          promptFocused(),
        priority: 110,
        commands: changeLayerCommands,
      }));

      const textObjectCommands = [
        {
          bind: 'w',
          title: 'Word text object',
          run: () => {
            const editor = promptEditor();
            applyTextObject(
              editor
                ? state.textObjectModifier === 'around'
                  ? aroundWordRange(editor)
                  : innerWordRange(editor)
                : undefined,
            );
          },
        },
        ...CLOSURE_OBJECTS.flatMap((closure) =>
          closure.binds.map((bind) => ({
            bind,
            title: `${closure.title} text object`,
            run: () => {
              const editor = promptEditor();
              applyTextObject(
                editor
                  ? closureRange(editor, closure.open, closure.close, state.textObjectModifier === 'around')
                  : undefined,
              );
            },
          })),
        ),
        { bind: 'escape', title: 'Cancel text object', run: () => setOperator(undefined) },
      ];
      const textObjectLayerCommands = [
        ...textObjectCommands,
        ...cancelCommands(textObjectCommands, 'Cancel text object'),
      ];

      ctx.keymap.layer(() => ({
        enabled: () =>
          state.mode === 'normal' &&
          state.operator !== undefined &&
          state.textObjectModifier !== undefined &&
          promptFocused(),
        priority: 120,
        commands: textObjectLayerCommands,
      }));

      const visualCommands = [
        { bind: 'h', title: 'Select left', run: () => dispatch('input.select.left') },
        { bind: 'j', title: 'Select down', run: () => dispatch('input.select.down') },
        { bind: 'k', title: 'Select up', run: () => dispatch('input.select.up') },
        { bind: 'l', title: 'Select right', run: () => dispatch('input.select.right') },
        { bind: 'space', title: 'Select right', run: () => dispatch('input.select.right') },
        { bind: 'w', title: 'Select word forward', run: () => dispatch('input.select.word.forward') },
        { bind: 'e', title: 'Select to word end', run: () => moveWordEnd(true) },
        { bind: 'b', title: 'Select word backward', run: () => dispatch('input.select.word.backward') },
        { bind: '0', title: 'Select to line start', run: () => dispatch('input.select.line.home') },
        { bind: '$', title: 'Select to line end', run: () => dispatch('input.select.line.end') },
        { bind: 'g', title: 'Select to buffer start', run: () => dispatch('input.select.buffer.home') },
        { bind: 'shift+g', title: 'Select to buffer end', run: () => dispatch('input.select.buffer.end') },
        { bind: 'x', title: 'Delete selection', run: () => finishOperator('input.delete') },
        { bind: 'd', title: 'Delete selection', run: () => finishOperator('input.delete') },
        { bind: 'c', title: 'Change selection', run: () => finishOperator('input.delete', 'insert') },
        {
          bind: 'escape',
          title: 'Exit visual mode',
          run: () => {
            dispatch('input.move.left');
            setMode('normal');
          },
        },
        {
          bind: 'v',
          title: 'Exit visual mode',
          run: () => {
            dispatch('input.move.left');
            setMode('normal');
          },
        },
      ];
      const visualBindings = new Set(visualCommands.map((command) => command.bind));
      const visualNoops = PRINTABLE_KEYS.filter((key) => !visualBindings.has(key)).map((bind) => ({
        bind,
        title: 'Vim visual mode',
        run: () => {},
      }));
      const visualLayerCommands = [...visualCommands, ...visualNoops];

      ctx.keymap.layer(() => ({
        enabled: () => state.mode === 'visual' && promptFocused(),
        priority: 100,
        commands: visualLayerCommands,
      }));

      return undefined;
    });

    ctx.ui.slot('prompt.footer.end', ({ mode }) => {
      if (mode === 'shell') {
        return undefined;
      }

      const theme = ctx.theme as unknown as VimTheme;
      const label = state.operator
        ? `${state.operator[0]}${state.textObjectModifier?.[0] ?? ''}`.toUpperCase()
        : state.mode.toUpperCase();
      const backgroundColor = {
        normal: theme.hue.blue[500],
        insert: theme.hue.green[500],
        visual: theme.hue.purple[500],
      }[state.mode];
      return (
        <box>
          <text>
            <span style={{ bg: backgroundColor, fg: theme.text.default }}>{` ${label} `}</span>
          </text>
        </box>
      );
    });
  },
} satisfies Plugin.Definition;

export default VimModePlugin;
