# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'net/http'
require 'cgi'
require_relative 'installer/string'
require_relative 'installer/request'

Warning[:experimental] = false

ASDF_INSTALL_DIR = '~/.asdf'

GEMS = [
  'bundler', # manage gem bundles for a project
  'pry', # ruby debugger
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
    confirmation: 'Install external packages (gems)?',
    callback:
      proc do
        install_rubygems
      end,
  },
  {
    name: 'Reshim ASDF tools',
    sync: true,
    confirmation: 'Reshim ASDF tools?',
    callback: proc { reshim_asdf_tools },
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

  def install_rubygems
    puts '===== Installing necessary RubyGems'.blue

    popen("gem install #{GEMS.join(' ')}")
  end

  def reshim_asdf_tools
    puts '===== Reshimming'.blue

    ASDF_PLUGINS.map { |plugin| Thread.new { popen("asdf reshim #{plugin}") } }
                .each(&:join)
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
