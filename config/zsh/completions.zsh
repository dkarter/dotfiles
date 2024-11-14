# case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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
export CARAPACE_BRIDGES='zsh,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

