# add this in sshconfig to override the 1password agent in ssh connections and
# support forward agent from the remote ssh client
#
# first match wins
# Match host * exec "env SSH_AUTH_SOCK=$HOME/.ssh/agent.sock ssh-add -l >/dev/null 2>&1"
#  IdentityAgent ~/.ssh/agent.sock
# Host *
#  IdentityAgent "~/.1password/agent.sock"

if [ -n "$SSH_CONNECTION" ] && [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
  ln -sfn "$SSH_AUTH_SOCK" "$HOME/.ssh/agent.sock"
fi
