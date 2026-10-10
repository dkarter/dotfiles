# Raycast Script Commands

Scripts are grouped by which machines should expose them in Raycast:

| Directory          | Machines           | Contents                                                                                |
| ------------------ | ------------------ | --------------------------------------------------------------------------------------- |
| `scripts/shared`   | All Macs           | General development tools and macOS utilities, including Toggle kindaVim.               |
| `scripts/pdq`      | PDQ Macs only      | PDQ preview-environment commands, Open PR in Linear, and the GitHub/Graphite PR toggle. |
| `scripts/personal` | Personal Macs only | Personal-only commands; currently empty.                                                |

## Register directories

In Raycast Settings, use **Add Script Directory** to register each applicable
leaf directory:

- **PDQ Mac:** `~/dotfiles/raycast/scripts/shared` and `~/dotfiles/raycast/scripts/pdq`.
- **Personal Mac:** `~/dotfiles/raycast/scripts/shared` and `~/dotfiles/raycast/scripts/personal`.

Remove the old `~/dotfiles/raycast/scripts` registration if present. Register
only the leaf directories, not the parent, so machine-specific commands stay
separate. If discovery does not refresh, quit and reopen Raycast.

## Sync behavior

Git keeps all three groups in this repository; this layout does not exclude PDQ
files from a personal machine's checkout. Selective Raycast registration controls
which commands appear on each machine.

Raycast Cloud Sync does not sync the script files themselves, though their
settings sync. Configure the applicable directories on each machine after
syncing the dotfiles repository.

## Adding commands

Put reusable commands in `shared`, work-only commands in `pdq`, and personal-only
commands in `personal`. Include Raycast metadata and keep scripts executable.
Keep support files next to the commands that use them, and check relative paths
when moving scripts between directories.
