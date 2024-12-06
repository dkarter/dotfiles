# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'net/http'
require 'cgi'
require_relative 'installer/string'
require_relative 'installer/request'

Warning[:experimental] = false

TASKS = [
  {
    name: 'Default Shell',
    sync: false,
    confirmation: 'Make zsh default?',
    run_if: proc { !shell_already_zsh? },
    callback: proc { change_shell },
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
