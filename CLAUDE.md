# Claude Code Integration Guide

This document provides context and guidance for Claude Code when working with this dotfiles repository.

## Repository Overview

This is Dorian's personal dotfiles repository, a comprehensive development
environment configuration for macOS, Linux and Windows WSL. The repository
follows a modern, structured approach using Task automation and Mise for
dependency management.

### Architecture & Organization

**Core Philosophy:**

- Automated installation and synchronization
- XDG Base Directory compliance (most configs in `config/`)
- Cross-platform support (primarily macOS, some Linux/Debian)
- Modern tooling with performance focus
- Conventional commits and semantic versioning

**Directory Structure:**

```
├── config/                # XDG-compliant configuration files
│   ├── nvim/              # Neovim configuration (Lua-based)
│   ├── tmux/              # Terminal multiplexer config
│   ├── zsh/               # Z shell configurations
│   ├── wezterm/           # Terminal emulator config
│   ├── hammerspoon/       # macOS automation (Lua)
│   └── [various tools]/   # Tool-specific configurations
├── taskfiles/             # Task automation definitions
├── installer/             # Platform-specific setup scripts
├── scripts/               # Utility scripts
└── [dotfiles]             # Home directory dotfiles (no dot prefix)
```

## Key Technologies & Tools

### Core Development Stack

- **Editor:** Neovim (modern Lua configuration)
- **Terminal:** Ghostty, WezTerm as fallback
- **Shell:** Zsh with custom configuration
- **Multiplexer:** tmux with extensive plugin ecosystem
- **Version Control:** Git with conventional commits

### Package Management

- **Homebrew:** GUI applications (casks) and system libraries
- **Mise:** Runtime management (Node, Ruby, Python, etc.) and CLI tools
- **pnpm:** Node.js package management
- **Mason:** Neovim LSP/formatter/linter management

### Automation & Build

- **Task:** Modern Makefile alternative for automation
- **Lefthook:** Git hooks management
- **Conventional Commits:** Standardized commit messages checked with `committed` CLI
- **Release Please:** Automated semantic versioning through GitHub Actions

## Installation & Setup

### Initial Installation

```bash
git clone git@github.com:dkarter/dotfiles.git
cd dotfiles
./setup.sh
```

### Synchronization (Updates)

```bash
git pull
task sync  # Updates tools and configurations
task nvim:commit # synchronizes neovim plugin manager lockfile (lazy-lock.json)
```

### Platform Detection

The setup script automatically detects:

- macOS (primary target)
- Linux/Debian (partial support - aim for full compatibility)

## Common Operations

### Task Commands

```bash
task -l         # List all available tasks
task install    # Full installation
task sync       # Synchronize/update everything
task ci:run     # Run all linting/checks
```

### Development Workflow

```bash
# Conventional commits are enforced via lefthook and committed
git commit -m "feat: add new feature"

# CI checks run on pre-push
git push
```

## Configuration Areas

### Neovim Configuration

- **Location:** `config/nvim/`
- **Plugin Manager:** Lazy.nvim
- **Language:** Lua with TypeScript-style organization
- **Key Features:**
  - LSP integration via Mason
  - Modern completion with cmp, has Blink.cmp but it is disabled for now
  - Git integration (Fugitive, Gitsigns)
  - AI assistance (Copilot, Code Companion)
  - File management with Oil.nvim
  - Debugging with nvim-dap

### Terminal & Shell

- **Zsh Config:** Modular files in `config/zsh/`
- **Zinit:** Zsh plugin manager
- **Starship:** Cross-shell prompt
- **FZF:** Fuzzy finding integration
- **Zoxide:** Smart directory jumping

### Git Configuration

- **Conventional Commits:** Enforced via commitlint
- **Semantic Versioning:** Automated via Release Please
- **Hooks:** Managed by Lefthook
- **Templates:** Custom commit message templates

### macOS Integration

- **Hammerspoon:** Lua-based automation
- **Raycast:** Spotlight alternative
- **HyperKey:** Modifier key setup
- **System Preferences:** Automated via Task scripts

## Development Guidelines

### Code Style & Standards

- **Lua:** Formatted with stylua
- **Shell Scripts:** Linted with shellcheck
- **YAML:** Linted with yamllint
- **Spelling:** Checked with typos
- **Commits:** Must follow conventional commit format

### Testing & CI

The CI pipeline (`task ci:run`) includes:

- Lua linting and formatting checks
- Shell script linting
- YAML validation
- Spell checking
- All checks must pass before pushing

### File Organization

- Configuration files use XDG Base Directory standard
- Dotfiles in root don't have dot prefix (symlinked with dots)
- Modular approach - break large configs into smaller files
- Platform-specific code isolated in taskfiles

## Key Dependencies

### Runtime Requirements

- **Node.js 22:** Managed via Mise
- **Ruby 3:** For various tools and scripts
- **Lua:** For Neovim and Hammerspoon configs
- **pnpm:** Package manager for Node.js dependencies

### Essential Tools (Auto-installed)

- fd, ripgrep - use these to search for files instead of find and grep
- bat (cat replacement)
- git, lazygit (version control)
- tmux (terminal multiplexer)
- neovim (editor)

### macOS Specific

- Homebrew (package management)
- Cask applications (GUI apps)
- System preference automation

## Troubleshooting

### Common Issues

1. **Neovim LSP Issues:** Run `:Mason` to check tool installation
2. **Missing Dependencies:** Run `task sync` to update all tools
3. **Git Hook Failures:** Ensure conventional commit format
4. **Permission Issues:** Some setup steps require sudo access

### Debugging

- Use `task -v` for verbose output
- Check individual taskfiles for specific component issues
- Neovim: `:checkhealth` for diagnostic information
- Shell: Use `task shell:lint` for script validation

## Maintenance

### Regular Updates

- Daily: `git pull && task sync`
- Monthly: Review and update tool versions in `mise.toml`
- As needed: Update Brewfile for new applications

### Version Management

- Repository uses semantic versioning
- Never read CHANGELOG.md it's auto generated and very large, just a waste of
  tokens to read
- Use git tags for specific version checkouts

## Notes for Claude Code

### Best Practices

1. **Respect existing patterns:** Follow the modular configuration approach
2. **Test changes:** Use `task ci:run` before committing
3. **Document changes:** Update this file when adding new major components
4. **Platform awareness:** Consider macOS/Linux compatibility
5. **Performance focus:** This setup prioritizes speed and efficiency

### Common Modifications

- Adding new tools: Update appropriate taskfile and mise.toml
- Neovim plugins: Add to `config/nvim/lua/plugins/`
- Shell functions: Add to `config/zsh/functions.zsh`
- Git configuration: Modify `gitconfig` or related files
- Automation: Create/modify taskfiles for new workflows

This repository represents years of refinement for a productive development environment. Changes should enhance without disrupting the existing workflow patterns.
