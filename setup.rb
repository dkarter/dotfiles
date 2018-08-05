require 'fileutils'

def popen(cmd)
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
  FileUtils.mkdir_p(File.expand_path(path))
end

puts '===== Symlinking dotfiles'

files = %w[
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
  ripgreprc
  stylelintrc
  tmux.conf
  vimrc
  vimrc.bundles
  zplugrc
  zshenv
  zshrc
].freeze

files.each do |source|
  raise(StandardError, "Cannot find #{source}") unless File.exist?(source)
  target = "~/.#{source}"
  print "Creating symlink to #{target}..."
  link(source, target)
  puts 'Done'
end

puts '===== Creating dirs for nested dotfiles'

mkdir('~/.vim')
mkdir('~/.config')

puts '===== Symlinking nested dotfiles'

link('vim/UltiSnips',  '~/.vim/')
link('config/nvim',    '~/.config/')
link('config/kitty',   '~/.config/')
link('config/ripgrep', '~/.config/')

puts '===== Installing necessary gems'

gems = [
  'pry',           # ruby debugger
  'pry-byebug',    # better debugging experience (required by .pryrc)
  'pry-clipboard', # easily copy and paste stuff from pry (required by .pryrc)
  'awesome_print', # colorize output of pry (required by .pryrc)
  'rouge',         # for syntax highlighting in fzf in vim
  'neovim',        # for NeoVim ruby plugins
  'solargraph',    # ruby language server
  'pry',           # ruby debugging
  'iStats',        # computer peripheral stats
]

cmd = "gem install #{gems.join(' ')}"
puts cmd
popen(cmd)

puts '===== Installing python packages'

pips3 = [
  'neovim',        # NeoVim python3 support
  'neovim-remote', # allow controlling neovim remotely
]

cmd = "pip3 install #{pips3.join(' ')}"
puts cmd
popen(cmd)

pips = [
  'neovim', # NeoVim python2 support
]

cmd = "pip install #{pips.join(' ')}"
puts cmd
popen(cmd)

puts '===== ALL DONE! ====='
