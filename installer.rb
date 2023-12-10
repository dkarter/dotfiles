# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'net/http'
require 'cgi'
require_relative 'installer/string'
require_relative 'installer/request'

Warning[:experimental] = false

ASDF_INSTALL_DIR = '~/.asdf'

DIRS = %w[~/.config ~/.local/share/psql].freeze

DOTFILES = %w[
  airmux.yml
  aliases
  asdfrc
  ctags
  gemrc
  gitconfig
  gitignore
  gitmessage
  ignore
  p10k.zsh
  prettierrc
  pryrc
  psqlrc
  stylelintrc
  tmux.conf
  zinitrc
  zshenv
  zshrc
].freeze

SYMLINK_DIRS = [
  %w[./config/bat ~/.config/bat],
  %w[./config/nvim ~/.config/nvim],
  %w[./config/kitty ~/.config/kitty],
  %w[./config/ripgrep ~/.config/ripgrep],
  %w[./config/alacritty ~/.config/alacritty],
  %w[./config/vifm ~/.config/vifm],
  %w[./config/rubocop ~/.config/rubocop],
  %w[./config/yamllint ~/.config/yamllint],
  %w[./config/zsh ~/.config/zsh],
  %w[./config/btop ~/.config/btop],
  %w[./config/wezterm ~/.config/wezterm],
].freeze

GEMS = [
  'awesome_print', # colorize output of pry (required by .pryrc)
  'bundler', # manage gem bundles for a project
  'prettier_print', # required by prettier ruby plugin
  'syntax_tree', # required by prettier ruby plugin
  'syntax_tree-rbs', # required by prettier ruby plugin
  'syntax_tree-haml', # required by prettier ruby plugin
  'neovim', # for NeoVim ruby plugins
  'pry', # ruby debugger
  'solargraph', # ruby language server
].freeze

PIPS3 = [
  'codespell', # check for spelling mistakes in code.
  'neovim', # NeoVim python3 support
  'neovim-remote', # allow controlling neovim remotely
  'yq', # like jq but for yaml files
  'howdoi', # ask for coding help directly from the terminal
].freeze

ASDF_PLUGINS = %w[
  bat
  direnv
  elixir
  erlang
  exa
  fd
  fzf
  github-cli
  golang
  lazygit
  lua
  neovim
  nodejs
  python
  rebar
  ripgrep
  ruby
  rust
  tmux
  yarn
].freeze

ASDF_ARM_INCOMPATIBLE = %w[github-cli fzf fd ripgrep neovim].freeze

NPMS = %w[
  @commitlint/cli
  @prettier/plugin-ruby
  neovim
  prettier
  tldr
  trash-cli
  npkill
].freeze

CARGOS = [
  # manage tmux sessions via yaml files (similar to tmuxinator)
  'airmux',
  # file system tree visualizer with icons and git support
  'erdtree',
  # fast regex code modifications
  'fastmod',
  # nicer git diffs
  'git-delta',
  # rename a list of files in your editor
  'pipe-rename',
  # a modern version of autojump
  'zoxide',
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
  { name: 'Create Dirs', sync: true, callback: proc { create_dirs } },
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
    sync: false,
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
    sync: false,
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
    sync: false,
    confirmation: 'Reshim ASDF tools?',
    callback: proc { reshim_asdf_tools },
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

    asdf_command('asdf update')
  end

  def install_asdf_plugins
    puts '===== Installing asdf plugins'.blue

    ASDF_PLUGINS.each do |plugin, url|
      puts "Installing #{plugin} plugin...".light_blue
      asdf_command("asdf plugin add #{plugin} #{url}")
    end
  end

  def install_asdf_tools
    puts '===== Installing asdf packages latest version'.blue

    # import OpenPGP keysfornode
    popen(
      "zsh -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'",
    )

    plugins =
      if `uname -m`.match?(/x86/)
        ASDF_PLUGINS
      else
        ASDF_PLUGINS - ASDF_ARM_INCOMPATIBLE
      end

    plugins.each do |plugin, _url|
      puts "Installing #{plugin}...".light_blue
      asdf_command(
        "asdf install #{plugin} latest && asdf global #{plugin} latest",
      )
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

    CARGOS.each { |cargo| popen("cargo install #{cargo}") }
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

    asdf_command("gem install #{GEMS.join(' ')}")
  end

  def install_python_packages
    puts '===== Installing Python packages'.blue

    asdf_command("pip3 install #{PIPS3.join(' ')}")
  end

  def install_npm_packages
    puts '===== Installing NPM packages'.blue

    asdf_command("npm install -g #{NPMS.join(' ')}")
  end

  def asdf_command(cmd)
    popen("zsh -c '. #{ASDF_INSTALL_DIR}/asdf.sh && #{cmd}'")
  end

  def reshim_asdf_tools
    puts '===== Reshimming'.blue

    ASDF_PLUGINS.each do |plugin, _url|
      asdf_command("asdf reshim #{plugin}")
    end
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
