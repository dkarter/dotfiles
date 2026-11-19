import { View, div } from 'gpui-kit';
import { checking, closeOverlay, focused, hc, notify, props, run, terminals } from 'herdr';

export default class Navigate extends View {
  init() {
    if (checking()) return;
    const { overlay, direction, key } = props();
    const pane = focused();
    const address = pane?.shown ?? pane?.terminal;
    const terminal = terminals().find((item) => item.address === address);
    const program = terminal?.foreground?.name ?? terminal?.program?.key;

    if (/^(nvim(?:-.*)?|vim|view|lvim|vi)$/.test(program ?? '')) {
      // The editor handles the key and only moves Herdr focus at a split edge.
      hc(['keys', address, `ctrl+${key}`])
        .then(({ code, stderr }) => {
          if (code !== 0) throw new Error(stderr.trim() || 'Could not send the key to the editor');
        })
        .catch((error) => notify({ title: 'Pane navigation', body: String(error), level: 'warning' }));
    } else if (pane?.pane) {
      run('pane.go', { direction });
    }
    closeOverlay(overlay);
  }

  // Each key launches this frameless window without taking keyboard focus.
  render() {
    return div().w(0).h(0);
  }
}
