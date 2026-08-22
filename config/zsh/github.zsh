# https://cli.github.com/telemetry
export DO_NOT_TRACK=true
export GH_TELEMETRY=false

# Prefer short-lived ghtkn credentials, but respect explicit token overrides.
# GHTKN_GITHUB_TOKEN is consumed by ghtkn itself and is useful when a GitHub
# App cannot be installed, such as on company-owned repositories.
if command -v ghtkn &>/dev/null; then
  gh() {
    if [[ -n ${GH_TOKEN:-} || -n ${GITHUB_TOKEN:-} ]]; then
      command gh "$@"
      return
    fi

    command ghtkn exec -e GH_TOKEN -- gh "$@"
  }
fi
