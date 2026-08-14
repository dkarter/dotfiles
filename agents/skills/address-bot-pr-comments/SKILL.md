---
name: address-bot-pr-comments
description: Review and address unresolved pull request comments authored by bots, not humans. Use when asked to evaluate automated PR review feedback, fix valid findings, explain rejected findings, reply to bot threads, and resolve completed threads.
argument-hint: '[PR number or URL]'
metadata:
  opencode/slash: 'true'
---

# Address Bot PR Comments

Review unresolved bot-authored threads on the pull request identified by
`$ARGUMENTS`, or the pull request for the current branch when no argument is
provided.

## Workflow

1. Identify the pull request and fetch its unresolved review threads and any existing reply comments.
2. Filter by the comment author. Process only comments clearly authored by a bot or automation account; do not act on human-authored comments unless explicitly requested by me.
3. Verify every finding against the current code and repository guidance. Do not assume automated feedback is correct.
4. Classify each finding:
   - Fix valid issues with the smallest correct change.
   - Reject invalid, obsolete, or inapplicable findings with a brief factual
     reason.
   - Leave ambiguous findings unresolved if they require human input.
5. Only when a valid finding requires a major architectural change or many
   code changes, stop before editing. Load the `explain-simply` skill, explain the
   issue and impact, then use the available user-question tool to ask whether
   to proceed. Continue only with explicit approval. Do not interrupt routine
   or small fixes.
6. Run focused validation for each change, followed by the relevant broader
   checks when practical.
7. Commit fixes in small logical commits, ideally one commit per finding or
   tightly related group. Use conventional commit messages and push once after
   all local work is complete.
8. Reply briefly to every processed bot thread:
   - For fixed findings, summarize the change and include the commit SHA.
   - For rejected findings, explain why no change was made.
   - For findings needing human input, state the unresolved question.
9. Resolve a thread only after posting the reply and only when the finding is
   fixed or conclusively rejected. Never resolve a thread that still requires
   human input.

Prefer GitHub MCP for pull request operations when available and `gh` as the
fallback. Finish with a concise summary of fixed, rejected, and unresolved
findings plus the validation performed.
