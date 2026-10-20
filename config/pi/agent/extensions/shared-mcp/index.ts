import type { ExtensionAPI } from '@earendil-works/pi-coding-agent';
import { readFileSync } from 'node:fs';

export function loadSharedMcpServers(pi: ExtensionAPI, path: URL) {
  let text: string;
  try {
    text = readFileSync(path, 'utf8');
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === 'ENOENT') return;
    throw error;
  }

  const config = JSON.parse(text);
  if (
    !config ||
    typeof config !== 'object' ||
    !config.mcpServers ||
    typeof config.mcpServers !== 'object' ||
    Array.isArray(config.mcpServers)
  ) {
    throw new Error('mcp.shared.json must contain an mcpServers object');
  }

  // Pi validates entries and lets native user/project mcp.json entries take precedence.
  for (const [name, server] of Object.entries(config.mcpServers)) {
    pi.registerMcpServer(name, server as Parameters<ExtensionAPI['registerMcpServer']>[1]);
  }
}

export default function (pi: ExtensionAPI) {
  loadSharedMcpServers(pi, new URL('../../mcp.shared.json', import.meta.url));
}
