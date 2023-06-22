```
      ▓█████▄  ▒█████  ▄▄▄█████▓  █████▒██▓ ██▓    ▓█████   ██████
      ▒██▀ ██▌▒██▒  ██▒▓  ██▒ ▓▒▓██   ▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒
      ░██   █▌▒██░  ██▒▒ ▓██░ ▒░▒████ ░▒██▒▒██░    ▒███   ░ ▓██▄
      ░▓█▄   ▌▒██   ██░░ ▓██▓ ░ ░▓█▒  ░░██░▒██░    ▒▓█  ▄   ▒   ██▒
      ░▒████▓ ░ ████▓▒░  ▒██▒ ░ ░▒█░   ░██░░██████▒░▒████▒▒██████▒▒
      ▒▒▓  ▒ ░ ▒░▒░▒░   ▒ ░░    ▒ ░   ░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
      ░ ▒  ▒   ░ ▒ ▒░     ░     ░      ▒ ░░ ░ ▒  ░ ░ ░  ░░ ░▒  ░ ░
      ░ ░  ░ ░ ░ ░ ▒    ░       ░ ░    ▒ ░  ░ ░      ░   ░  ░  ░
        ░        ░ ░                   ░      ░  ░   ░  ░      ░
      ░
```

<p align="center">
  <b>:sparkles: Dorian's Dotfiles :sparkles:</b>
</p>

<br />

### Thanks for dropping by!

This is my personal collection of configuration files.

Here are some details about my setup:

- **OS**: [Pop!\_OS](https://pop.system76.com/) / macOS
- **DE**: [Gnome](https://www.gnome.org)
- **WM**: [Mutter](https://gitlab.gnome.org/GNOME/mutter)
- **Shell**: [zsh](https://www.zsh.org/)
- **Editor**: [Neovim](https://github.com/neovim/neovim/)
  - utilizes the built-in lsp ❤️
  - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) — autocompletion
  - [tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter)
  - [tokyonight](https://github.com/folke/tokyonight.nvim) — color theme
  - [telescope](https://github.com/nvim-telescope/telescope.nvim) — fuzzy finder
  - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) — status line
  - [bufferline](https://github.com/akinsho/nvim-bufferline.lua)
- **Browser**: [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- **Terminal**: [Alacritty](https://alacritty.org/)
- **Term Prompt**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **Terminal Multiplexer**: [Tmux](https://github.com/tmux/tmux)

![screenshot](./screenshot.png)
![image](https://user-images.githubusercontent.com/551858/188434274-2df6fe83-7824-4b45-a797-51a96a1b928b.png)
<img width="2226" alt="image" src="https://user-images.githubusercontent.com/551858/189501141-a442b7b8-4089-4721-aaff-7d467b3d8bf4.png">

Feel free to "steal" anything you want, and if you have a question please open an issue.

---

# Dependencies

The goal is to have all dependencies for the config automatically installed with
the setup script. More details can be found by reading the following files:

- [setup.sh](./setup.sh)
  - For mac: [Brewfile](./Brewfile)
  - For linux: [debian-setup.sh](./installer/debian-setup.sh)
- [installer.rb](./installer.rb)

Gotchas for NeoVim setup:

- requires [fd](https://github.com/sharkdp/fd) >= 8.4 (install from brew)
- Tools such as formatters, LSPs, linters are automatically installed via
  `:Mason`, if one of the deps is not installing make sure to open `:Mason` to
  see the full error message.
- Make sure to run `:checkhealth` to know if you are missing anything

# Installation

Easy..

```sh
git clone git@github.com:dkarter/dotfiles.git
```

Cd into the dotfiles dir: `cd dotfiles`

```sh
./setup.sh
```

I don't recommend using other people's dotfiles, at least not when you're just starting with Vim.. these are customized to my personal taste and preferences, and are subject to change at any time. Instead consider forking [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), which is modern and very minimal, and using it as your base to build upon.

## Ended up cloning anyway?

My dotfiles are now automatically versioned and contain a [Changelog](./CHANGELOG.md)! The main branch will be continuously updated, and you can use git tags to check out specific versions.

> :warning: notice how I said automatically version and not semantically
> versioned. While I do try to keep a good git hygiene, and the versioning script
> follows conventional commits to determine the semantic version, I may still
> introduce a breaking change without a warning (these are my personal dotfiles
> after all :). The best course of action might be to have an independent fork
> and follow the changelog.

Releases and versioning is done using [Release Please](https://github.com/googleapis/release-please), GitHub Actions, and [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

---

# Development

- This repo now uses conventional commits. To install the git hooks simply run `yarn` in the project directory
- To start development use [airmux](https://github.com/dermoumi/airmux) (alias `mux`) inside the project directory

---

## FAQ

<details>
<summary>Q: Why are things named without a dot at the beginning?</summary>
A: It makes it easier to include files in this repo if they are not named
exactly how they would be when symlinked over (I symlink the files here to my home
directory).  e.g. if I want to include the global `.gitignore` in this repo it
will override this repo's `.gitignore`.
</details>
