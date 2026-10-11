import { preparePrompt } from './core';

const [text, cwd] = Bun.argv.slice(2);
if (text === undefined || !cwd) throw new Error('Usage: prepare.ts <prompt> <cwd>');
process.stdout.write(JSON.stringify(await preparePrompt(text, cwd)));
