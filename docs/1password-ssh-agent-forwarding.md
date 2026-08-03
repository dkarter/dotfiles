# 1Password SSH agent forwarding and Git signing

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

## Git commit signing

Git uses `bin/git-ssh-sign` as its SSH signing program. The shared `gitconfig`
contains only the portable settings:

```gitconfig
[gpg "ssh"]
  program = git-ssh-sign
  allowedSignersFile = ~/.ssh/allowed_signers
```

The user-specific `~/.gitconfig.local` comes from 1Password and opts the user
into signing:

```gitconfig
[user]
  name = Your Name
  email = you@example.com
  signingKey = ssh-ed25519 AAAA...

[gpg]
  format = ssh

[commit]
  gpgSign = true
```

Keeping the identity, signing key, and signing opt-in out of the shared config
prevents other dotfiles users from committing with the wrong identity.

### Local sessions

When no forwarded agent keys are available, `git-ssh-sign` uses the 1Password
signer. It discovers `op-ssh-sign` from `PATH`, the macOS application bundle, or
`/opt/1Password/op-ssh-sign` on Linux. Git's configured `user.signingKey` is
passed through unchanged.

The wrapper only considers `~/.ssh/agent.sock` when `SSH_CONNECTION` indicates
that the process is running in an SSH session. A live stable socket left behind
by another concurrent SSH session is ignored on the host, so local commits
continue to use 1Password.

### Remote sessions

`config/zsh/ssh.zsh` maintains `~/.ssh/agent.sock` as a stable link to the
current forwarded socket. The signing wrapper asks that agent for its public
keys with `ssh-add -L`. This supports different keys from clients such as
ShellFish and Termius without storing client-specific public-key filenames in
the dotfiles.

The wrapper follows this policy:

1. Local session: use the local 1Password signer.
2. SSH session without available forwarded keys: fail immediately rather than
   invoking a GUI signer that cannot be approved remotely.
3. Forwarded keys with a valid saved or environment-selected fingerprint: use
   the matching key with `ssh-keygen`.
4. Forwarded keys without a valid selection: fail immediately with
   instructions, even when the agent exposes only one key.

Normal Git signing never opens an interactive selector. This is important for
coding agents and other non-interactive processes: an unconfigured or stale
selection fails the commit instead of guessing or waiting indefinitely for
terminal input.

Git also invokes the configured program when verifying signatures. The wrapper
delegates all non-signing SSH signature modes directly to `ssh-keygen`, leaving
the configured `allowedSignersFile` unchanged.

### Selecting one of multiple keys

Run the selector from an interactive shell on the remote machine:

```sh
git-ssh-sign --select
```

The selector always shows the available keys with `gum`, even when the agent
exposes only one key. After the user confirms a choice, it adds the selected key
to the configured `allowedSignersFile` for the current Git email when needed and
saves the selected public-key fingerprint to:

```text
${XDG_CONFIG_HOME:-$HOME/.config}/git-ssh-sign/fingerprint
```

The saved selection is reused by later interactive and non-interactive commits,
so `gum` is not opened again. If a different SSH client does not expose that
key, signing fails immediately and asks for the selector to be run again.

For a temporary override, set the fingerprint in the environment:

```sh
GIT_SSH_SIGN_KEY_FINGERPRINT='SHA256:...' git commit
```

The environment variable takes precedence over the saved selection. The socket
and selection-file locations can also be overridden with
`GIT_SSH_SIGN_AGENT_SOCK` and `GIT_SSH_SIGN_SELECTION_FILE`. Explicitly setting
`GIT_SSH_SIGN_AGENT_SOCK` also enables forwarded-agent mode without
`SSH_CONNECTION`, which is useful for testing or unusual remote environments.

### Trusting remote signing keys

Key discovery does not automatically trust every forwarded key. Running
`git-ssh-sign --select` explicitly trusts only the chosen key for local Git
verification. The key must still be registered with the Git host:

1. Run `git-ssh-sign --select` in a session forwarded from that client.
2. Register the selected public key as a signing key with the Git host.

The installer adds the 1Password signing key to `allowed_signers`; the selector
adds each explicitly selected forwarded client key.

Verify the result locally with:

```sh
git log --show-signature
```

### Troubleshooting signing

Confirm that the remote session can see forwarded keys:

```sh
SSH_AUTH_SOCK="$HOME/.ssh/agent.sock" ssh-add -L
```

If this prints no keys, the SSH client is not forwarding its agent or the stable
socket link is stale. Some Mosh-based sessions do not preserve SSH agent
forwarding after the initial SSH connection.
