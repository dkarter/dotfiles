# Github PR edit
ghpre() {
  existing_description="$(gh pr view --json body -q '.body')"
  temp_file="$(mktemp)"
  echo "$existing_description" > "$temp_file"
  nvim "$temp_file" +'set ft=markdown'
  gh pr edit --body "$(cat $temp_file)"
  rm "$temp_file"
}

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
    git branch --all | grep -v HEAD |
      sed "s/.* //" | sed "s#remotes/[^/]*/##" |
      sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
  ) || return
  target=$(
    (
      echo "$branches"
      echo "$tags"
    ) |
      fzf-tmux -p --reverse -l30 -- --no-hscroll --ansi +m -d "\t" -n 2
  ) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# fgcoc - checkout git commit
fgcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --tac +s +m -e) &&
    git checkout $(echo "$commit" | sed "s/ .*//")
}

# fgshow - git commit browser
fgshow() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
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
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
    echo -n $(echo "$commit" | sed "s/ .*//")
}


# Install one or more versions of specified language
# e.g. `vmi rust` # => fzf multimode, tab to mark, enter to install
# if no plugin is supplied (e.g. `vmi<CR>`), fzf will list them for you
# Mnemonic [V]ersion [M]anager [I]nstall
vmi() {
  local lang=${1}

  if [[ ! $lang ]]; then
    lang=$(asdf plugin-list | fzf)
  fi

  if [[ $lang ]]; then
    local versions=$(asdf list-all $lang | fzf -m)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do; asdf install $lang $version; done;
    fi
  fi
}

# fdr - cd to selected parent directory
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
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
  git rev-parse HEAD > /dev/null 2>&1
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
   IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
   printf '%s\n' "${arr[@]}"
}

# Easily jump to man page for a built-in command e.g. bashman fg
bashman() {
  man bash | less -p "^       $1 "
}

# ask for confirmation in scripts
confirm() {
  read -p "Are you sure? " -n 1 -r
  echo    # move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
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
