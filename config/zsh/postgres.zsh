# set the path for postgres client utils on mac
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="$BREW_PREFIX/opt/libpq/bin:$PATH"
fi
