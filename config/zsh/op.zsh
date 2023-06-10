eval "$(op completion zsh)"
compdef _op op

# Enable SSH Agent for all hosts
export SSH_AUTH_SOCK=~/.1password/agent.sock
