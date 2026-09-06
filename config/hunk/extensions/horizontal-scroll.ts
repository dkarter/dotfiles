import type { HunkExtensionAPI } from 'hunkdiff/extension';

export default function (hunk: HunkExtensionAPI) {
  hunk.registerCommand({ id: 'jumpToStart', title: 'Scroll code all the way left' }, (ctx) => {
    ctx.commands.execute('hunk.review.scrollCodeLeft', { count: 10_000 });
  });
}
