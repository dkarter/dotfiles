import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const directory = fileURLToPath(new URL('.', import.meta.url));
const config = fileURLToPath(new URL('./betterleaks.toml', import.meta.url));
const SCAN_FAILED = '[REDACTED: secret scan unavailable]';
const SENTINEL = 'AGENT_GUARD_SCAN_SENTINEL\n';

// One scan for all text leaves. Line counts, rather than content delimiters,
// map the redacted report back to each field without escaping the input.
export const redactBatchWithBetterleaks = (values: string[]): string[] => {
  if (!values.length) return values;
  const input = values.join('\n');
  const redacted = redactWithBetterleaks(input);
  if (redacted === SCAN_FAILED) return values.map((value) => (value.trim() ? SCAN_FAILED : value));
  if (redacted === input) return values;
  const lineCounts = values.map((value) => value.split('\n').length);
  const lines = redacted.split('\n');
  if (lines.length !== lineCounts.reduce((sum, count) => sum + count, 0)) {
    return values.map((value) => (value.trim() ? SCAN_FAILED : value));
  }
  let offset = 0;
  return lineCounts.map((count) => {
    const value = lines.slice(offset, offset + count).join('\n');
    offset += count;
    return value;
  });
};

// Reports are redacted too: no plaintext secret reports, temp files, or logs.
// Mask whole affected lines rather than reconstructing secrets from a report.
export const redactWithBetterleaks = (value: string): string => {
  if (!value.trim()) return value;
  try {
    const result = spawnSync(
      'betterleaks',
      [
        'stdin',
        '--config',
        config,
        '--report-format',
        'json',
        '--report-path',
        '-',
        '--redact',
        '--no-banner',
        '--log-level',
        'error',
        '--validation=false',
        '--ignore-gitleaks-allow',
        '--gitleaks-ignore-path',
        directory,
        '--exit-code',
        '0',
      ],
      {
        cwd: directory,
        // Do not inherit credentials or scanner configuration from the agent.
        env: { PATH: process.env.PATH },
        input: SENTINEL + value,
        encoding: 'utf8',
        timeout: 5_000,
        maxBuffer: 16 * 1024 * 1024,
        stdio: ['pipe', 'pipe', 'ignore'],
      },
    );
    if (result.error || result.status !== 0) return SCAN_FAILED;
    const findings: unknown = JSON.parse(result.stdout);
    if (
      !Array.isArray(findings) ||
      !findings.some(
        (finding) => finding?.RuleID === 'agent-guard-sentinel' && finding.StartLine === 1 && finding.EndLine === 1,
      )
    )
      return SCAN_FAILED;
    const redacted = redactFindingLines(SENTINEL + value, findings);
    return redacted.startsWith('[REDACTED]\n') ? redacted.slice('[REDACTED]\n'.length) : SCAN_FAILED;
  } catch {
    // Never include scanner errors or partial output in an agent-visible message.
    return SCAN_FAILED;
  }
};

export const redactFindingLines = (value: string, findings: unknown): string => {
  if (!Array.isArray(findings)) return SCAN_FAILED;
  if (!findings.length) return value;
  const lines = value.split('\n');
  const affected = new Set<number>();
  const addFinding = (finding: any): boolean => {
    if (
      !finding ||
      !Number.isInteger(finding.StartLine) ||
      !Number.isInteger(finding.EndLine) ||
      finding.StartLine < 1 ||
      finding.EndLine < finding.StartLine ||
      finding.EndLine > lines.length
    )
      return false;
    for (let line = finding.StartLine; line <= finding.EndLine; line++) affected.add(line - 1);
    if (finding.ComponentSets !== undefined) {
      if (!Array.isArray(finding.ComponentSets)) return false;
      for (const set of finding.ComponentSets) {
        if (!Array.isArray(set?.components) || !set.components.every(addFinding)) return false;
      }
    }
    return true;
  };
  if (!findings.every(addFinding)) return SCAN_FAILED;
  return lines.map((line, index) => (affected.has(index) ? '[REDACTED]' : line)).join('\n');
};
