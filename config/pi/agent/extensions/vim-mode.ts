import { CustomEditor, type ExtensionAPI, type KeybindingsManager, type Theme } from '@earendil-works/pi-coding-agent';
import {
  matchesKey,
  truncateToWidth,
  visibleWidth,
  type EditorTheme,
  type KeyId,
  type TUI,
} from '@earendil-works/pi-tui';

type Mode = 'normal' | 'insert' | 'visual';
type Operator = 'change' | 'delete' | undefined;
type TextObjectModifier = 'around' | 'inner' | undefined;
type TextRange = { start: number; end: number };
type EditorState = { lines: string[]; cursorLine: number; cursorCol: number };
type EditorInternals = {
  state: EditorState;
  lastWidth: number;
  scrollOffset: number;
  exitHistoryBrowsing(): void;
  pushUndoSnapshot(): void;
  onChange?: (text: string) => void;
};

const CLOSURE_OBJECTS = [
  { keys: ['(', ')'], open: '(', close: ')' },
  { keys: ['[', ']'], open: '[', close: ']' },
  { keys: ['{', '}'], open: '{', close: '}' },
  { keys: ['"'], open: '"', close: '"' },
  { keys: ["'"], open: "'", close: "'" },
  { keys: ['`'], open: '`', close: '`' },
] as const;

const isKey = (data: string, key: KeyId) => matchesKey(data, key);

function wrapLine(line: string, maxWidth: number): Array<{ startIndex: number; endIndex: number }> {
  if (!line || maxWidth <= 0) return [{ startIndex: 0, endIndex: 0 }];
  if (visibleWidth(line) <= maxWidth) return [{ startIndex: 0, endIndex: line.length }];

  const segments: Array<{ character: string; index: number }> = [];
  for (let index = 0; index < line.length; ) {
    const point = line.codePointAt(index)!;
    const character = String.fromCodePoint(point);
    segments.push({ character, index });
    index += character.length;
  }

  const chunks: Array<{ startIndex: number; endIndex: number }> = [];
  let startIndex = 0;
  let width = 0;
  let wrapIndex = -1;
  let widthAtWrap = 0;
  for (let index = 0; index < segments.length; index += 1) {
    const segment = segments[index]!;
    const characterWidth = visibleWidth(segment.character);
    if (width + characterWidth > maxWidth) {
      if (wrapIndex >= 0 && width - widthAtWrap + characterWidth <= maxWidth) {
        chunks.push({ startIndex, endIndex: wrapIndex });
        startIndex = wrapIndex;
        width -= widthAtWrap;
      } else if (startIndex < segment.index) {
        chunks.push({ startIndex, endIndex: segment.index });
        startIndex = segment.index;
        width = 0;
      }
      wrapIndex = -1;
    }
    width += characterWidth;
    const next = segments[index + 1];
    if (/\s/u.test(segment.character) && next && !/\s/u.test(next.character)) {
      wrapIndex = next.index;
      widthAtWrap = width;
    }
  }
  chunks.push({ startIndex, endIndex: line.length });
  return chunks;
}

function characterKind(character: string): 'punctuation' | 'space' | 'word' {
  if (/\s/u.test(character)) return 'space';
  return /[\p{L}\p{N}_]/u.test(character) ? 'word' : 'punctuation';
}

function nextCharacter(text: string, offset: number): number {
  if (offset >= text.length) return text.length;
  return offset + (text.codePointAt(offset)! > 0xffff ? 2 : 1);
}

function previousCharacter(text: string, offset: number): number {
  if (offset <= 0) return 0;
  const candidate = offset - 1;
  const code = text.charCodeAt(candidate);
  return code >= 0xdc00 && code <= 0xdfff ? candidate - 1 : candidate;
}

function isEscaped(text: string, offset: number): boolean {
  let backslashes = 0;
  for (let index = offset - 1; index >= 0 && text[index] === '\\'; index -= 1) backslashes += 1;
  return backslashes % 2 === 1;
}

class VimEditor extends CustomEditor {
  private mode: Mode = 'insert';
  private operator: Operator;
  private textObjectModifier: TextObjectModifier;
  private visualAnchor?: number;
  private readonly originalHardwareCursor: boolean;
  private readonly vimTheme: Theme;

  constructor(tui: TUI, editorTheme: EditorTheme, keybindings: KeybindingsManager, theme: Theme) {
    super(tui, editorTheme, keybindings);
    this.originalHardwareCursor = tui.getShowHardwareCursor();
    this.vimTheme = theme;
    this.updateCursorAppearance();
  }

  private get internals(): EditorInternals {
    return this as unknown as EditorInternals;
  }

  private get cursorOffset(): number {
    const { lines, cursorLine, cursorCol } = this.internals.state;
    let offset = cursorCol;
    for (let line = 0; line < cursorLine; line += 1) offset += (lines[line]?.length ?? 0) + 1;
    return offset;
  }

  private setCursorOffset(offset: number): void {
    const state = this.internals.state;
    let remaining = Math.max(0, Math.min(offset, this.getText().length));
    for (let line = 0; line < state.lines.length; line += 1) {
      const length = state.lines[line]?.length ?? 0;
      if (remaining <= length || line === state.lines.length - 1) {
        state.cursorLine = line;
        state.cursorCol = Math.min(remaining, length);
        this.tui.requestRender();
        return;
      }
      remaining -= length + 1;
    }
  }

  private setMode(mode: Mode): void {
    this.mode = mode;
    this.operator = undefined;
    this.textObjectModifier = undefined;
    if (mode !== 'visual') this.visualAnchor = undefined;
    this.updateCursorAppearance();
    this.tui.requestRender();
  }

  private updateCursorAppearance(): void {
    const insert = this.mode === 'insert';
    this.tui.setShowHardwareCursor(insert || this.originalHardwareCursor);
    this.tui.terminal.write(insert ? '\x1b[6 q' : '\x1b[2 q');
  }

  restoreCursorAppearance(showTerminalCursor = false): void {
    this.tui.setShowHardwareCursor(this.originalHardwareCursor);
    this.tui.terminal.write(`${showTerminalCursor ? '\x1b[?25h' : ''}\x1b[0 q`);
  }

  private replaceRange(range: TextRange, replacement = '', cursor = range.start): void {
    if (range.start >= range.end) return;
    const internals = this.internals;
    internals.pushUndoSnapshot();
    internals.exitHistoryBrowsing();
    const text = this.getText();
    const next = text.slice(0, range.start) + replacement + text.slice(range.end);
    internals.state.lines = next.split('\n');
    if (internals.state.lines.length === 0) internals.state.lines = [''];
    this.setCursorOffset(cursor);
    internals.onChange?.(next);
  }

  private moveWordForward(): void {
    const text = this.getText();
    let offset = this.cursorOffset;
    if (offset >= text.length) return;
    const kind = characterKind(text[offset] ?? '');
    while (offset < text.length && characterKind(text[offset] ?? '') === kind) offset = nextCharacter(text, offset);
    while (offset < text.length && characterKind(text[offset] ?? '') === 'space') offset = nextCharacter(text, offset);
    this.setCursorOffset(offset);
  }

  private moveWordBackward(): void {
    const text = this.getText();
    let offset = previousCharacter(text, this.cursorOffset);
    while (offset > 0 && characterKind(text[offset] ?? '') === 'space') offset = previousCharacter(text, offset);
    const kind = characterKind(text[offset] ?? '');
    while (offset > 0) {
      const previous = previousCharacter(text, offset);
      if (characterKind(text[previous] ?? '') !== kind) break;
      offset = previous;
    }
    this.setCursorOffset(offset);
  }

  private moveWordEnd(): void {
    const text = this.getText();
    let offset = this.cursorOffset;
    if (offset < text.length) offset = nextCharacter(text, offset);
    while (offset < text.length && characterKind(text[offset] ?? '') === 'space') offset = nextCharacter(text, offset);
    if (offset >= text.length) {
      this.setCursorOffset(text.length);
      return;
    }
    const kind = characterKind(text[offset] ?? '');
    while (offset < text.length) {
      const next = nextCharacter(text, offset);
      if (next >= text.length || characterKind(text[next] ?? '') !== kind) break;
      offset = next;
    }
    this.setCursorOffset(offset);
  }

  private moveBufferStart(): void {
    this.setCursorOffset(0);
  }

  private moveBufferEnd(): void {
    const text = this.getText();
    this.setCursorOffset(text.length === 0 ? 0 : previousCharacter(text, text.length));
  }

  private move(data: string): boolean {
    if (isKey(data, 'h')) super.handleInput('\x1b[D');
    else if (isKey(data, 'j')) super.handleInput('\x1b[B');
    else if (isKey(data, 'k')) super.handleInput('\x1b[A');
    else if (isKey(data, 'l') || isKey(data, 'space')) super.handleInput('\x1b[C');
    else if (isKey(data, 'w')) this.moveWordForward();
    else if (isKey(data, 'e')) this.moveWordEnd();
    else if (isKey(data, 'b')) this.moveWordBackward();
    else if (isKey(data, '0')) super.handleInput('\x01');
    else if (isKey(data, '$')) super.handleInput('\x05');
    else if (isKey(data, 'g')) this.moveBufferStart();
    else if (isKey(data, 'shift+g')) this.moveBufferEnd();
    else return false;
    return true;
  }

  private currentLineRange(): TextRange {
    const { lines, cursorLine } = this.internals.state;
    let start = 0;
    for (let line = 0; line < cursorLine; line += 1) start += (lines[line]?.length ?? 0) + 1;
    const length = lines[cursorLine]?.length ?? 0;
    if (cursorLine < lines.length - 1) return { start, end: start + length + 1 };
    if (cursorLine > 0) return { start: start - 1, end: start + length };
    return { start, end: start + length };
  }

  private operatorMotion(key: string): TextRange | undefined {
    const origin = this.cursorOffset;
    if (key === 'w') this.moveWordForward();
    else if (key === 'e') this.moveWordEnd();
    else if (key === 'b') this.moveWordBackward();
    else if (key === '$') super.handleInput('\x05');
    else if (key === '0') super.handleInput('\x01');
    else return undefined;
    const destination = this.cursorOffset;
    const text = this.getText();
    return {
      start: Math.min(origin, destination),
      end:
        destination < origin
          ? nextCharacter(text, origin)
          : key === 'e'
            ? nextCharacter(text, destination)
            : Math.max(origin + 1, destination),
    };
  }

  private finishOperator(range: TextRange | undefined): void {
    const operator = this.operator;
    if (!operator || !range) {
      this.setMode('normal');
      return;
    }
    this.replaceRange(range);
    this.setMode(operator === 'change' ? 'insert' : 'normal');
  }

  private innerWordRange(): TextRange | undefined {
    const text = this.getText();
    if (!text) return undefined;
    const cursor = Math.min(this.cursorOffset, text.length - 1);
    const kind = characterKind(text[cursor] ?? '');
    let start = cursor;
    let end = nextCharacter(text, cursor);
    while (start > 0) {
      const previous = previousCharacter(text, start);
      if (characterKind(text[previous] ?? '') !== kind) break;
      start = previous;
    }
    while (end < text.length && characterKind(text[end] ?? '') === kind) end = nextCharacter(text, end);
    return { start, end };
  }

  private aroundWordRange(): TextRange | undefined {
    const inner = this.innerWordRange();
    if (!inner) return undefined;
    const text = this.getText();
    let { start, end } = inner;
    while (end < text.length && characterKind(text[end] ?? '') === 'space') end = nextCharacter(text, end);
    if (end === inner.end) {
      while (start > 0) {
        const previous = previousCharacter(text, start);
        if (characterKind(text[previous] ?? '') !== 'space') break;
        start = previous;
      }
    }
    return { start, end };
  }

  private quoteRange(quote: string, around: boolean): TextRange | undefined {
    const text = this.getText();
    const cursor = Math.min(this.cursorOffset, Math.max(0, text.length - 1));
    const lineStart = text.lastIndexOf('\n', cursor - 1) + 1;
    const nextNewline = text.indexOf('\n', cursor);
    const lineEnd = nextNewline === -1 ? text.length : nextNewline;
    const quotes: number[] = [];
    for (let index = lineStart; index < lineEnd; index += 1) {
      if (text[index] === quote && !isEscaped(text, index)) quotes.push(index);
    }
    for (let index = 0; index + 1 < quotes.length; index += 2) {
      const start = quotes[index]!;
      const end = quotes[index + 1]!;
      if (start <= cursor && cursor <= end) return around ? { start, end: end + 1 } : { start: start + 1, end };
    }
    return undefined;
  }

  private closureRange(open: string, close: string, around: boolean): TextRange | undefined {
    if (open === close) return this.quoteRange(open, around);
    const text = this.getText();
    const cursor = Math.min(this.cursorOffset, Math.max(0, text.length - 1));
    const stack: number[] = [];
    const pairs: TextRange[] = [];
    let quote: string | undefined;
    for (let index = 0; index < text.length; index += 1) {
      const character = text[index] ?? '';
      if (character === '\n') quote = undefined;
      else if (quote) {
        if (character === quote && !isEscaped(text, index)) quote = undefined;
      } else if ((character === '"' || character === "'" || character === '`') && !isEscaped(text, index))
        quote = character;
      else if (character === open) stack.push(index);
      else if (character === close) {
        const start = stack.pop();
        if (start !== undefined) pairs.push({ start, end: index });
      }
    }
    const pair = pairs
      .filter(({ start, end }) => start <= cursor && cursor <= end)
      .sort((left, right) => right.start - left.start)[0];
    if (!pair) return undefined;
    return around ? { start: pair.start, end: pair.end + 1 } : { start: pair.start + 1, end: pair.end };
  }

  private handleTextObject(data: string): void {
    if (isKey(data, 'escape')) {
      this.setMode('normal');
      return;
    }
    if (isKey(data, 'w')) {
      this.finishOperator(this.textObjectModifier === 'around' ? this.aroundWordRange() : this.innerWordRange());
      return;
    }
    for (const object of CLOSURE_OBJECTS) {
      if (object.keys.some((key) => isKey(data, key as KeyId))) {
        this.finishOperator(this.closureRange(object.open, object.close, this.textObjectModifier === 'around'));
        return;
      }
    }
    this.setMode('normal');
  }

  private handleOperator(data: string): void {
    if (isKey(data, 'escape')) {
      this.setMode('normal');
      return;
    }
    if (isKey(data, 'i')) {
      this.textObjectModifier = 'inner';
      this.tui.requestRender();
      return;
    }
    if (isKey(data, 'a')) {
      this.textObjectModifier = 'around';
      this.tui.requestRender();
      return;
    }
    if (this.textObjectModifier) {
      this.handleTextObject(data);
      return;
    }
    const repeated =
      (this.operator === 'delete' && isKey(data, 'd')) || (this.operator === 'change' && isKey(data, 'c'));
    if (repeated) this.finishOperator(this.currentLineRange());
    else if (isKey(data, 'w')) this.finishOperator(this.operatorMotion('w'));
    else if (isKey(data, 'e')) this.finishOperator(this.operatorMotion('e'));
    else if (isKey(data, 'b')) this.finishOperator(this.operatorMotion('b'));
    else if (isKey(data, '$')) this.finishOperator(this.operatorMotion('$'));
    else if (isKey(data, '0')) this.finishOperator(this.operatorMotion('0'));
    else this.setMode('normal');
  }

  private handleNormal(data: string): void {
    if (this.operator) {
      this.handleOperator(data);
      return;
    }
    if (this.move(data)) return;
    if (isKey(data, 'i')) this.setMode('insert');
    else if (isKey(data, 'a')) {
      super.handleInput('\x1b[C');
      this.setMode('insert');
    } else if (isKey(data, 'shift+i')) {
      super.handleInput('\x01');
      this.setMode('insert');
    } else if (isKey(data, 'shift+a')) {
      super.handleInput('\x05');
      this.setMode('insert');
    } else if (isKey(data, 'o')) {
      super.handleInput('\x05');
      super.handleInput('\n');
      this.setMode('insert');
    } else if (isKey(data, 'shift+o')) {
      super.handleInput('\x01');
      super.handleInput('\n');
      super.handleInput('\x1b[A');
      this.setMode('insert');
    } else if (isKey(data, 'x'))
      this.replaceRange({ start: this.cursorOffset, end: nextCharacter(this.getText(), this.cursorOffset) });
    else if (isKey(data, 's')) {
      this.replaceRange({ start: this.cursorOffset, end: nextCharacter(this.getText(), this.cursorOffset) });
      this.setMode('insert');
    } else if (isKey(data, 'shift+d') || isKey(data, 'shift+c')) {
      const start = this.cursorOffset;
      super.handleInput('\x05');
      this.replaceRange({ start, end: this.cursorOffset });
      this.setMode(isKey(data, 'shift+c') ? 'insert' : 'normal');
    } else if (isKey(data, 'd') || isKey(data, 'c')) {
      this.operator = isKey(data, 'd') ? 'delete' : 'change';
      this.tui.requestRender();
    } else if (isKey(data, 'u')) super.handleInput('\x1f');
    else if (isKey(data, 'ctrl+r')) return;
    else if (isKey(data, 'v')) {
      this.visualAnchor = this.cursorOffset;
      this.setMode('visual');
      this.visualAnchor = this.cursorOffset;
    } else if (isKey(data, 'enter') || isKey(data, 'return')) super.handleInput(data);
    else if (isKey(data, 'escape')) super.handleInput(data);
    else if (data.length > 1 || data.charCodeAt(0) < 32) super.handleInput(data);
  }

  private visualRange(): TextRange | undefined {
    if (this.visualAnchor === undefined) return undefined;
    const cursor = this.cursorOffset;
    const text = this.getText();
    return {
      start: Math.min(this.visualAnchor, cursor),
      end: nextCharacter(text, Math.max(this.visualAnchor, cursor)),
    };
  }

  private handleVisual(data: string): void {
    if (this.move(data)) return;
    if (isKey(data, 'escape') || isKey(data, 'v')) {
      this.setMode('normal');
      return;
    }
    if (isKey(data, 'x') || isKey(data, 'd') || isKey(data, 'c')) {
      const range = this.visualRange();
      if (range) this.replaceRange(range);
      this.setMode(isKey(data, 'c') ? 'insert' : 'normal');
      return;
    }
    if (data.length > 1 || data.charCodeAt(0) < 32) super.handleInput(data);
  }

  handleInput(data: string): void {
    if (this.mode === 'insert') {
      if (isKey(data, 'escape') && !this.isShowingAutocomplete()) {
        super.handleInput('\x1b[D');
        this.setMode('normal');
        return;
      }
      super.handleInput(data);
      return;
    }
    if (this.mode === 'visual') this.handleVisual(data);
    else this.handleNormal(data);
  }

  private selectedLayoutRanges(): Array<TextRange | undefined> {
    const selected = this.mode === 'visual' ? this.visualRange() : undefined;
    const width = this.internals.lastWidth;
    const ranges: Array<TextRange | undefined> = [];
    let lineOffset = 0;
    for (const line of this.getLines()) {
      const chunks = wrapLine(line, width);
      for (const chunk of chunks) {
        const start = lineOffset + chunk.startIndex;
        const end = lineOffset + chunk.endIndex;
        if (!selected || selected.end <= start || selected.start >= end) ranges.push(undefined);
        else ranges.push({ start: Math.max(selected.start, start) - start, end: Math.min(selected.end, end) - start });
      }
      lineOffset += line.length + 1;
    }
    return ranges;
  }

  private styleRawRange(line: string, range: TextRange): string {
    const marker = '\0';
    const themed = this.vimTheme.bg('selectedBg', marker);
    const markerIndex = themed.indexOf(marker);
    const prefix = themed.slice(0, markerIndex);
    const suffix = themed.slice(markerIndex + 1);
    let result = '';
    let rawOffset = 0;
    let styled = false;
    for (let index = 0; index < line.length; ) {
      if (rawOffset === range.start && !styled) {
        result += prefix;
        styled = true;
      }
      if (rawOffset === range.end && styled) {
        result += suffix;
        styled = false;
      }
      if (line[index] === '\x1b') {
        const rest = line.slice(index);
        const csi = rest.match(/^\x1b\[[0-?]*[ -/]*[@-~]/)?.[0];
        const apcBellEnd = rest.startsWith('\x1b_') ? rest.indexOf('\x07') : -1;
        const apcStringEnd = rest.startsWith('\x1b_') ? rest.indexOf('\x1b\\') : -1;
        const apc =
          apcBellEnd >= 0
            ? rest.slice(0, apcBellEnd + 1)
            : apcStringEnd >= 0
              ? rest.slice(0, apcStringEnd + 2)
              : undefined;
        const sequence = csi ?? apc ?? rest.slice(0, 2);
        result += sequence;
        index += sequence.length;
        if (styled && sequence === '\x1b[0m') result += prefix;
        continue;
      }
      const point = line.codePointAt(index)!;
      const length = point > 0xffff ? 2 : 1;
      result += line.slice(index, index + length);
      rawOffset += length;
      index += length;
    }
    if (styled) result += suffix;
    return result;
  }

  render(width: number): string[] {
    const lines = super.render(width);
    const layoutRanges = this.selectedLayoutRanges();
    const scrollOffset = this.internals.scrollOffset;
    const visibleCount = Math.max(
      0,
      Math.min(layoutRanges.length - scrollOffset, Math.max(5, Math.floor(this.tui.terminal.rows * 0.3))),
    );
    const padding = this.getPaddingX();
    for (let index = 0; index < visibleCount; index += 1) {
      const lineIndex = index + 1;
      const range = layoutRanges[scrollOffset + index];
      if (range)
        lines[lineIndex] = this.styleRawRange(lines[lineIndex]!, {
          start: range.start + padding,
          end: range.end + padding,
        });
      if (this.mode === 'insert') lines[lineIndex] = lines[lineIndex]!.replace(/\x1b\[7m([\s\S]*?)\x1b\[0m/, '$1');
    }

    const pending = this.operator
      ? `${this.operator[0]}${this.textObjectModifier?.[0] ?? ''}`.toUpperCase()
      : undefined;
    const labelText = ` ${pending ?? this.mode.toUpperCase()} `;
    const color = this.mode === 'insert' ? 'success' : this.mode === 'visual' ? 'warning' : 'accent';
    const label = this.vimTheme.inverse(this.vimTheme.bold(this.vimTheme.fg(color, labelText)));
    const borderIndex = Math.min(lines.length - 1, visibleCount + 1);
    lines[borderIndex] = truncateToWidth(lines[borderIndex]!, Math.max(0, width - visibleWidth(label)), '') + label;
    return lines;
  }
}

export default function (pi: ExtensionAPI) {
  let editor: VimEditor | undefined;

  pi.on('session_start', (_event, ctx) => {
    if (ctx.mode !== 'tui') return;
    ctx.ui.setEditorComponent((tui, editorTheme, keybindings) => {
      editor = new VimEditor(tui, editorTheme, keybindings, ctx.ui.theme);
      return editor;
    });
  });

  pi.on('session_shutdown', (event) => {
    editor?.restoreCursorAppearance(event.reason === 'quit');
    editor = undefined;
  });
}
