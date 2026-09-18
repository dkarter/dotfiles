import { describe, expect, test } from 'bun:test';

import { GIT_STATUS_ARGS, parseStatus } from './git-status';

describe('git status refresh safety', () => {
  test('does not refresh the index while reading status', () => {
    expect(GIT_STATUS_ARGS).toContain('--no-refresh');
    expect(GIT_STATUS_ARGS).toContain('--no-optional-locks');
  });
});

describe('parseStatus', () => {
  test('parses branch, divergence, and working-tree counts', () => {
    expect(
      parseStatus(
        [
          '# branch.oid 0123456789abcdef',
          '# branch.head main',
          '# branch.ab +2 -3',
          '1 M. N... 100644 100644 100644 abc def staged.ts',
          '1 .M N... 100644 100644 100644 abc def modified.ts',
          '? untracked.ts',
          'u UU N... 100644 100644 100644 100644 abc def ghi conflict.ts',
        ].join('\n'),
      ),
    ).toEqual({
      branch: 'main',
      ahead: 2,
      behind: 3,
      staged: 1,
      modified: 1,
      untracked: 1,
      conflicted: 1,
    });
  });
});
