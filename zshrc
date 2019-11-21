# profiling top
# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '

# logfile=~/zsh_profiling_result
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile

# setopt XTRACE
# /profiling top


# zmodload zsh/zprof

# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion only refresh once a day
# autoload -U compinit
# compinit
autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# 10ms for key sequences
KEYTIMEOUT=1

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Allow [ or ] whereever you want
unsetopt nomatch

# emacs mode
bindkey -e

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# Bind Option-left-right to previous-next word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [ -f $config ]; then
            . $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#  ▄███████▄     ▄████████    ▄█    █▄
# ██▀     ▄██   ███    ███   ███    ███
#       ▄███▀   ███    █▀    ███    ███
#  ▀█▀▄███▀▄▄   ███         ▄███▄▄▄▄███▄▄
#   ▄███▀   ▀ ▀███████████ ▀▀███▀▀▀▀███▀
# ▄███▀                ███   ███    ███
# ███▄     ▄█    ▄█    ███   ███    ███
#  ▀████████▀  ▄████████▀    ███    █▀

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="mm/dd/yyyy"

# zsh syntax highlighting
# pre-requisite: `brew install zsh-syntax-highlighting`
syntax_plug=/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [ -f $syntax_plug ]; then
  source $syntax_plug
fi

# zsh history search
# pre-requisite `brew install zsh-history-substring-search`
# NOTE: must be placed after zsh-syntax-highlighting if used together
# readme: /usr/local/opt/zsh-history-substring-search/README.md
hist_plug=/usr/local/opt/zsh-history-substring-search/zsh-history-substring-search.zsh
if [ -f $hist_plug ]; then
  source $hist_plug
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi

# zsh completions
# pre-requisite: `brew install zsh-completions`
fpath=(/usr/local/share/zsh-completions $fpath)

# Preferred editor for local and remote sessions
if [ -z ${EDITOR+x} ]; then
  export EDITOR='nvim'
fi

# Editor for git commits, rebases etc (don't set it if it was set already...
# i.e. by NeoVim)
if [ -z ${GIT_EDITOR+x} ]; then
  export GIT_EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# For GO
export CC=clang
export GOPATH="<<-[[CHANGEINLOCALZSHRC]]->>"

# HomeBrew
export HOMEBREW_GITHUB_API_TOKEN="<<-[[CHANGEINLOCALZSHRC]]->>"

#Key shortcuts
bindkey "^[f" forward-word
bindkey "^[b" backward-word

bindkey '^r' history-incremental-search-backward

# ctrl-space accepts suggestions
# bindkey '^t' autosuggest-accept

export KEYTIMEOUT=1

function mux() {
  if [ -n "$TMUX" ]; then
    echo "ERROR: You're already in a tmux session. Nesting tmux sessions is a bad idea." >&2
    return 1
  fi

  if [ -z "$1" ]; then
    session_name="$(basename $(pwd) | sed -e 's/\./-/g')"
  else
    session_name=$1
  fi

  if ! $(tmux has-session -t $session_name &>/dev/null); then
    echo "creating session $session_name"
    # tmux new-session -s $session_name -n 'main'
    cols="$(tput cols)"
    tmux new-session -d -n 'code' -s $session_name -x${cols-150} -y50 'reattach-to-user-namespace -l zsh'
  fi

  echo "attaching session $session_name"
  reattach-to-user-namespace tmux attach-session -t $session_name
}

# set homebrew on path
export PATH="/usr/local/bin:$PATH"

# set cabal and haskell binaries on path
export PATH="$HOME/.cabal/bin:$HOME/.local/bin:$PATH"

# For PostgreSQL
export PGDATA="/Library/PostgreSQL/9.3/data"

if $(command -v brew >/dev/null); then
  # autojump (requires brew install autojump)
  [[ -s "$BREW_PREFIX/etc/profile.d/autojump.sh" ]] && . "$BREW_PREFIX/etc/profile.d/autojump.sh"
fi

# fzf stuff
export FZF_DEFAULT_COMMAND='fd --type f --follow --color=always --exclude .git --exclude node_modules --exclude vendor --exclude build --exclude _build --exclude bundle --exclude Godeps'
# add support for ctrl+o to open selected file in VS Code, also ansi for fd
# color
export FZF_DEFAULT_OPTS="--ansi --bind='ctrl-o:execute(code {})+abort'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if $(command -v fzf >/dev/null); then
  # fo [FUZZY PATTERN] - Open the selected file with the default editor
  #   - Bypass fuzzy finder if there's only one match (--select-1)
  #   - Exit if there's no match (--exit-0)
  #   - CTRL-O to open with `open` command,
  #   - CTRL-E or Enter key to open with the $EDITOR
  fo() {
    local out file key
    out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
    key=$(head -1 <<<"$out")
    file=$(head -2 <<<"$out" | tail -1)
    if [ -n "$file" ]; then
      [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-nvim} "$file"
    fi
  }

  # fcd - cd to selected directory
  fcd() {
    local dir
    dir=$(find ${1:-*} -path '*/\.*' -prune \
      -o -type d -print 2>/dev/null | fzf +m) &&
      cd "$dir"
  }

  # fcda - including hidden directories
  fcda() {
    local dir
    dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
  }

  # cdf - cd into the directory of the selected file
  fcdf() {
    local file
    local dir
    file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
  }

  # fh - repeat history
  fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
  }

  # fkill - kill process
  fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
      kill -${1:-9} $pid
    fi
  }

  # fgco - checkout git branch/tag
  fgco() {
    local tags branches target
    tags=$(
      git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
    ) || return
    branches=$(
      git branch --all | grep -v HEAD |
        sed "s/.* //" | sed "s#remotes/[^/]*/##" |
        sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
    ) || return
    target=$(
      (
        echo "$tags"
        echo "$branches"
      ) |
        fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2
    ) || return
    git checkout $(echo "$target" | awk '{print $2}')
  }

  # fgcoc - checkout git commit
  fgcoc() {
    local commits commit
    commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
      commit=$(echo "$commits" | fzf --tac +s +m -e) &&
      git checkout $(echo "$commit" | sed "s/ .*//")
  }

  # fgshow - git commit browser
  fgshow() {
    git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                  (grep -o '[a-f0-9]\{7\}' | head -1 |
                  xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                  {}
  FZF-EOF"
  }

  # fgcs - get git commit sha
  # example usage: git rebase -i `fcs`
  fgcs() {
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
      commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
      echo -n $(echo "$commit" | sed "s/ .*//")
  }

  # fgstash - easier way to deal with stashes
  # type fstash to get a list of your stashes
  # enter shows you the contents of the stash
  # ctrl-d shows a diff of the stash against your current HEAD
  # ctrl-b checks the stash out as a branch, for easier merging
  fgstash() {
    local out q k sha
    while out=$(
      git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
        fzf --ansi --no-sort --query="$q" --print-query \
          --expect=ctrl-d,ctrl-b
    ); do
      mapfile -t out <<<"$out"
      q="${out[0]}"
      k="${out[1]}"
      sha="${out[-1]}"
      sha="${sha%% *}"
      [[ -z "$sha" ]] && continue
      if [[ "$k" == 'ctrl-d' ]]; then
        git diff $sha
      elif [[ "$k" == 'ctrl-b' ]]; then
        git stash branch "stash-$sha" $sha
        break
      else
        git stash show -p $sha
      fi
    done
  }

  # Install one or more versions of specified language
  # e.g. `vmi rust` # => fzf multimode, tab to mark, enter to install
  # if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
  # Mnemonic [V]ersion [M]anager [I]nstall
  vmi() {
    local lang=${1}

    if [[ ! $lang ]]; then
      lang=$(asdf plugin-list | fzf)
    fi

    if [[ $lang ]]; then
      local versions=$(asdf list-all $lang | fzf -m)
      if [[ $versions ]]; then
        for version in $(echo $versions);
        do; asdf install $lang $version; done;
      fi
    fi
  }

  # fgst - pick files from `git status -s` 
  is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
  }

  fgst() {
    # "Nothing to see here, move along"
    is_in_git_repo || return

    local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
      printf '%q ' "$item" | cut -d " " -f 2
    done
    echo
  }
fi

# git functions
function clonecd() {
  # find a way to pass the rest of the arguments to
  # git clone in a variadic style to allow still using
  # --depth=1 etc
  git clone git@github.com:"$1.git" && cd "${1#*/}"
}

function shallowclone() {
  git clone --depth=1 git@github.com:"$1.git" && cd "${1#*/}"
}

# relative time
in() {
  if [ "$(uname)" == "Darwin" ]; then
    gdate -d"$(gdate) +$1 $2" "+%Y-%m-%d"
  else
    date -d"$(date) +$1 $2" "+%Y-%m-%d"
  fi
}

# checkout a PR from github
function pr() {
  local origin pr
  if [[ $# == 0 ]]; then
    echo "usage: pr [remote] <ref>"
    return 1
  elif [[ $# == 1 ]]; then
    origin=$(git config branch.master.remote || echo origin)
    pr=$1
  else
    origin=$1
    pr=$2
  fi
  git fetch $origin refs/pull/${pr}/head || return
  git checkout -q FETCH_HEAD
}

# tree command ignoring gitignored files/dirs
function gtree() {
  git_ignore_file=$(git config --get core.excludesfile)

  if [[ -f ${git_ignore_file} ]]; then
    tree -C -I"$(tr '\n' '\|' <"${git_ignore_file}")" "${@}"
  else
    tree -C "${@}"
  fi
}

# split strings
# Usage: split "string" "delimiter"
split() {
   IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
   printf '%s\n' "${arr[@]}"
}

# Easily jump to man page for a built-in command e.g. bashman fg
bashman() {
  man bash | less -p "^       $1 "
}

# color man pages
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode – red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode – bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode – yellow
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode – cyan

# for android sdk (installed via homebrew)
export ANDROID_HOME=/usr/local/opt/android-sdk
export SSH_FINGERPRINT=$(ssh-keygen -lf ~/.ssh/id_rsa.pub | awk '{print $2}')

# for erl/iex history
export ERL_AFLAGS="-kernel shell_history enabled"

# show if a command is available as a homebrew package if cannot find it
# disabling this because it slows down zsh initialization
# if brew command command-not-found-init >/dev/null 2>&1; then
#   eval "$(brew command-not-found-init)"
# fi

# Compile erlang with OpenSSL from Homebrew via asdf
export ERLANG_OPENSSL_PATH="/usr/local/opt/openssl"
export KERL_CONFIGURE_OPTIONS="--with-ssl=/usr/local/opt/openssl"

# asdf global version manager
source "$HOME/.asdf/asdf.sh"
source "$HOME/.asdf/completions/asdf.bash"

# ruby-build -> configure readline path from homebrew
export RUBY_CONFIGURE_OPTS=--with-readline-dir="$BREW_PREFIX/opt/readline"

# TODO: can we do this with zsh-async
# set yarn binaries on path
export PATH="$(yarn global bin):$PATH"

# add iex before a command with <c-x> i
bindkey -s "^Xi" "^[Iiex -S ^[A"

# enable direnv
eval "$(direnv hook zsh)"

# tell RipGrep where to look for it's config file
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
[ -f ~/.zplugrc ] && source ~/.zplugrc

# load aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# add go path bin to path
export PATH=$PATH:$GOPATH/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# qt
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/qt/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/qt/lib"
export CPPFLAGS="-I/usr/local/opt/qt/include"

# z - autojump alternative
source /usr/local/etc/profile.d/z.sh

# zprof
# profiling bottom
# unsetopt XTRACE
# exec 2>&3 3>&-
# setopt promptsubst
# /profiling bottom
