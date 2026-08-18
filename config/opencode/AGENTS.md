# Global Agent Instructions

## Git Commit Signing

Never bypass Git commit signing. Do not use `commit.gpgsign=false`,
`--no-gpg-sign`, unsigned replacement commits, or any configuration or command
that disables signing during a rebase or cherry-pick.

If signing fails or the signing agent is unavailable, stop and tell the user.
Do not create a commit until signing works again.
