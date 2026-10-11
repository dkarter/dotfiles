import { handlePromptHook } from './hook-protocol';

const result = await handlePromptHook(JSON.parse(await Bun.stdin.text()));
if (result) process.stdout.write(JSON.stringify(result));
