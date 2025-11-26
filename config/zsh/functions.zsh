# Github PR edit
ghpre() {
  existing_description="$(gh pr view --json body -q '.body')"
  temp_file="$(mktemp)"
  echo "$existing_description" >"$temp_file"
  nvim "$temp_file" +'set ft=markdown'
  gh pr edit --body "$(cat $temp_file)"
  rm "$temp_file"
}

# spellchecker:off
# fo [FUZZY PATTERN] - Open the selected file with the default editor
#   - Exit if there's no match (--exit-0)
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  out=$(fzf-tmux --reverse -p --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
  key=$(head -1 <<<"$out")
  file=$(head -2 <<<"$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || nvim "$file"
  fi
}
# spellchecker:on

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --scheme=history | sed 's/ *[0-9]* *//')
}

# fkill - kill process
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    kill -${1:-9} $pid
  fi
}

# fgco - checkout git branch/tag
fgco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
  ) || return
  branches=$(
    git branch --all | grep -v HEAD \
      | sed "s/.* //" | sed "s#remotes/[^/]*/##" \
      | sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
  ) || return
  target=$(
    (
      echo "$branches"
      echo "$tags"
    ) \
      | fzf-tmux -p --reverse -l30 -- --no-hscroll --ansi +m -d "\t" -n 2
  ) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# fgcoc - checkout git commit
fgcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) \
    && commit=$(echo "$commits" | fzf --tac +s +m -e) \
    && git checkout $(echo "$commit" | sed "s/ .*//")
}

# fgshow - git commit browser
fgshow() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" \
    | fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fgcs - get git commit sha
# example usage: git rebase -i `fcs`
fgcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) \
    && commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) \
    && echo -n $(echo "$commit" | sed "s/ .*//")
}

fman() {
  man -k . | fzf -q "$1" --prompt='man> ' --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

# fdr - cd to selected parent directory
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d ${1} ]]; then dirs+=("$1"); else return; fi
    if [[ ${1} == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}

# cdf - cd into the directory of the selected file
cdf() {
  local file
  local dir
  file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# fgst - pick files from `git status -s`
is_in_git_repo() {
  git rev-parse HEAD >/dev/null 2>&1
}

fgst() {
  # "Nothing to see here, move along"
  is_in_git_repo || return

  local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    printf '%q ' "$item" | cut -d " " -f 2
  done
  echo
}

# shows cheat sheet for a command
cht() {
  curl --silent "https://cht.sh/$1" | bat -p
}

# git functions
clonecd() {
  # find a way to pass the rest of the arguments to
  # git clone in a variadic style to allow still using
  # --depth=1 etc
  git clone git@github.com:"$1.git" && cd "${1#*/}"
}

shallowclone() {
  git clone --depth=1 git@github.com:"$1.git" && cd "${1#*/}"
}

# relative time
in() {
  if [ "$(uname)" == "Darwin" ]; then
    gdate -d"$(gdate) +$1 $2" "+%Y-%m-%d"
  else
    date -d"$(date) +$1 $2" "+%Y-%m-%d"
  fi
}

# split strings
# Usage: split "string" "delimiter"
split() {
  IFS=$'\n' read -d "" -ra arr <<<"${1//$2/$'\n'}"
  printf '%s\n' "${arr[@]}"
}

# Easily jump to man page for a built-in command e.g. bashman fg
bashman() {
  man bash | less -p "^       $1 "
}

# ask for confirmation in scripts
confirm() {
  read -p "Are you sure? " -n 1 -r
  echo # move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
}

# like jq but for html, using css selectors
#
# Dependencies: htmlq, bat
#
# Usage: curl --silent https://www.rust-lang.org/ | hq '#get-help'
hq() {
  htmlq "$1" | bat -l html -p
}

# curls webpage and converts to markdown
#
# Dependencies: html2markdown, neovim
#
# Usage: mdcurl https://example.com
mdcurl() {
  curl "$1" | html2markdown | nvim +'set ft=markdown' +'setlocal buftype=nofile bufhidden=hide noswapfile' -
}

# parse + highlight help for cli tools
# usage: help <command>
# example: help git commit
#
# You can also use the alias h
# example: h git
help() {
  "$@" --help 2>&1 | bat --plain --language=help
}
alias h='help'

# parse + highlight help for cli tools (in neovim)
# usage: vimhelp <command>
# example: vimhelp git
#
# You can also use the alias h
# example: vh git
vimhelp() {
  "$@" --help 2>&1 | nvim +'set ft=man' +'setlocal buftype=nofile bufhidden=hide noswapfile' -
}
alias vh='vimhelp'

# mu - mise use
#
# Installs and saves a tool to the local mise project's mise.toml
#
# Usage:
#
#   mu <tool> [<args>]
#
#   or
#
#   mu # this will use fzf to select a tool from mise registry
mu() {
  if [[ -z $1 ]]; then
    mise use "$(mise registry | awk '{ print $1 }' | fzf --prompt='Select tool to use locally: ' --border=rounded --margin 25%)"
  else
    mise use "$@"
  fi
}

# muu - mise unuse
#
# Removes a tool from the local mise project's mise.toml
#
# Usage:
#  muu <tool> [<args>]
#
#  or
#
#  muu # this will use fzf to select a tool from mise list
muu() {
  if [[ -z $1 ]]; then
    mise unuse "$(mise list --local | awk '{ print $1 }' | fzf --prompt='Select tool to remove: ' --border=rounded --margin 25%)"
  else
    mise unuse "$@"
  fi
}

# mug - mise use --global
#
# Installs and saves a tool to the global mise configuration
#
# Usage:
#
#  mug <tool> [<args>]
#
#  or
#
#  mug # this will use fzf to select a tool from mise registry
mug() {
  if [[ -z $1 ]]; then
    mise use -g "$(mise registry | awk '{ print $1 }' | fzf --prompt='Select tool to use globally: ' --border=rounded --margin 25%)"
  else
    mise use -g "$@"
  fi
}

# muug - mise unuse --global
#
# Removes a tool from the global mise configuration
#
# Usage:
#
#  muug <tool> [<args>]
#
#  or
#
#  muug # this will use fzf to select a tool from mise list
muug() {
  if [[ -z $1 ]]; then
    mise unuse -g "$(mise list --global | awk '{ print $1 }' | fzf --prompt='Select tool to remove globally: ' --border=rounded --margin 25%)"
  else
    mise unuse -g "$@"
  fi
}

# [l]inear [c]reate [i]ssue form in tmux popup (when in tmux)
lci() {
  if [[ -n $TMUX ]]; then
    tmux popup -w 80% -h 80% lnr
  else
    lnr
  fi
}
