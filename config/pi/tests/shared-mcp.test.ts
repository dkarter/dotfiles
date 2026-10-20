import { afterEach, expect, test } from 'bun:test';
import type { ExtensionAPI } from '@earendil-works/pi-coding-agent';
import { mkdtempSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import sharedMcp, { loadSharedMcpServers } from '../agent/extensions/shared-mcp';

const directories: string[] = [];
function fixture(text?: string) {
  const dir = mkdtempSync(join(tmpdir(), 'pi-shared-mcp-'));
  directories.push(dir);
  const path = join(dir, 'mcp.shared.json');
  if (text !== undefined) writeFileSync(path, text);
  return pathToFileURL(path);
}

function recorder() {
  const servers = new Map<string, unknown>();
  const pi = {
    registerMcpServer: (name: string, config: unknown) => servers.set(name, config),
  } as unknown as ExtensionAPI;
  return { pi, servers };
}

afterEach(() => {
  for (const dir of directories.splice(0)) rmSync(dir, { recursive: true, force: true });
});

test('registers shared stdio and HTTP servers without changing their settings', () => {
  const config = {
    mcpServers: {
      tools: { command: 'tools', args: ['mcp'], env: { TOKEN: '${TOKEN}' }, exposure: 'codemode' },
      docs: { url: 'https://example.com/mcp', enabled: false, timeout: 30 },
    },
  };
  const { pi, servers } = recorder();
  loadSharedMcpServers(pi, fixture(JSON.stringify(config)));
  expect(Object.fromEntries(servers)).toEqual(config.mcpServers);
});

test('missing and empty shared config register nothing', () => {
  const { pi, servers } = recorder();
  loadSharedMcpServers(pi, fixture());
  loadSharedMcpServers(pi, fixture('{"mcpServers": {}}'));
  expect(servers.size).toBe(0);
});

test('reports malformed JSON rather than silently ignoring it', () => {
  expect(() => loadSharedMcpServers(recorder().pi, fixture('{'))).toThrow();
});

test('requires an mcpServers object', () => {
  for (const config of ['null', '{}', '{"mcpServers": []}', '{"mcpServers": "invalid"}']) {
    expect(() => loadSharedMcpServers(recorder().pi, fixture(config))).toThrow('mcpServers object');
  }
});

test('delegates server validation errors to Pi', () => {
  const pi = {
    registerMcpServer() {
      throw new Error('Invalid MCP config');
    },
  } as unknown as ExtensionAPI;
  expect(() => loadSharedMcpServers(pi, fixture('{"mcpServers": {"invalid": {}}}'))).toThrow('Invalid MCP config');
});

test('default factory finds the synced config relative to the extension', () => {
  const { pi } = recorder();
  expect(() => sharedMcp(pi)).not.toThrow();
});
