import { handleClaudeHook, handleCodexHook } from './hook-protocol';

const [agent] = Bun.argv.slice(2);
if (agent !== 'claude' && agent !== 'codex') {
  throw new Error('Usage: hook.ts <claude|codex>');
}

const event = JSON.parse(await Bun.stdin.text());
const result = agent === 'claude' ? handleClaudeHook(event) : handleCodexHook(event);
if (result !== undefined) process.stdout.write(JSON.stringify(result));
