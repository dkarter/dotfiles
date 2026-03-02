# Set github token env vars from github cli - these are used by other CLIs
if command -v gh &>/dev/null && gh auth status &>/dev/null; then
  export GITHUB_TOKEN=$(gh auth token)
  export MISE_GITHUB_TOKEN=$GITHUB_TOKEN
fi
