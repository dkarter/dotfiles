# fzf stuff
export FZF_DEFAULT_COMMAND='fd --type f --follow --hidden --color=always --exclude .git --exclude node_modules --exclude vendor --exclude build --exclude _build --exclude bundle --exclude Godeps'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# add support for Ansi for fd color
export FZF_DEFAULT_OPTS="--ansi"

# Tokyonight Theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --margin 0,0
  --color=fg:#c5cdd9,bg:#000000,hl:#6cb6eb
  --color=fg+:#c5cdd9,bg+:#000000,hl+:#5dbbc1
  --color=info:#88909f,prompt:#ec7279,pointer:#d38aea
  --color=marker:#a0c980,spinner:#ec7279,header:#5dbbc1'
