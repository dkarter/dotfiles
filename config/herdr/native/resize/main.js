import { View, div } from 'gpui-kit';
import { checking, closeOverlay, exec, focused, home, notify, panes, props, run, spaces } from 'herdr';

function divider(node, pane, axis, step) {
  if (node.id === pane) return { found: true };

  const children = (node.children ?? []).filter((child) => !child.hidden);
  for (const [index, child] of children.entries()) {
    const result = divider(child, pane, axis, step);
    if (!result) continue;
    if (result.pair || node.type !== axis) return result;

    if (child.size?.px != null) return result;
    for (const offset of [step, -step]) {
      const sibling = children[index + offset];
      if (sibling && sibling.size?.px == null) {
        return { found: true, pair: offset > 0 ? [child, sibling] : [sibling, child] };
      }
    }
    return result;
  }
}

async function readLayout(machine) {
  const request = JSON.stringify({
    jsonrpc: '2.0',
    id: 1,
    method: 'doc.get',
    params: { name: 'herdr-app', on: machine },
  });
  const { code, stdout, stderr } = await exec(
    '/bin/sh',
    ['-c', 'printf "%s\\n" "$1" | "$2" connect', 'read-herdr-layout', request, `${home()}/.local/bin/hc`],
    { timeout: 2000 },
  );
  if (code !== 0) throw new Error(stderr.trim() || 'Could not read the Herdr layout');
  const response = JSON.parse(stdout);
  if (response.error) throw new Error(response.error.message);
  return response.result.value;
}

export default class Resize extends View {
  init(_, cx) {
    if (checking()) return;
    const { overlay, direction } = props();
    cx.spawn(async () => {
      try {
        await this.resize(direction);
      } catch (error) {
        notify({ title: 'Resize pane', body: String(error), level: 'warning' });
      } finally {
        closeOverlay(overlay);
      }
    });
  }

  async resize(direction) {
    const current = focused();
    if (!current?.pane || panes().some((pane) => pane.pane === current.pane && pane.zoomed)) return;
    const machine = spaces().find(({ id }) => id === current.space)?.machine ?? null;
    const local = (id) => (machine ? id.slice(machine.length + 1) : id);
    const document = await readLayout(machine);
    if (focused()?.pane !== current.pane) return;

    const tab = document?.spaces
      .find(({ id }) => id === local(current.space))
      ?.tabs.find(({ id }) => id === local(current.tab));
    if (!tab?.root) return;
    const axis = ['left', 'right'].includes(direction) ? 'row' : 'column';
    const step = ['left', 'up'].includes(direction) ? -1 : 1;
    const pair = divider(tab.root, local(current.pane), axis, step)?.pair;
    if (!pair) return;

    const [a, b] = pair;
    const first = a.size?.weight ?? 1;
    const total = first + (b.size?.weight ?? 1);
    const limit = total * 0.1;
    const next = step < 0 ? Math.max(limit, first - total * 0.05) : Math.min(total - limit, first + total * 0.05);
    if ((next - first) * step <= 0) return;
    const id = (node) => (machine ? `${machine}/${node.id}` : node.id);
    run('layout.resize', { id: id(a), weight: next });
    run('layout.resize', { id: id(b), weight: total - next });
  }

  render() {
    return div().w(0).h(0);
  }
}
