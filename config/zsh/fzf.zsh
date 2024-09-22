# NOTE: shell integration is enabled via zinit

# fzf stuff
export FZF_DEFAULT_COMMAND='fd --type f --follow --hidden --color=always --exclude .git --exclude node_modules --exclude vendor --exclude build --exclude _build --exclude bundle --exclude Godeps'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="
  --preview 'command-history-preview {}'
  --bind '?:toggle-preview,ctrl-a:select-all,ctrl-d:preview-page-down,ctrl-u:preview-page-up'
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'ctrl-y: copy, ctrl-/: toggle preview'
  --preview-window down:20%:wrap
  --height 50%"

# add support for Ansi for fd color
export FZF_DEFAULT_OPTS="--ansi"

# Tokyonight Theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --margin 0,0
  --color=fg:#c5cdd9,bg:#000000,hl:#6cb6eb
  --color=fg+:#c5cdd9,bg+:#000000,hl+:#5dbbc1
  --color=info:#88909f,prompt:#ec7279,pointer:#d38aea
  --color=marker:#a0c980,spinner:#ec7279,header:#5dbbc1'

# zsh-vi-mode needs to rebind ctrl-r to make it available in insert mode
# https://github.com/jeffreytse/zsh-vi-mode/issues/242
function zvm_after_init() {
  zvm_bindkey viins "^R" fzf-history-widget
}
