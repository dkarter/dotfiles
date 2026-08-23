# Global Agent Instructions

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
