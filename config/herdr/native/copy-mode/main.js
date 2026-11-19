import { View, div } from 'gpui-kit';
import { checking, closeOverlay, focused, hc, panes, props, run, terminals, theme } from 'herdr';

const motions = {
  h: 'left',
  j: 'down',
  k: 'up',
  l: 'right',
  left: 'left',
  down: 'down',
  up: 'up',
  right: 'right',
  pageup: 'page_up',
  pagedown: 'page_down',
  'ctrl-b': 'page_up',
  'ctrl-f': 'page_down',
  'ctrl-u': 'half_up',
  'ctrl-d': 'half_down',
  g: 'home',
  'shift-g': 'end',
  0: 'line_start',
  home: 'line_start',
  $: 'line_end',
  'shift-4': 'line_end',
  end: 'line_end',
};

const wordKeys = { w: 'w', b: 'b', e: 'e', 'shift-w': 'W', 'shift-b': 'B', 'shift-e': 'E' };

function pageDelta(direction, page) {
  if (direction === 'page_up') return -page;
  if (direction === 'page_down') return page;
  const half = Math.max(1, Math.floor(page / 2));
  if (direction === 'half_up') return -half;
  if (direction === 'half_down') return half;
  return 0;
}

function wordDestination(text, firstRow, at, motion) {
  const big = motion === motion.toUpperCase();
  const pattern = big ? /\S+/gu : /[\p{L}\p{N}\p{M}_]+|[^\s\p{L}\p{N}\p{M}_]+/gu;
  const action = motion.toLowerCase();
  const lines = text.split('\n');
  if (action === 'b') lines.reverse();
  for (const [index, line] of lines.entries()) {
    const row = firstRow + (action === 'b' ? lines.length - 1 - index : index);
    if (action === 'b' ? row > at.row : row < at.row) continue;
    const words = [...line.matchAll(pattern)];
    if (action === 'b') words.reverse();
    for (const word of words) {
      const index = word.index + (action === 'e' ? word[0].length - 1 : 0);
      const col = [...line.slice(0, index)].length;
      if (row !== at.row || (action === 'b' ? col < at.col : col > at.col)) return { row, col };
    }
  }
}

export default class CopyMode extends View {
  init(_, cx) {
    this.handle = cx.focus_handle();
    if (checking()) return;
    this.handle.focus();
    const pane = focused();
    this.pane = pane?.pane;
    this.terminal = pane?.shown ?? pane?.terminal;
    this.selecting = false;
    const scroll = this.scrollState();
    if (this.terminal) {
      if (scroll?.from_bottom > 0) this.placeCursor({ row: scroll.offset + scroll.len - 1, col: 0 }, scroll);
      else this.command('select');
    } else closeOverlay(props().overlay);
  }

  command(name, args) {
    run(`terminal.${name}`, { terminal: this.terminal, ...args });
  }

  terminalState() {
    return terminals().find(({ address }) => address === this.terminal);
  }

  scrollState() {
    return panes().find(({ pane }) => pane === this.pane)?.scroll;
  }

  placeCursor(at, scroll, delta = 0) {
    this.cursor = at;
    this.command('select', { at });
    this.reveal(at.row, scroll, delta);
  }

  reveal(row, scroll, delta = 0) {
    if (!scroll) return;
    const max = scroll.total - scroll.len;
    // Anchor scrolling from the bottom. A relative delta from the reported
    // viewport can be stale when several motions are queued in the same frame.
    const offset = Math.max(0, Math.min(row, Math.max(scroll.offset + delta, row - scroll.len + 1), max));
    if (offset === scroll.offset) return;
    this.command('scroll', { to: 'bottom' });
    if (offset !== max) this.command('scroll', { lines: offset - max });
  }

  moveCursor(direction) {
    const terminal = this.terminalState();
    const at = this.cursor ?? terminal?.selection?.end;
    if (!at) return;

    const scroll = this.scrollState();
    const rows = scroll?.total ?? terminal.rows;
    const page = scroll?.len ?? terminal.rows;
    const cols = terminal.cols;
    if (!(rows > 0 && page > 0 && cols > 0)) return;

    let { row, col } = at;
    const delta = pageDelta(direction, page);
    if (delta) row += delta;
    else if (direction === 'left') col--;
    else if (direction === 'right') col++;
    else if (direction === 'up') row--;
    else if (direction === 'down') row++;
    else if (direction === 'line_start') col = 0;
    else if (direction === 'line_end') col = cols - 1;
    else if (direction === 'home') [row, col] = [0, 0];
    else if (direction === 'end') [row, col] = [rows - 1, cols - 1];
    row = Math.max(0, Math.min(row, rows - 1));
    col = Math.max(0, Math.min(col, cols - 1));
    this.placeCursor({ row, col }, scroll, delta);
  }

  moveSelection(direction) {
    const scroll = this.scrollState();
    const target = this.terminalState()?.selection?.end;
    const delta = pageDelta(direction, scroll?.len ?? this.terminalState()?.rows ?? 1);
    if (direction !== 'half_up' && direction !== 'half_down') {
      this.command('adjust_selection', { direction });
    } else {
      for (let i = 0; i < Math.abs(delta); i++) {
        this.command('adjust_selection', { direction: delta < 0 ? 'up' : 'down' });
      }
    }
    if (delta && target) this.reveal(target.row + delta, scroll, delta);
  }

  async moveWord(motion) {
    const terminal = this.terminalState();
    const at = (this.selecting ? null : this.cursor) ?? terminal?.selection?.end;
    if (!at) return;
    const scroll = this.scrollState();
    const history = scroll ? scroll.total - scroll.len : 0;
    const count = Math.max(0, history - at.row + 64);
    const result = await hc(['read', this.terminal, '--json', '--lines', `${count}`]);
    if (this.closed || result.code !== 0) return;
    const { text } = JSON.parse(result.stdout);
    const lines = text.replace(/\r?\n$/, '').replace(/\r/g, '');
    const firstRow = Math.max(0, (scroll?.total ?? terminal.rows) - lines.split('\n').length);
    const target = wordDestination(lines, firstRow, at, motion);
    if (!target) return;
    if (!this.selecting) {
      this.placeCursor(target, this.scrollState());
      return;
    }
    const vertical = target.row - at.row;
    const horizontal = target.col - at.col;
    for (let i = 0; i < Math.abs(vertical); i++) {
      this.command('adjust_selection', { direction: vertical < 0 ? 'up' : 'down' });
    }
    for (let i = 0; i < Math.abs(horizontal); i++) {
      this.command('adjust_selection', { direction: horizontal < 0 ? 'left' : 'right' });
    }
  }

  close() {
    this.closed = true;
    if (this.terminal) this.command('clear_selection');
  }

  key(e, cx) {
    cx.stop_propagation();
    if (!this.terminal) return;
    const key = e.keystroke;
    if (Object.hasOwn(wordKeys, key)) {
      // Avoid racing two reads of the selection while a word motion is pending.
      if (this.wordPending) return;
      this.wordPending = true;
      cx.spawn(async () => {
        try {
          await this.moveWord(wordKeys[key]);
        } catch (error) {
          console.warn('Copy-mode word motion failed:', error);
        } finally {
          this.wordPending = false;
        }
      });
    } else if (Object.hasOwn(motions, key)) {
      if (this.wordPending) return;
      const direction = motions[key];
      if (this.selecting) this.moveSelection(direction);
      else this.moveCursor(direction);
    } else if (['v', 'space', 'shift-v'].includes(key)) {
      const at = (!this.selecting && this.cursor) || this.terminalState()?.selection?.end;
      if (!at) return;
      this.selecting = true;
      this.command('select', { at, mode: key === 'shift-v' ? 'line' : 'cell' });
      cx.notify();
    } else if (key === 'y' || key === 'enter') {
      if (this.selecting) run('terminal.copy');
      closeOverlay(props().overlay);
    } else if (key === 'q' || key === 'escape' || key === 'ctrl-c') {
      closeOverlay(props().overlay);
    }
  }

  render() {
    const t = theme();
    return div()
      .id('copy-mode')
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .p(10)
      .text_color(t.foreground)
      .child(
        this.selecting
          ? 'COPY MODE · hjkl move · y / Enter copy · Esc exit'
          : 'COPY MODE · hjkl move · v select · V select line · Esc exit',
      );
  }
}
