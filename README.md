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
> may still inadvertently introduce a breaking change without a warning. The
> best course of action might be to have an independent fork and follow the
> changelog + rebase often - otherwise it could become painful to keep up (I
> update my dots all the time to keep things fresh and fight entropy).

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

<details>
<summary>Q: Why are both Mise and Homebrew used?</summary>
A: [Mise](https://mise.jdx.dev) was recently introduced to manage runtimes - it
  is an alternative to ASDF and it's super fast (at least compared to ASDF's
  bash implementation). Furthermore, it is [more secure](https://github.com/jdx/mise/blob/main/SECURITY.md).

Runtimes include things you need to run your app, such as Elixir, Erlang,
Ruby, Go, Python etc. Mise does that well and uses a `mise.toml` in your
project directory as an alternative to the `.tool-versions` - although it does
support `.tool-versions` spec too.

Mise has multiple backends, and you should read a little about these to get
the most benefit out of using Mise. Specifically learn about:

- [Aqua](https://mise.jdx.dev/dev-tools/backends/aqua.html)
- [UBI](https://mise.jdx.dev/dev-tools/backends/ubi.html)
- [Cargo](https://mise.jdx.dev/dev-tools/backends/cargo.html)
  There are others too - but these are the ones I use the most. UBI is
  especially cool!

Mise also excels at managing binaries and CLIs and updating them to their
latest versions - for that reason I switched pretty much every CLI I use to be
installed with Mise - as long as I could find it or make Mise know about it
(e.g. via UBI).

However, not all tools are available via Mise, and some are simply not
something Mise particularly excels in: compile libs, Casks (aka UI apps) -
those are still managed with Homebrew (or in the case of Debian based distros - apt) - at least for now!

</details>
