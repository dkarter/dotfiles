# Testing dotfiles with disposable machines

Use the fresh-install tasks to test these dotfiles in disposable macOS and Linux environments before trusting an install path on a real machine.

## Prerequisites

You must have tart installed first:

```bash
brew trust --formula cirruslabs/cli/tart
brew install cirruslabs/cli/tart
```

You must have Docker running for the Linux container tests.

## macOS

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

Use `setup` mode when you specifically want to exercise `./setup.sh`:

```bash
mise tart:fresh-install --graphics --install-mode setup
```

This is the closest path to a brand-new manual clone followed by `./setup.sh`. It is also the most likely to expose desktop-specific blockers because `setup.sh` delegates to `installer/mac-setup.sh`, which runs Homebrew bundle work and other macOS app setup.

Use `--keep-vm` when you want to inspect a macOS VM failure:

```bash
mise tart:fresh-install --graphics --install-mode task --keep-vm
```

The task prints the VM name and host log directory. When done, remove generated VMs with:

```bash
mise tart:fresh-install --cleanup
```

## Linux

Refresh lockfiles first, same as the macOS path:

```bash
task mise:lock
```

Run both supported Linux targets:

```bash
mise linux:fresh-install
```

Run only Ubuntu:

```bash
mise linux:fresh-install --target ubuntu
```

Run only the Omarchy-like target:

```bash
mise linux:fresh-install --target omarchy
```

The Omarchy target uses `archlinux/archlinux:latest` by default. That exercises the Arch/pacman path Omarchy is based on without requiring a desktop session inside Docker. If you have a better Omarchy image, pass it explicitly:

```bash
mise linux:fresh-install --target omarchy --omarchy-image your/image:tag
```

On Apple Silicon hosts, the Arch image may need amd64 emulation because it does not publish an arm64 manifest:

```bash
mise linux:fresh-install --target omarchy --platform linux/amd64
```

The Linux task runs `./setup.sh` without `DEVCONTAINER=true`, so it exercises the normal `task install` path, including the existing Debian/Arch package lists.

For smoke runs where a specific mise tool is slow, unavailable for the target architecture, or temporarily blocked by external API limits, pass `MISE_DISABLE_TOOLS` through the harness:

```bash
mise linux:fresh-install --target ubuntu --disable-mise-tools 'github:ast-grep/ast-grep,github:remoteoss/dexter'
```

Use that as a targeted test variant, not as the default gold path.

Use `--keep-container` when you want to inspect a Linux container failure:

```bash
mise linux:fresh-install --target ubuntu --keep-container
```

Remove generated Linux containers with:

```bash
mise linux:fresh-install --cleanup
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
