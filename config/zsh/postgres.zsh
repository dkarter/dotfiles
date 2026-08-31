# set the path for postgres client utils on mac
if [[ $OSTYPE == darwin* ]]; then
  export PATH="$BREW_PREFIX/opt/libpq/bin:$PATH"
fi

export PSPG_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/pspg/pspgconf"
