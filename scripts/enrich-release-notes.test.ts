import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

import { enrichChangelog, enrichReleaseBody } from './enrich-release-notes.ts';

const fixtureUrl = new URL('fixtures/enrich-release-notes/', import.meta.url);

async function fixture(name: string): Promise<string> {
  return readFile(new URL(name, fixtureUrl), 'utf8');
}

test('inserts a summary beneath the exact release heading', async () => {
  const actual = enrichChangelog(await fixture('changelog.md'), '2.0.0', 'A useful overview.');

  assert.equal(actual, await fixture('changelog-inserted.md'));
});

test('replaces an existing summary only in the selected release', async () => {
  const actual = enrichChangelog(await fixture('changelog-existing.md'), '2.0.0', 'A useful overview.');

  assert.equal(actual, await fixture('changelog-inserted.md'));
});

test('fails without changing a changelog when its heading is missing', async () => {
  const changelog = await fixture('changelog.md');

  assert.throws(
    () => enrichChangelog(changelog, '3.0.0', 'A useful overview.'),
    /Could not find changelog heading for 3\.0\.0/,
  );
  assert.equal(changelog, await fixture('changelog.md'));
});

test('prepends and replaces the marked release summary', () => {
  const generated = '## Changes\n\n* Fixed a bug.\n';
  const enriched = enrichReleaseBody(generated, 'First overview.');

  assert.equal(
    enrichReleaseBody(enriched, 'Updated overview.'),
    '<!-- pullfrog-summary:start -->\n\nUpdated overview.\n\n' + '<!-- pullfrog-summary:end -->\n\n' + generated,
  );
});
