# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require_relative 'installer/string'

ASDF_INSTALL_DIR = '~/.asdf'
GIT_TEMPLATE_INSTALL_DIR = '~/.git_template'

DIRS = %w[~/.config].freeze

DOTFILES = %w[
  airmux.yml
  aliases
  asdfrc
  ctags
  eslintrc
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
  %w[./config/nvim ~/.config/nvim],
  %w[./config/kitty ~/.config/kitty],
  %w[./config/ripgrep ~/.config/ripgrep],
  %w[./config/alacritty ~/.config/alacritty],
  %w[./config/vifm ~/.config/vifm],
  %w[./config/rubocop ~/.config/rubocop],
].freeze

GEMS = [
  'pry', # ruby debugger
  'awesome_print', # colorize output of pry (required by .pryrc)
  'neovim', # for NeoVim ruby plugins
  'solargraph', # ruby language server
].freeze

PIPS3 = [
  'neovim', # NeoVim python3 support
  'neovim-remote', # allow controlling neovim remotely
].freeze

ASDF_PLUGINS = [
  'bat',
  'direnv',
  'elixir',
  'elm',
  'erlang',
  'exa',
  'fd',
  'fzf',
  'github-cli',
  'golang',
  'lazygit',
  'lua',
  %w[
    lua-language-server
    https://github.com/shun-shobon/asdf-lua-language-server
  ],
  'neovim',
  'nodejs',
  'python',
  'rebar',
  'ripgrep',
  'ruby',
  'rust',
  'tmux',
  'yarn',
].freeze

NPMS = %w[
  neovim
  tldr
  bash-language-server
  @elm-tooling/elm-language-server
  dockerfile-language-server-nodejs
  git-split-diffs
  diff-so-fancy
  typescript
  typescript-language-server
  dockerfile-language-server-nodejs
  @ansible/ansible-language-server
  vscode-langservers-extracted
  prettier
  @prettier/plugin-ruby
].freeze

CARGOS = %w[stylua airmux fastmod].freeze

# Installs dotfiles and configures the machine to my preferences
# This is an idempotent script (or at least should be)
class Installer
  # This is the main function containing all the setup steps in their intended
  # order
  # rubocop:disable Metrics/CyclomaticComplexity
  def install
    print_title

    return unless confirm('Run installer?')

    # Create necessary dirs for installer
    create_dirs

    # Change default shell
    change_shell if !shell_already_zsh? && confirm('Make zsh default?')

    # Zsh Plugin Manager
    install_zinit if confirm('Install zinit?')

    # ASDF
    if confirm('Install ASDF and latest language versions?')
      install_asdf
      update_asdf
      install_asdf_plugins
      install_asdf_languages
    end

    # Dotfiles
    if confirm('Link dotfiles?')
      symlink_dotfiles
      symlink_nested_dotfiles
    end

    # External packages
    if confirm('Install external packages (gems, pips, cargos, npms)?')
      install_rubygems
      install_npm_packages
      install_python_packages
      install_rust_cargos
    end

    puts '===== ALL DONE! ====='.green
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def print_title
    file = File.open('installer/title.txt')
    title = file.read
    puts title.green
  end

  def create_dirs
    puts '===== Creating dirs'.yellow
    DIRS.each { |dir| mkdir(dir) }
  end

  def install_zinit
    puts '===== Installing zinit'.yellow

    IO.popen(<<-COMMAND.chomp)
      ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git" && \
      mkdir -p "$(dirname $ZINIT_HOME)" && \
      rm -rf "$ZINIT_HOME" && \
      git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    COMMAND
  end

  def install_asdf
    puts '===== Installing asdf'.yellow

    git_install('git@github.com:asdf-vm/asdf.git', ASDF_INSTALL_DIR)
  end

  def update_asdf
    puts '===== Updating asdf to latest version'.yellow

    asdf_command('asdf update')
  end

  def install_asdf_plugins
    puts '===== Installing asdf plugins'.yellow

    ASDF_PLUGINS.each do |plugin, url|
      puts "Installing #{plugin} plugin...".light_blue
      asdf_command("asdf plugin add #{plugin} #{url}")
    end
  end

  def install_asdf_languages
    puts '===== Installing asdf languages latest version'.yellow

    # import OpenPGP keysfornode
    popen(
      "zsh -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'",
    )

    ASDF_PLUGINS.each do |plugin, _url|
      puts "Installing #{plugin}...".light_blue
      asdf_command(
        "asdf install #{plugin} latest && asdf global #{plugin} $(asdf latest #{plugin})",
      )
    end
  end

  def install_rust_cargos
    puts '===== Installing Rust Cargos'.yellow

    CARGOS.each { |cargo| popen("cargo install #{cargo}") }
  end

  def symlink_dotfiles
    puts '===== Symlinking dotfiles'.yellow

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
    puts '===== Symlinking nested dotfiles'.yellow

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
    puts '===== Installing necessary RubyGems'.yellow

    asdf_command("gem install #{GEMS.join(' ')}")
  end

  def install_python_packages
    puts '===== Installing Python packages'.yellow

    asdf_command("pip3 install #{PIPS3.join(' ')}")
  end

  def install_npm_packages
    puts '===== Installing NPM packages'.yellow

    asdf_command("npm install -g #{NPMS.join(' ')}")
  end

  def asdf_command(cmd)
    popen("zsh -c '. #{ASDF_INSTALL_DIR}/asdf.sh && #{cmd}'")
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
    print "#{msg} (y/n) "
    resp = gets.strip.downcase
    puts ''
    %w[y yes].include?(resp)
  end

  def shell_already_zsh?
    ENV['SHELL'].end_with?('zsh')
  end
end

Installer.new.install
