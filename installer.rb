# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'net/http'
require 'cgi'
require_relative 'installer/string'
require_relative 'installer/request'

Warning[:experimental] = false

GEMS = [
  'bundler', # manage gem bundles for a project
  'pry', # ruby debugger
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
    name: 'Extrenal Packages',
    sync: true,
    confirmation: 'Install external packages (gems)?',
    callback:
      proc do
        install_rubygems
      end,
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
