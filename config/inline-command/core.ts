import { spawn } from 'node:child_process';
import { redactCredentials } from '../agent-guard/core';

export type CommandResult = { status: string; stdout: string; stderr: string };
type Runner = (command: string) => Promise<CommandResult>;

export async function runCommand(
  command: string,
  cwd: string,
  limits = { timeoutMs: 5_000, maxBytes: 16_384 },
): Promise<CommandResult> {
  return new Promise((resolve) => {
    const grouped = process.platform !== 'win32';
    const child = spawn(process.env.SHELL || '/bin/sh', ['-c', command], {
      cwd,
      detached: grouped,
      stdio: ['ignore', 'pipe', 'pipe'],
    });
    let bytes = 0;
    let stopped: string | undefined;
    let settled = false;
    let timer: ReturnType<typeof setTimeout>;
    const stdout: Buffer[] = [];
    const stderr: Buffer[] = [];
    const finish = (status: string) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      child.stdout.destroy();
      child.stderr.destroy();
      resolve({
        status,
        stdout: redactCredentials(Buffer.concat(stdout).toString()),
        stderr: redactCredentials(Buffer.concat(stderr).toString()),
      });
    };
    const stop = (reason: string) => {
      if (stopped) return;
      stopped = reason;
      try {
        if (grouped && child.pid) process.kill(-child.pid, 'SIGKILL');
        else child.kill('SIGKILL');
      } catch {
        /* The child may already have exited. */
      }
      finish(`failed (${reason})`);
    };
    timer = setTimeout(() => stop('timeout'), limits.timeoutMs);
    const collect = (chunks: Buffer[], chunk: Buffer) => {
      if (settled) return;
      chunks.push(chunk.subarray(0, Math.max(0, limits.maxBytes - bytes)));
      bytes += chunk.length;
      if (bytes > limits.maxBytes) stop('output limit');
    };
    child.stdout.on('data', (chunk) => collect(stdout, chunk));
    child.stderr.on('data', (chunk) => collect(stderr, chunk));
    child.on('error', () => {
      finish('failed (could not start shell)');
    });
    child.on('close', (code, signal) => {
      finish(String(code ?? signal ?? 'error'));
    });
  });
}

export async function expandCommands(text: string, run: Runner, onResult?: (section: string) => void): Promise<string> {
  // Consume ordinary Markdown code spans too, so quoted examples stay literal.
  const tokens = /(?<![\\`])!`([^`\r\n]+)`|(`+)[\s\S]*?\2/g;
  const fenced = /^([ \t]*(?:>[ \t]*)*(?:(?:[-+*]|\d+[.)])[ \t]+)?)(`{3,}|~{3,})/;
  let fence: string | undefined;
  let quote = false;
  let count = 0;
  const excluded: Array<[number, number]> = [];
  let position = 0;
  for (const line of text.split('\n')) {
    const fenceMatch = fenced.exec(line);
    const marker = fenceMatch?.[2];
    if (!line.trim()) quote = false;
    else if (/^ {0,3}>/.test(line)) quote = true;
    const protectedLine = !!fence || !!marker || quote || /^(?: {4}|\t)/.test(line);
    if (marker) {
      if (!fence) fence = marker;
      else if (marker[0] === fence[0] && marker.length >= fence.length && !line.slice(fenceMatch![0].length).trim())
        fence = undefined;
    }
    if (protectedLine) excluded.push([position, position + line.length]);
    position += line.length + 1;
  }
  let offset = 0;
  let expanded = '';
  for (const match of text.matchAll(tokens)) {
    if (!match[1] || excluded.some(([start, end]) => match.index >= start && match.index <= end)) continue;
    const command = match[1].trim();
    const result =
      ++count <= 4 ? await run(command) : { status: 'not executed (four-command limit)', stdout: '', stderr: '' };
    const output = [
      `${result.status.startsWith('not executed') ? 'Command' : 'Executed command'}: ${command}`,
      `Exit status: ${result.status}`,
      'Output (captured data):',
      ...redactCredentials(result.stdout || '(empty)')
        .trimEnd()
        .split('\n')
        .map((row) => `    ${row}`),
      ...(result.stderr
        ? [
            'Stderr:',
            ...redactCredentials(result.stderr)
              .trimEnd()
              .split('\n')
              .map((row) => `    ${row}`),
          ]
        : []),
    ].join('\n');
    onResult?.(output);
    expanded += text.slice(offset, match.index) + `\n\n${output}\n\n`;
    offset = match.index + match[0].length;
  }
  return expanded + text.slice(offset);
}

export async function preparePrompt(text: string, cwd: string) {
  const sections: string[] = [];
  const expanded = await expandCommands(
    text,
    (command) => runCommand(command, cwd),
    (section) => sections.push(section),
  );
  return { text: expanded, context: sections.join('\n\n') };
}
