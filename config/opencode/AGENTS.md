# Global Agent Instructions

## Local Instructions

`AGENTS.local.md` is a shared dotfiles convention, not a native discovery filename.
Load it explicitly as described below so the same local rules work across agents.

Read `~/.config/opencode/AGENTS.local.md` when it exists for machine-local global
rules. Alongside each applicable project `AGENTS.md`, also read its sibling
`AGENTS.local.md` when present, including at the project root even if no
`AGENTS.md` exists. Apply local rules within the same scope as their sibling
instructions; they do not override higher-priority instructions. These local
files are intentionally uncommitted.

## Credentials

Never inspect, print, decode, query, or otherwise access credential values,
including tokens, API keys, passwords, private keys, cookies, and authorization
headers, without the user's explicit permission. Commands that render resolved
configuration or environment variables must be treated as credential access
when they can expand secret references.

## Git Commit Signing

Never bypass Git commit signing. Do not use `commit.gpgsign=false`,
`--no-gpg-sign`, unsigned replacement commits, or any configuration or command
that disables signing during a rebase or cherry-pick.

If signing fails or the signing agent is unavailable, stop and tell the user.
Ask the user to unlock the 1Password SSH agent. Do not create a commit until
signing works again.

## Configuration Management

- When installing dprint plugins - always do so using the dprint cli instead of editing the dprint config directly

## Dependency Management

- Never update lockfiles directly for dependency management - always update the dependency specifications, and then use the plugin manager to cause the dependencies to install and the lockfile to get updated automatically. Lock files should never be updated directly!

## Deleting files

- Always use `trash` instead of `rm -rf` when deleting files
- Beware of env var expansion during deletes

## Communication

Less is more! don't be overly verbose in your communication - no one wants to
read pages of text - unless the user asked you assume clear, direct and
practical communication. We don't need a markdown doc on every PR documenting
each change - no one reads that.

Use ASD-STE100 standard where practical: use
common words, active voice, short sentences, one idea per sentence, and define
necessary technical terms.

## Testing

Not everything deserves a durable, committed test file - scripts and config
changes are not things you should be committing tests for unless asked directly.

If you want to write throwaway tests to verify work that doesn't need testing

When told to remove something - don't write a durable test that checks the old
thing you were told is not there anymore.. that's not valuable and it's just noise.

Business logic should almost always be tested, but don't couple tightly to
implementation and don't mock the world.
