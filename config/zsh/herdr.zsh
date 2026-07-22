if [[ ${HERDR_ENV:-} == 1 && -n ${HERDR_PANE_ID:-} && -z ${HERDR_DISABLE_PANE_TITLES:-} ]]; then
  autoload -Uz add-zsh-hook

  typeset -gA HERDR_PANE_TITLES=(
    claude '󰚩 claude'
    lazydocker ' lazydocker'
    lazygit ' lazygit'
    nvim ' neovim'
    opencode ' opencode'
    tuicr ' tuicr'
  )

  _herdr_update_pane_title() {
    local title=$1
    local -a args=(pane rename "$HERDR_PANE_ID")
    if [[ -n $title ]]; then
      args+=("$title")
    else
      args+=(--clear)
    fi

    (
      "${HERDR_BIN_PATH:-herdr}" "${args[@]}" >/dev/null 2>&1 &
    )
  }

  _herdr_set_mapped_pane_title() {
    [[ -z ${HERDR_DISABLE_PANE_TITLES:-} ]] || return

    local executable=${3%% *}
    executable=${executable##*/}
    local title=${HERDR_PANE_TITLES[$executable]-}
    [[ -n $title ]] || return

    typeset -g HERDR_PANE_TITLE_ACTIVE=1
    _herdr_update_pane_title "$title"
  }

  _herdr_clear_mapped_pane_title() {
    [[ -n ${HERDR_PANE_TITLE_ACTIVE:-} ]] || return

    unset HERDR_PANE_TITLE_ACTIVE
    _herdr_update_pane_title
  }

  add-zsh-hook preexec _herdr_set_mapped_pane_title
  add-zsh-hook precmd _herdr_clear_mapped_pane_title
fi
