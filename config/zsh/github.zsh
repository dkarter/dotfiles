# https://cli.github.com/telemetry
export DO_NOT_TRACK=true
export GH_TELEMETRY=false

# Defer the machine-local opt-in check until gh is first used so shell startup
# stays cheap. Start a new shell after configuring or removing the opt-in.
if command -v ghtkn &>/dev/null; then
  gh() {
    if [[ $(git config --global --includes --bool --get ghtkn.enabled 2>/dev/null) != true ]]; then
      unfunction gh
      command gh "$@"
      return
    fi

    # Cache the enabled path after the first call. An explicit
    # GHTKN_GITHUB_TOKEN remains useful when a GitHub App cannot be installed.
    gh() {
      if [[ -n ${GH_TOKEN:-} || -n ${GITHUB_TOKEN:-} ]]; then
        command gh "$@"
        return
      fi

      command ghtkn exec -e GH_TOKEN -- gh "$@"
    }
    gh "$@"
  }
fi
