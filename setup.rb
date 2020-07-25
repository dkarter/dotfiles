# frozen_string_literal: true

require 'fileutils'

ASDF_INSTALL_DIR = '~/.asdf'
GIT_TEMPLATE_INSTALL_DIR = '~/.git_template'
ZINIT_INSTALL_DIR = '~/.zinit/bin'

DIRS = [
  '~/.zinit',
  '~/.vim',
  '~/.vim/tmp',
  '~/.config'
].freeze

DOTFILES = %w[
  aliases
  asdfrc
  ctags
  eslintrc
  gemrc
  gitconfig
  gitignore
  gitmessage
  gvimrc
  ignore
  prettierrc
  pryrc
  psqlrc
  stylelintrc
  tmux.conf
  vimrc
  vimrc.bundles
  zinitrc
  zshenv
  zshrc
].freeze

SYMLINK_DIRS = [
  ['vim/UltiSnips', '~/.vim/'],
  ['config/nvim', '~/.config/'],
  ['config/kitty', '~/.config/'],
  ['config/ripgrep', '~/.config/']
].freeze

GEMS = [
  'pry',           # ruby debugger
  'pry-byebug',    # better debugging experience (required by .pryrc)
  'pry-clipboard', # easily copy and paste stuff from pry (required by .pryrc)
  'awesome_print', # colorize output of pry (required by .pryrc)
  'neovim',        # for NeoVim ruby plugins
  'solargraph'     # ruby language server
].freeze

PIPS3 = [
  'neovim',        # NeoVim python3 support
  'neovim-remote'  # allow controlling neovim remotely
].freeze

ASDF_PLUGINS = %w[
  elixir
  elm
  erlang
  golang
  nodejs
  python
  ruby
  rust
].freeze

NPMS = %w[
  yarn
  neovim
].freeze

CARGOS = %w[
  devicon-lookup
].freeze

class Installer
  def install
    print_title
    create_dirs
    install_zinit
    install_asdf
    update_asdf
    install_asdf_plugins
    install_asdf_languages if confirm('Install asdf languages latest?')
    install_git_template
    symlink_dotfiles
    symlink_nested_dotfiles
    install_rubygems
    install_npm_packages
    install_python_packages
    install_rust_cargos
    install_vim_plugins

    puts '===== ALL DONE! ====='.green
  end

  private

  def print_title
    puts <<~TITLE



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

                  -- Dorian's Dotfiles Installer --


    TITLE
  end

  def create_dirs
    puts '===== Creating dirs'.yellow
    DIRS.each do |dir|
      mkdir(dir)
    end
  end

  def install_zinit
    puts '===== Installing zinit'.yellow

    git_install('https://github.com/zdharma/zinit.git', ZINIT_INSTALL_DIR)
  end

  def install_asdf
    puts '===== Installing asdf'.yellow

    git_install('https://github.com/asdf-vm/asdf.git', ASDF_INSTALL_DIR)
  end

  def update_asdf
    puts '===== Updating asdf to latest version'.yellow

    asdf_command('asdf update')
  end

  def install_asdf_plugins
    puts '===== Installing asdf plugins'.yellow

    ASDF_PLUGINS.each do |plugin|
      puts "Installing #{plugin} plugin...".light_blue
      asdf_command("asdf plugin-add #{plugin}")
    end
  end

  def install_asdf_languages
    puts '===== Installing asdf languages latest version'.yellow

    # import OpenPGP keysfornode
    popen("bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'")

    ASDF_PLUGINS.each do |plugin|
      puts "Installing #{plugin}...".light_blue
      asdf_command(
        "asdf install #{plugin} latest && asdf global #{plugin} $(asdf latest #{plugin})"
      )
    end
  end

  def install_git_template
    puts '===== Installing git_template'.yellow

    git_install(
      'https://github.com/greg0ire/git_template',
      GIT_TEMPLATE_INSTALL_DIR
    )
  end

  def install_rust_cargos
    puts '===== Installing Rust Cargos'.yellow

    CARGOS.each do |cargo|
      popen("cargo install #{cargo}")
    end
  end

  def symlink_dotfiles
    puts '===== Symlinking dotfiles'.yellow

    DOTFILES.each do |source|
      raise(StandardError, "Cannot find #{source}") unless File.exist?(source)

      target = "~/.#{source}"
      print 'Symlinking '.light_blue + target.to_s + '...'.light_blue
      link(source, target)
      puts 'Done'.green
    end
  end

  def symlink_nested_dotfiles
    puts '===== Symlinking nested dotfiles'.yellow

    SYMLINK_DIRS.each do |source, target|
      print 'Symlinking '.light_blue + source + ' -> '.light_blue + target + '...'.light_blue
      link(source, target)
      puts 'Done'.green
    end
  end

  def install_rubygems
    puts '===== Installing necessary RubyGems'.yellow

    popen("gem install #{GEMS.join(' ')}")
  end

  def install_python_packages
    puts '===== Installing Python packages'.yellow

    popen("pip3 install #{PIPS3.join(' ')}")
  end

  def install_npm_packages
    puts '===== Installing NPM packages'.yellow

    popen("npm install -g #{NPMS.join(' ')}")
  end

  def install_vim_plugins
    puts '===== Installing NeoVim plugins'.yellow

    popen('curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    popen('nvim +PlugInstall +qall')
  end

  def asdf_command(cmd)
    popen(". #{ASDF_INSTALL_DIR}/asdf.sh && #{cmd}")
  end

  def popen(cmd)
    puts 'Running: '.light_blue + cmd.to_s
    IO.popen(cmd) do |io|
      while (line = io.gets)
        puts line
      end
    end
  end

  def link(source, target)
    FileUtils.ln_sf(File.expand_path(source), File.expand_path(target))
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

  def confirm(msg)
    print "#{msg} (y/n) "
    resp = gets.strip.downcase
    puts ''
    %w[y yes].include?(resp)
  end
end

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

Installer.new.install
