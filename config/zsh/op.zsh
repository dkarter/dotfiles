# Enable 1Password SSH Agent, but only if there isn't already a forwarded agent
# (i.e. we're in a remote SSH session with ForwardAgent)
if [[ -z $SSH_AUTH_SOCK || ! -S $SSH_AUTH_SOCK ]]; then
  export SSH_AUTH_SOCK=~/.1password/agent.sock
fi

# prevent an issue with TELEPORT conflicting with 1password agent
export TELEPORT_ADD_KEYS_TO_AGENT=no
