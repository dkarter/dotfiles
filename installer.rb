# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'net/http'
require 'cgi'
require_relative 'installer/string'
require_relative 'installer/request'

Warning[:experimental] = false

ASDF_INSTALL_DIR = '~/.asdf'

DIRS = %w[
  ~/.cache/zsh/completions
  ~/.config
  ~/.local/share/psql
].freeze

DOTFILES = %w[
  aliases
  asdfrc
  ctags
  gemrc
  gitconfig
  gitignore
  gitmessage
  ignore
  prettierrc
  pryrc
  psqlrc
  stylelintrc
  zinitrc
  zshenv
  zshrc
].freeze

SYMLINK_DIRS = [
  %w[./config/alacritty ~/.config/alacritty],
  %w[./config/bat ~/.config/bat],
  %w[./config/btop ~/.config/btop],
  %w[./config/gh-dash ~/.config/gh-dash],
  %w[./config/gitui ~/.config/gitui],
  %w[./config/hammerspoon ~/.config/hammerspoon],
  %w[./config/kitty ~/.config/kitty],
  %w[./config/lazygit ~/.config/lazygit],
  %w[./config/nvim ~/.config/nvim],
  %w[./config/ripgrep ~/.config/ripgrep],
  %w[./config/rubocop ~/.config/rubocop],
  %w[./config/sesh ~/.config/sesh],
  %w[./config/smug ~/.config/smug],
  %w[./config/starship ~/.config/starship],
  %w[./config/tmux ~/.config/tmux],
  %w[./config/vifm ~/.config/vifm],
  %w[./config/wezterm ~/.config/wezterm],
  %w[./config/yamllint ~/.config/yamllint],
  %w[./config/zsh ~/.config/zsh],
].freeze

GEMS = [
  'bundler', # manage gem bundles for a project
  'pry', # ruby debugger
].freeze

PIPS3 = [
  'codespell', # check for spelling mistakes in code.
  'howdoi', # ask for coding help directly from the terminal
  'neovim', # NeoVim python3 support
  'neovim-remote', # allow controlling neovim remotely
  'register-python-argcomplete', # adds completions for python tools (used by pipx)
  'yq', # like jq but for yaml files
].freeze

ASDF_PLUGINS = %w[
  bat
  direnv
  elixir
  erlang
  fd
  fzf
  github-cli
  golang
  lazygit
  lua
  lua-language-server
  neovim
  nodejs
  python
  rebar
  ripgrep
  ruby
  rust
  tmux
].freeze

# some tools cannot be installed via asdf on ARM, but are still useful for
# x86 machines and linux
ASDF_ARM_INCOMPATIBLE = %w[github-cli fzf fd ripgrep neovim].freeze

NPMS = [
  # linter for checking that commits are following conventional commits
  '@commitlint/cli',
  # support for javascript plugins in neovim
  'neovim',
  # code formatter
  'prettier',
  # useful usage instructions for CLI apps
  'tldr',
  # rm -> system trash (cross platform)
  'trash-cli',
  # easily find and delete heavy node modules
  'npkill',
].freeze

CARGOS = [
  # like grep by on code structure!
  'ast-grep',
  # cargo subcommand to print package metadata like pip show, apt-cache show, npm view, gem query, etc.
  'cargo-show',
  # cargo subcommand to automatically update cargo installed binaries
  'cargo-update',
  # command prompt styling
  'starship',
  # file system tree visualizer with icons and git support
  'erdtree',
  # ls replacement with icons and git support + more
  'eza',
  # fast regex code modifications
  'fastmod',
  # benchmarking tool
  'hyperfine',
  # json explorer
  'jless',
  # nicer git diffs
  'git-delta',
  # Git GUI
  'gitui',
  # rename a list of files in your editor
  'pipe-rename',
  # A command-line tool to batch rename files and directories
  'rnr',
  # a modern alternative for sed with sensible defaults
  'sd',
  # a modern version of autojump
  'zoxide',
].freeze

COMPLETIONS = [
  ['delta', 'delta --generate-completion zsh'],
  ['erd', 'erd --completions zsh'],
  ['fx', 'fx --comp zsh'],
  ['kubectl', 'kubectl completion zsh'],
  ['pipx', 'register-python-argcomplete pipx'],
  ['sg', 'sg completions zsh'],
  ['starship', 'starship completions zsh'],
].freeze

GH_PLUGINS = [
  # PR dashboard
  'dlvhdr/gh-dash',
].freeze

TASKS = [
  {
    name: 'Default Shell',
    sync: false,
    confirmation: 'Make zsh default?',
    run_if: proc { !shell_already_zsh? },
    callback: proc { change_shell },
  },
  {
    name: 'Fonts',
    sync: false,
    confirmation: 'Install fonts?',
    callback: proc { install_fonts },
  },
  {
    name: 'Create Dirs',
    sync: true,
    callback: proc { create_dirs },
  },
  {
    name: 'Symlink Dotfiles',
    sync: true,
    confirmation: 'Link dotfiles?',
    callback:
      proc do
        symlink_dotfiles
        symlink_nested_dotfiles
      end,
  },
  {
    name: 'ZSH Plugin Manager',
    sync: false,
    confirmation: 'Install zinit?',
    callback: proc { install_zinit },
  },
  {
    name: 'ASDF',
    sync: true,
    confirmation: 'Install ASDF latest tool versions?',
    callback:
      proc do
        update_asdf
        install_asdf_plugins
        install_asdf_tools
      end,
  },
  {
    name: 'Extrenal Packages',
    sync: true,
    confirmation: 'Install external packages (gems, pips, cargos, npms)?',
    callback:
      proc do
        install_rubygems
        install_npm_packages
        install_python_packages
        install_rust_cargos
      end,
  },
  {
    name: 'Reshim ASDF tools',
    sync: true,
    confirmation: 'Reshim ASDF tools?',
    callback: proc { reshim_asdf_tools },
  },
  {
    name: 'Generate completions cache',
    sync: true,
    confirmation: 'Generate completions cache?',
    callback: proc { generate_completions_cache },
  },
  {
    name: 'GH Plugins',
    sync: true,
    confirmation: 'Install GH Plugins?',
    callback: proc { install_gh_plugins },
  },
].freeze

# Installs dotfiles and configures the machine to my preferences
# This is an idempotent script (or at least should be)
class Installer
  def install
    trap('SIGINT') do
      puts ''
      puts 'Cancelled! Exiting...'.red
      exit!
    end

    print_title

    return unless sync? || confirm('Run installer?')

    TASKS.each { |task| run_task(task) }

    puts ''
    puts '===== ALL DONE! ====='.green
  end

  private

  def run_task(task)
    task in { name: name, callback: callback, sync: sync }

    # skip non "sync" tasks when in sync mode
    # sync mode is used to just sync commonly changed files and directories
    return if sync? && !sync

    puts ''
    puts "=== TASK: #{name}".pink
    puts ''

    # skip if run_if condition is not met
    if task[:run_if] && !instance_eval(&task[:run_if])
      puts 'Skipping...'.yellow + '  (run_if: false)'.light_blue
      return
    end

    # ask for confirmation (automatically confirmed in `force` mode)
    if task[:confirmation] && !confirm(task[:confirmation])
      puts 'Skipping...'.yellow
      return
    end

    # execute the task
    instance_eval(&callback)
  end

  def print_title
    file = File.open('installer/title.txt')
    title = file.read
    puts title.red
  end

  def create_dirs
    puts '===== Creating dirs'.blue
    DIRS.each { |dir| mkdir(dir) }
  end

  def install_zinit
    puts '===== Installing zinit'.blue

    IO.popen(<<-BASH.chomp)
      ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git" && \
      mkdir -p "$(dirname $ZINIT_HOME)" && \
      rm -rf "$ZINIT_HOME" && \
      git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    BASH
  end

  def update_asdf
    puts '===== Updating asdf to latest version'.blue

    popen('asdf update')
  end

  def install_asdf_plugins
    puts '===== Installing asdf plugins'.blue

    ASDF_PLUGINS
      .each do |plugin, url|
        puts "Installing #{plugin} plugin...".light_blue
        popen("asdf plugin add #{plugin} #{url}")
      end
  end

  def install_asdf_tools
    puts '===== Installing asdf packages latest version'.blue

    plugins =
      if `uname -m`.match?(/x86/)
        ASDF_PLUGINS
      else
        ASDF_PLUGINS - ASDF_ARM_INCOMPATIBLE
      end

    plugins.each do |(plugin, _url)|
      # Thanks JavaScript! Node is released via the LTS model, so the latest
      # version is usually not what you want. This is a smoothbrained solution,
      # but I don't think it's worth investing in an abstraction here unless I
      # start using more than one runtime that has that requirement
      version =
        plugin == 'nodejs' ? IO.popen(<<-BASH).read.chomp : 'latest'
        asdf list-all nodejs | grep '^20' | sort -r --version-sort | head -n 1
        BASH

      puts "Installing #{plugin}...".light_blue
      popen(
        "asdf install #{plugin} #{version} && asdf global #{plugin} #{version}",
      )
    end
  end

  def install_gh_plugins
    puts '===== Installing gh packages'.blue
    GH_PLUGINS.each do |plugin|
      puts "Installing #{plugin}...".light_blue

      popen("gh extension install #{plugin} && gh extension upgrade #{plugin}")
    end
  end

  def install_fonts
    puts '==== Installing fonts'.blue

    # download_fonts
    [
      # Regular
      'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Regular/CaskaydiaCoveNerdFontMono-Regular.ttf',
      # Italic
      'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Regular/CaskaydiaCoveNerdFontMono-Italic.ttf',
      # Bold
      'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Bold/CaskaydiaCoveNerdFontMono-Bold.ttf',
      # Bold Italic
      'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Bold/CaskaydiaCoveNerdFontMono-BoldItalic.ttf',
    ].each do |url|
      filename = CGI.unescape(File.basename(url))
      dir =
        if mac?
          '~/Library/Fonts'
        elsif linux?
          '~/.fonts'
        else
          raise 'WTF? not a mac or linux.. who are you?'
        end

      target_path = File.expand_path(File.join(dir, filename))

      print(
        'Downloading '.light_blue + filename + ' -> '.light_blue + target_path +
          '...'.light_blue,
      )

      response = Request.new(url).resolve
      File.binwrite(target_path, response.body)

      puts 'Done'.green
      puts ''
    end
  end

  def install_rust_cargos
    puts '===== Installing Rust Cargos'.blue

    already_installed = IO.popen(<<-BASH).read.chomp.split("\n")
    cargo install --list | grep -E '^[a-z0-9_-]+ v[0-9.]+:$' | cut -f1 -d' '
    BASH

    puts 'Installing new crates...'.light_blue
    CARGOS.reject { |pkg| already_installed.include?(pkg) }
          .each { |cargo| popen("cargo install #{cargo} --locked --force") }

    puts 'Updating existing crates...'.light_blue
    popen('cargo install-update -a')
  end

  def symlink_dotfiles
    puts '===== Symlinking dotfiles'.blue

    DOTFILES.each do |source|
      raise(StandardError, "Cannot find #{source}") unless File.exist?(source)

      target = "~/.#{source}"
      print(
        'Symlinking '.light_blue + target + ' -> '.light_blue + source +
          '...'.light_blue,
      )

      link(source, target)
      puts 'Done'.green
    end
  end

  def symlink_nested_dotfiles
    puts '===== Symlinking nested dotfiles'.blue

    SYMLINK_DIRS.each do |source, target|
      print(
        'Symlinking '.light_blue + target + ' -> '.light_blue + source +
          '...'.light_blue,
      )

      link_folder(source, target)

      puts 'Done'.green
    end
  end

  def install_rubygems
    puts '===== Installing necessary RubyGems'.blue

    popen("gem install #{GEMS.join(' ')}")
  end

  def install_python_packages
    puts '===== Installing Python packages'.blue

    popen("pipx install #{PIPS3.join(' ')}")
  end

  def install_npm_packages
    puts '===== Installing NPM packages'.blue

    popen("npm install -g #{NPMS.join(' ')}")
  end

  def reshim_asdf_tools
    puts '===== Reshimming'.blue

    ASDF_PLUGINS.map { |plugin| Thread.new { popen("asdf reshim #{plugin}") } }
                .each(&:join)
  end

  def generate_completions_cache
    COMPLETIONS.map do |name, command|
      Thread.new do
        puts "===== Creating completions cache for #{name}...".blue
        popen(<<-BASH)
        #{command} > ~/.cache/zsh/completions/_#{name}
        BASH
      end
    end
    .each(&:join)

    puts '===== Refreshing completions'.blue
    popen("zsh -c 'builtin autoload -Uz +X compinit'")
  end

  def link_folder(source, target)
    full_source_path = File.expand_path(source)
    target_parent = Pathname.new(target).parent
    cmd = "zsh -c 'cd #{target_parent} && ln -s -f #{full_source_path} .'"
    popen(cmd, silent: true)
  end

  def link(source, target)
    source = File.expand_path(source)
    target = File.expand_path(target)
    popen("zsh -c 'ln -s -f #{source} #{target}'", silent: true)
  end

  def mkdir(path)
    puts 'Creating '.light_blue + path
    FileUtils.mkdir_p(File.expand_path(path))
  end

  def git_install(repo_url, install_dir)
    install_dir = File.expand_path(install_dir)

    if Dir.exist?(install_dir)
      puts '...already installed.'.pink
    else
      popen("git clone #{repo_url} #{install_dir}")
    end
  end

  # changes the default shell to zsh
  def change_shell
    popen('chsh -s zsh')
  end

  def popen(cmd, silent: false)
    puts('Running: '.light_blue + cmd.to_s) unless silent
    IO.popen(cmd) do |io|
      while (line = io.gets)
        puts line
      end
    end
  end

  def confirm(msg)
    return true if force?

    print "#{msg} [Y/n] "
    resp = gets.strip.downcase
    puts ''
    %w[y yes].include?(resp) || resp == ''
  end

  def mac?
    RUBY_PLATFORM.include?('darwin')
  end

  def linux?
    RUBY_PLATFORM.include?('linux')
  end

  def force?
    ARGV.include?('--force')
  end

  def sync?
    ARGV.include?('--sync')
  end

  def shell_already_zsh?
    ENV['SHELL'].end_with?('zsh')
  end
end

Installer.new.install
