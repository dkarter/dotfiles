# fzf-tab and completion settings
# -------------------------------
# case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
# Use eval to work around shfmt parameter expansion limitation
eval "zstyle ':completion:*' list-colors \${(s.:.)LS_COLORS}"
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always --icon=always --group-directories-first $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# --------------------------------

# === Completion paths ===
fpath=($HOME/.cache/zsh/completions /usr/local/share/zsh/site-functions $fpath)

# === Optional: Homebrew completions ===
homebrew_comps="/opt/homebrew/share/zsh/site-functions"
[[ -d $homebrew_comps ]] && fpath=($homebrew_comps $fpath)

# === Load completion system ===
autoload -Uz compinit bashcompinit
compinit
bashcompinit
