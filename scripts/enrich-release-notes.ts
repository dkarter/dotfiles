import { readFile, writeFile } from 'node:fs/promises';
import process from 'node:process';

const START_MARKER = '<!-- pullfrog-summary:start -->';
const END_MARKER = '<!-- pullfrog-summary:end -->';

function markedSummary(summary: string): string {
  return `${START_MARKER}\n\n${summary.trim()}\n\n${END_MARKER}`;
}

export function enrichReleaseBody(body: string, summary: string): string {
  const marked = markedSummary(summary);
  const pattern = new RegExp(`${START_MARKER}[\\s\\S]*?${END_MARKER}\\n*`);

  if (pattern.test(body)) {
    return body.replace(pattern, `${marked}\n\n`);
  }

  return `${marked}\n\n${body.trimStart()}`;
}

export function enrichChangelog(changelog: string, version: string, summary: string): string {
  const heading = new RegExp(`^## \\[${escapeRegex(version)}\\].*$`, 'm');
  const match = heading.exec(changelog);
  if (!match) {
    throw new Error(`Could not find changelog heading for ${version}`);
  }

  const sectionStart = match.index + match[0].length;
  const nextHeading = changelog.slice(sectionStart).search(/^## /m);
  const sectionEnd = nextHeading === -1 ? changelog.length : sectionStart + nextHeading;
  const section = changelog.slice(sectionStart, sectionEnd);
  const marked = markedSummary(summary);
  const existing = new RegExp(`\\n*${START_MARKER}[\\s\\S]*?${END_MARKER}\\n*`);
  const enriched = existing.test(section) ? section.replace(existing, `\n\n${marked}\n\n`) : `\n\n${marked}${section}`;

  return changelog.slice(0, sectionStart) + enriched + changelog.slice(sectionEnd);
}

function escapeRegex(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

async function main() {
  const [tag, summaryPath, releaseBodyPath, changelogPath, outputPath] = process.argv.slice(2);
  if (!tag || !summaryPath || !releaseBodyPath || !changelogPath || !outputPath) {
    throw new Error(
      'Usage: enrich-release-notes.ts <tag> <summary-json> ' + '<release-body> <changelog> <release-output>',
    );
  }

  const summaryPayload: unknown = JSON.parse(await readFile(summaryPath, 'utf8'));
  if (!summaryPayload || typeof summaryPayload !== 'object' || !('summary' in summaryPayload)) {
    throw new Error('Summary output must contain a non-empty summary string');
  }
  if (typeof summaryPayload.summary !== 'string' || !summaryPayload.summary.trim()) {
    throw new Error('Summary output must contain a non-empty summary string');
  }

  const releaseBody = await readFile(releaseBodyPath, 'utf8');
  const changelog = await readFile(changelogPath, 'utf8');
  const version = tag.replace(/^v/, '');

  await writeFile(outputPath, enrichReleaseBody(releaseBody, summaryPayload.summary));
  await writeFile(changelogPath, enrichChangelog(changelog, version, summaryPayload.summary));
}

if (process.argv[1] === new URL(import.meta.url).pathname) {
  main().catch((error: unknown) => {
    console.error(error instanceof Error ? error.message : error);
    process.exitCode = 1;
  });
}
