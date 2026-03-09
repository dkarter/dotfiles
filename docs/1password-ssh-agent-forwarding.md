# 1Password SSH agent forwarding

1Password handles SSH auth without storing keys on disk, which is great until you
SSH into a remote machine and try to push/pull to/from GitHub. The machine
prompts 1Password, 1Password needs Touch ID or Apple Watch, and neither is
available over a remote session. This doc covers how the dotfiles are configured
to handle this.

## How it works

When you SSH into a remote machine with agent forwarding enabled, your local SSH
agent (1Password) is accessible on the remote machine via a forwarded socket. The
remote machine doesn't need its own copy of your GitHub key - it borrows yours
through the tunnel.

Two things need to be true for this to work:

1. The client machine must forward the agent (`ForwardAgent yes`)
2. The remote machine must use the forwarded socket instead of its local 1Password
   socket when one is available

## SSH config (both machines)

Add a `Host github.com` block _above_ the `Host *` block. Order matters — ssh reads
the first matching block and merges options downward, so specific hosts must come
first.

```sshconfig
# Use the forwarded agent when available (set by ForwardAgent on the client).
# When running interactively, SSH_AUTH_SOCK points to 1Password anyway.
Host github.com
  IdentityAgent SSH_AUTH_SOCK

# Default: use 1Password for everything else
Host *
  IdentityAgent ~/.1password/agent.sock
```

On macOS the 1Password socket path is
`~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`. The dotfiles
use the symlink at `~/.1password/agent.sock` which the taskfile at
`./taskfiles/1password.yaml` creates automatically on `task install`.

For the machine you're connecting _from_, make sure the target host has forwarding
enabled:

```sshconfig
Host target.local
  ForwardAgent yes
```

This is the only thing you actually need to do.

## Shell config (op.zsh)

The 1Password shell integration unconditionally exports `SSH_AUTH_SOCK`, which
overwrites the forwarded socket in interactive sessions. The fix is to skip the
export if a valid socket is already set:

```zsh
# Enable 1Password SSH Agent, but only if there isn't already a forwarded agent
if [[ -z "$SSH_AUTH_SOCK" || ! -S "$SSH_AUTH_SOCK" ]]; then
  export SSH_AUTH_SOCK=~/.1password/agent.sock
fi
```

`-S` checks that the path is an actual socket file, not just a leftover variable
pointing at nothing.

This is already configured in `config/zsh/op.zsh` - so you don't have to do anything.

## Why not IdentitiesOnly

Adding `IdentitiesOnly yes` to the `github.com` block looks reasonable but breaks
things. It tells SSH to only offer keys listed via `IdentityFile` directives — which
means it ignores the agent entirely. Leave it out and SSH will offer everything the
agent holds.

## Testing

From the remote machine, in a fresh interactive shell:

```sh
ssh -T git@github.com
# should print: Hi <username>! You've successfully authenticated...
```

If it hangs, your shell is still overwriting `SSH_AUTH_SOCK`. Check with:

```sh
echo $SSH_AUTH_SOCK
# should be a path under /Users/<user>/.ssh/agent/<something> , not ~/.1password/agent.sock
```
