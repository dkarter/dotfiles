# vim: ft=ruby
# frozen_string_literal: true

# for Erlang
brew("wxwidgets")
brew("autoconf")
brew("fop")
brew("libiodbc")
brew("openjdk")

# for generating graphics
brew("graphviz")

# code stats
brew("scc")

# SQLite3
brew("sqlite")

# Taskfile task runner
brew("go-task")

# image manipulation
brew("imagemagick")

# json querying + pretty printing
brew("jq")

# json exploration
brew("fx")

# html querying aka hq
brew("htmlq")

# easily copy tabular data
brew("yank")

# format postgres sql files
brew("pgformatter")

# required for formatting terraform files
brew("opentofu")

# Postgres pager
brew("pspg")

# Postgres client
brew("libpq")

# for NeoVim
brew("lua")

# quickly jump to recently used folders
brew("autojump")

# better cat with syntax highlighting
brew("bat")

# compile C stuff
brew("cmake")

# auto run env scripts when entering a dir
brew("direnv")

# fuzzy finder
brew("fzf")

# c++ compiler
brew("gcc")

# source control
brew("git")

# GTags for use in Vim
brew("global")

# Encryption + verification of signed downloads
brew("gnupg")

# show active process and their telemetry
brew("htop")
brew("btop")

# GitHub CLIs
brew("gh")

# curses interface for docker + git
brew("lazydocker")
brew("lazygit")

# build tool
brew("make")

# terminal multiplexer
brew("tmux")

# a smart session manager for tmux
tap("joshmedeski/sesh")
brew("joshmedeski/sesh/sesh")

# download files from the terminal, used by some scripts
brew("wget")

# display system info
brew("neofetch")

# best code editor on planet earth
brew("neovim")

# better, faster grep
brew("ripgrep")

# like grep but for files and folder names
brew("fd")

# linter for bash scripts
brew("shellcheck")

# keep tree up to date
brew("tree")

# keep ZSH up to date
brew("zsh")

# required by ccls
brew("llvm")

# the watch command
brew("watch")

# for Nerves
brew("xz")
brew("pkg-config")
brew("squashfs")
brew("fwup")

# GNU File, Shell, and Text utilities (also required by Nerves)
# https://www.gnu.org/software/coreutils
brew("coreutils")

# TUI utils for scripting
brew("gum")

# a modern API client with a friendly DX
brew("httpie")

# a more up to date version of curl than what macOS offers
brew("curl")

# run things in parallel
brew("parallel")

# ask questions in natural language and get results in the terminal
brew("howdoi")

# pretty text display utils
brew("figlet")
brew("lolcat")

# kubernetes tools
brew("kubernetes-cli")
brew("kubectx")
brew("helm")

# yet another tmux session manager
brew("smug")

# for formatting XML files
brew("xq")

# install python tools globally (outside asdf - to avoid version shim conflicts)
brew("pipx")

if OS.mac?
  # Dual Panel File Browser
  cask("marta")

  # Fast GPU rendered terminal emulator
  cask("wezterm")

  # best screenshot tool on mac
  cask("cleanshot")

  # setup a hyper key modifier
  cask("hyperkey")

  # note taking app and Zettlekasten
  cask("obsidian")

  # spotlight alternative
  cask("raycast")

  # a terminal emulator (used primarily for wrapping terminal apps)
  cask("iterm2")

  # allow accessing passwords from a CLI
  cask("1password/tap/1password-cli")

  # macOS automation using Lua
  cask("hammerspoon")

  # docker desktop for containers
  cask("docker")

  # keep grep up to date
  brew("grep")

  # OpenSSL - important for compiling things that support SSL
  brew("openssl@1.1")

  # set default application for opening files on mac
  brew("duti")

  # Mac App Store CLI
  brew("mas")

  # Reattach process (e.g., TMux) to background
  brew("reattach-to-user-namespace")

  # vimium like jumps in tmux
  tap("morantron/tmux-fingers")
  brew("morantron/tmux-fingers/tmux-fingers")
end
