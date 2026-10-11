export function register(on) {
  on('prompt.submit', async ($, event, next) => {
    if (!event.text.includes('!`')) return next(event);
    const home = await $.env.get('HOME');
    const cwd = await $.session.cwd();
    const result = await $.process.run(['bun', `${home}/.config/inline-command/prepare.ts`, event.text, cwd]);
    if (result.exitCode !== 0) throw new Error('Inline command preprocessing failed');
    const { text } = JSON.parse(result.stdout);
    return next({ ...event, text });
  });
}
