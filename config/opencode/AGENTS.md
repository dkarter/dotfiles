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
Do not create a commit until signing works again.
