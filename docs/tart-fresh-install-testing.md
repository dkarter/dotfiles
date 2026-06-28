# Testing dotfiles with Tart

Use the Tart fresh-install task to test these dotfiles in a disposable macOS VM before trusting an install path on a real machine.

## Prerequisites

You must have tart installed first:

```bash
brew trust --formula cirruslabs/cli/softnet
brew install cirruslabs/cli/softnet
```

## Using

Refresh lockfiles first so the VM can install tools without a GitHub token:

```bash
task mise:lock
```

Clean up any old generated test VMs:

```bash
mise tart:fresh-install --cleanup
```

Run the main Taskfile install path:

```bash
mise tart:fresh-install --graphics --install-mode task
```

This is the best day-to-day confidence check. It boots a fresh VM, copies a clean archive of the repo into it, runs `task install`, validates core symlinks and shell/tool startup, then deletes the VM.

Run the fast smoke path when iterating on the harness or low-level install pieces:

```bash
mise tart:fresh-install --graphics --install-mode core --skip-mise-tools --skip-zinit-plugins --skip-nvim
```

This validates bootstrap, symlinks, mac defaults, zinit install, mise install, and basic shell startup without paying for the full tool/plugin install.

## Setup path

Use `setup` mode when you specifically want to exercise `./setup.sh`:

```bash
mise tart:fresh-install --graphics --install-mode setup
```

This is the closest path to a brand-new manual clone followed by `./setup.sh`. It is also the most likely to expose desktop-specific blockers because `setup.sh` delegates to `installer/mac-setup.sh`, which runs Homebrew bundle work and other macOS app setup.

## Keeping a failed VM

Use `--keep-vm` when you want to inspect a failure:

```bash
mise tart:fresh-install --graphics --install-mode task --keep-vm
```

The task prints the VM name and host log directory. When done, remove generated VMs with:

```bash
mise tart:fresh-install --cleanup
```

## Modes

`core` runs the curated core install sequence from `scripts/tart-guest-install-core.sh`. It is fast and useful for debugging the harness.

`task` bootstraps Homebrew and Task, then runs `task install`. This is the recommended full test path.

`setup` runs `./setup.sh` directly. Use it to verify OS detection and the outer setup script, but expect it to hit more GUI and macOS-desktop assumptions.

## Notes

The default base image is `ghcr.io/cirruslabs/macos-tahoe-base:latest`. Override it with `--base` if you maintain a local Tart base:

```bash
mise tart:fresh-install --base tahoe-base --graphics --install-mode task
```
