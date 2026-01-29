# I'm not sure yet I want to activate, because it exposes secrets in env vars,
# which then agents can read. I'm thinking it might be better to use `fnox
# exec` only for commands that need it. This will also reduce 1password prompts
# for every new shell.
# I can potentially use mise aliases to make it easier to use fnox exec.
# eval "$(fnox activate zsh)"
