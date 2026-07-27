# Agent-patched Nerd Font

`AgentMonoNerdFont/` contains four generated monospaced Nerd Font faces with
coding-agent logos in the Unicode private-use area. The font files are based on
JetBrains Mono but use the distinct `Agent Mono Nerd Font` family name, so they
do not replace or alias an installed JetBrains Mono family. The files are
committed so installation is offline and does not require font build tools.

Run `task fonts:update` to refresh the cache. The updater does nothing until the
checked-in build is at least 30 days old; use `task fonts:update:force` only when
an immediate rebuild is required. Commit all changed font files and
`metadata.json` together.

The base font comes from [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
and retains its embedded license metadata. Agent SVGs come from the
MIT-licensed [Lobe Icons](https://github.com/lobehub/lobe-icons) collection.
Agent names and logos remain trademarks of their respective owners.
