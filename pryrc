# frozen_string_literal: true

# vim: ft=ruby

begin
  require 'awesome_print'
rescue LoadError
  warn "can't load awesome_print"
end

# Show arguments for the current method
class ArgsCommand < Pry::ClassCommand
  match '!args'
  group 'Inspector Gadgets'
  description 'show arguments for the current method'
  banner <<-BANNER
    Usage: !args
    Show arguments for the current method.
  BANNER

  def process
    args = current_method.parameters.map do |arg|
      { arg[1] => target.eval(arg[1].to_s) }
    end
    puts "Method #{colorize(current_method_name)} was called with:"
    pputs args
  end

  def current_method
    method current_method_name
  end

  def current_method_name
    target.eval '__method__'
  end

  # 36 = light blue
  def colorize(str, color_code = 36)
    "\e[#{color_code}m#{str}\e[0m"
  end

  def pputs(obj)
    # do we have the 'awesome_print' gem?
    if defined?(ap)
      ap obj
    else
      puts obj
    end
  end
end

Pry::Commands.add_command ArgsCommand
