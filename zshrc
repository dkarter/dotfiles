#  ▄███████▄     ▄████████    ▄█    █▄
# ██▀     ▄██   ███    ███   ███    ███
#       ▄███▀   ███    █▀    ███    ███
#  ▀█▀▄███▀▄▄   ███         ▄███▄▄▄▄███▄▄
#   ▄███▀   ▀ ▀███████████ ▀▀███▀▀▀▀███▀
# ▄███▀                ███   ███    ███
# ███▄     ▄█    ▄█    ███   ███    ███
#  ▀████████▀  ▄████████▀    ███    █▀
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

export LANG="en_US.UTF-8"

# load zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion only refresh once a day
# autoload -U compinit
# compinit
autoload -Uz +X bashcompinit && bashcompinit
autoload -Uz +X compinit

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

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

ITERM2_INTEGRATION_SCRIPT="${HOME}/.iterm2_shell_integration.zsh"
test -e "$ITERM2_INTEGRATION_SCRIPT" && source "$ITERM2_INTEGRATION_SCRIPT"

# red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="mm/dd/yyyy"

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

# HomeBrew
export HOMEBREW_GITHUB_API_TOKEN="<<-[[CHANGEINLOCALZSHRC]]->>"

#Key shortcuts
bindkey "^[f" forward-word
bindkey "^[b" backward-word

bindkey '^r' history-incremental-search-backward

export KEYTIMEOUT=1

# set homebrew on path
export PATH="/usr/local/bin:$PATH"

# set cabal and haskell binaries on path
export PATH="$HOME/.cabal/bin:$HOME/.local/bin:$PATH"

# Golang
export PATH="/usr/local/go/bin:$PATH"

# For PostgreSQL
export PGDATA="/Library/PostgreSQL/9.3/data"

# autojump on Debian
if [[ -f /usr/share/autojump/autojump.sh ]]; then
  source /usr/share/autojump/autojump.sh
fi

# autojump on mac (requires brew install autojump)
if $(command -v brew >/dev/null); then
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

# shows cheat sheet for a command
function cht() {
  curl --silent "https://cht.sh/$1" | bat -p
}

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

# ask for confirmation in scripts
function confirm() {
  read -p "Are you sure? " -n 1 -r
  echo    # move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    exit 1
  fi
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

case "$(uname -s)" in
  Darwin*)
    # Compile erlang with OpenSSL from Homebrew via asdf
    export ERLANG_OPENSSL_PATH="/usr/local/opt/openssl@1.1"
    export KERL_CONFIGURE_OPTIONS="--with-ssl=/usr/local/opt/openssl@1.1"

    # ruby-build -> configure readline path from homebrew
    export RUBY_CONFIGURE_OPTS=--with-readline-dir="$BREW_PREFIX/opt/readline"
    ;;
  Linux*)
    # ruby-build -> configure readline path
    export RUBY_CONFIGURE_OPTS=--with-readline-dir="/usr/include/readline"
    ;;
esac

# asdf global version manager
source "$HOME/.asdf/asdf.sh"
source "$HOME/.asdf/completions/asdf.bash"

# TODO: can we do this with zsh-async
# set yarn binaries on path
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# add iex before a command with <c-x> i
bindkey -s "^Xi" "^[Iiex -S ^[A"

# enable direnv
eval "$(direnv hook zsh)"

# tell RipGrep where to look for it's config file
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

[[ -f ~/.zinitrc ]] && source ~/.zinitrc

# load aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# add go path bin to path
export PATH=$PATH:$GOPATH/bin

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# qt
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/usr/local/opt/qt/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/qt/lib"
export CPPFLAGS="-I/usr/local/opt/qt/include"

# OPEN SSL
# =====================================================
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# For compilers to find openssl@1.1 you may need to set:
export LDFLAGS="$LDFLAGS -L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openssl@1.1/include"

# For pkg-config to find openssl@1.1 you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

export PATH="$HOME/.cargo/bin:$PATH"

# configure neovim remote
[[ ! -f ~/.config/zsh/nvr.zsh ]] || source ~/.config/zsh/nvr.zsh

# zprof
# profiling bottom
# unsetopt XTRACE
# exec 2>&3 3>&-
# setopt promptsubst
# /profiling bottom

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
