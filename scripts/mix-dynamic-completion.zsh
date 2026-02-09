#compdef mix

_mix_dynamic() {
  local -a candidates
  local line
  while IFS= read -r line; do
    candidates+=("$line")
  done < <("$HOME/dotfiles/scripts/mix-candidates" "$CURRENT" "${words[@]}")

  if ((${#candidates[@]} > 0)); then
    compadd -Q -a candidates
  else
    _files
  fi
}

compdef _mix_dynamic mix
