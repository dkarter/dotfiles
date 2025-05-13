# Enable extended globbing
setopt extendedglob

# Allow [ or ] wherever you want
unsetopt nomatch

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
# don't save lines starting with space in history
setopt HIST_IGNORE_SPACE
# do not save duplicate of prior command
setopt HIST_IGNORE_ALL_DUPS
# don’t wait for shell to exit to save history lines
setopt INC_APPEND_HISTORY
export HISTFILE=~/.zhistory
export HISTSIZE=4096
export SAVEHIST=4096
export DIRSTACKSIZE=5
export HIST_STAMPS="yyyy-mm-dd"

# support comments in shell (makes it easy to comment out a command)
setopt INTERACTIVE_COMMENTS

# 10ms for key sequences
export KEYTIMEOUT=1

# color man pages
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode – bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode – yellow
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode – cyan
