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


export LANG="en_US.UTF-8"

# set XDG paths
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"

# load zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# load all config files
for f in ${XDG_CONFIG_HOME}/zsh/*; do
  source $f
done


ITERM2_INTEGRATION_SCRIPT="${HOME}/.iterm2_shell_integration.zsh"
test -e "$ITERM2_INTEGRATION_SCRIPT" && source "$ITERM2_INTEGRATION_SCRIPT"


# Preferred editor for local and remote sessions
if [ -z ${EDITOR+x} ]; then
  export EDITOR='nvim'
fi

# Editor for git commits, rebases etc (don't set it if it was set already...
# i.e. by NeoVim)
if [ -z ${GIT_EDITOR+x} ]; then
  export GIT_EDITOR='nvim'
fi

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# HomeBrew
export HOMEBREW_GITHUB_API_TOKEN="<<-[[CHANGEINLOCALZSHRC]]->>"


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

# for android sdk (installed via homebrew)
export ANDROID_HOME=/usr/local/opt/android-sdk
export SSH_FINGERPRINT=$(ssh-keygen -lf ~/.ssh/id_rsa.pub | awk '{print $2}')

# for erl/iex history
export ERL_AFLAGS="-kernel shell_history enabled"

# for erlang docs (used by ElixirLS)
export KERL_BUILD_DOCS="yes"

case "$(uname -s)" in
  Darwin*)
    # ruby-build -> configure readline path from homebrew
    export RUBY_CONFIGURE_OPTS=--with-readline-dir="$BREW_PREFIX/opt/readline"
    ;;
  Linux*)
    # ruby-build -> configure readline path
    export RUBY_CONFIGURE_OPTS=--with-readline-dir="/usr/include/readline"
    ;;
esac

# set yarn binaries on path
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

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
case "$(uname -s)" in
  Darwin*)
    # don't mess with this.. or erlang will stop compiling.
    ;;
  Linux*)
    export PATH="/usr/local/opt/libpq/bin:$PATH"
    export PATH="/usr/local/opt/qt/bin:$PATH"
    export LDFLAGS="$LDFLAGS -L/usr/local/opt/qt/lib"
    export CPPFLAGS="-I/usr/local/opt/qt/include"
    ;;
esac

# OPEN SSL
# =====================================================

case "$(uname -s)" in
  Darwin*)
    # don't mess with this.. or erlang will stop compiling.
    ;;
  Linux*)
    export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

    # For compilers to find openssl@1.1 you may need to set:
    export LDFLAGS="$LDFLAGS -L/usr/local/opt/openssl@1.1/lib"
    export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openssl@1.1/include"

    # For pkg-config to find openssl@1.1 you may need to set:
    export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
    ;;
esac

export PATH="$HOME/.cargo/bin:$PATH"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
