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

![screenshot](./screenshot.png)
![image](https://user-images.githubusercontent.com/551858/188434274-2df6fe83-7824-4b45-a797-51a96a1b928b.png)
<img width="2226" alt="image" src="https://user-images.githubusercontent.com/551858/189501141-a442b7b8-4089-4721-aaff-7d467b3d8bf4.png">

Feel free to "steal" anything you want, and if you have a question please open an issue.

---

# Dependencies

The goal is to have all dependencies for the config automatically installed with
the setup script. More details can be found by reading the following files:

- [setup.sh](./setup.sh)
- [Taskfile.dist.yml](./Taskfile.dist.yml)

> [!NOTE]
> The setup script relies on [Taskfile](https://taskfile.dev)! A modern alternative to `make`
> There are still some steps that have not been migrated, but will be soon

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

## Synchronizing

The dotfiles get updated often, and with that some new tools and configurations might be added.

In order to keep the dotfiles up to date, I recommend running the following:

```bash
git pull # get latest
task sync # installs/updates tools and symlinks new configs
```

The `sync` task is optimized for speed, which is why all the sub tasks run concurrently. If you're running into issues with `task sync`, try setting the concurrency to `1`, like so:

```bash
task sync -C 1
```

Alternatively open `./taskfiles/dotfiles.yml` and move all the tasks in `deps` to the `cmds` section, so you can find out which one is failing.

# Note about forking/versioning

I generally don't recommend using other people's dotfiles, at least not when you're just starting with Vim.. these are customized to my personal taste and preferences, and are subject to change at any time.

Instead consider forking [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), which is modern and very minimal, and using it as your base to build upon.
Alternatively, there are some great NeoVim distributions out there such as [Lazy.nvim](https://github.com/folke/lazy.nvim), LunarVim, AstroVim, and NVChad.

## Versioning

My dotfiles are now automatically (and semantically) versioned and contain a [Changelog](./CHANGELOG.md)! The main branch will be continuously updated, and you can use git tags to check out specific versions.

> [!WARNING]
> I do my best try to keep a good git hygiene. The versioning script I use here
> follows conventional commits to determine the semantic versioning. However, I
> may still introduce a breaking change without a warning (these are my personal
> dotfiles after all :). The best course of action might be to have an
> independent fork and follow the changelog.

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
