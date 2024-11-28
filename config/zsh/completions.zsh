# fzf-tab and completion settings
# -------------------------------
# case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# --------------------------------

# red dots to be displayed while waiting for completion
export COMPLETION_WAITING_DOTS="true"

# load our own completion functions
fpath=(~/.cache/zsh/completions /usr/local/share/zsh/site-functions $fpath)

# append asdf completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# append homebrew completions to fpath
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# completion only refresh once a day
# autoload -U compinit
# compinit
autoload -Uz +X bashcompinit && bashcompinit
autoload -Uz +X compinit

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

compinit -C

# requires brew install carapace
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
source <(carapace _carapace)

