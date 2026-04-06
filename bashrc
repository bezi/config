# Some shared bash configs that I want to use across all my machines
#
# For any relevant bashrc, add:
# if [ -f "$HOME/.config/bashrc" ]; then
#     source "$HOME/.config/bashrc";
# fi

alias vim="nvim"
export EDITOR=nvim
alias glog='git log --pretty=oneline --graph --decorate --abbrev-commit --branches --tags';
alias gittree='git ls-files | tree --fromfile -C -a'
export ESLINT_USE_FLAT_CONFIG=true
export PYTHONPYCACHEPREFIX=/tmp/pycaches
export GIT_EXTERNAL_DIFF=difft
export HOMEBREW_NO_ENV_HINTS=1
alias tmx='tmux attach -t bezi || tmux new -s bezi'
alias tmx-name='(){
  local name="$1"
  if [[ "$PWD" == */Nucleus[2-9]/* || "$PWD" == */Nucleus[2-9] ]]; then
    local n="${PWD##*Nucleus}"; n="${n%%/*}"
    name="${n}-${name}"
  elif [[ "$PWD" == */Nucleus/* || "$PWD" == */Nucleus ]]; then
    name="1-${name}"
  fi
  tmux rename-window "$name" && tmux set-option -w allow-rename off && tmux set-option -w automatic-rename off
}'
alias cld='ENABLE_TOOL_SEARCH=false claude --dangerously-skip-permissions'
alias lfg='(){gg && tmx-name "$1" && cld}'
alias gitclean='git branch --merged origin/main | grep -vE "^\s*(\*|main)" | xargs -n 1 git branch -d';

# ~/.config git repo health check (pull debounced daily, warnings every shell)
() {
  local repo="$HOME/.config"
  local stamp="$repo/.git/last-pull-stamp"
  local now=$(date +%s)
  local one_day=86400

  # Debounced pull: once per day
  if [[ ! -f "$stamp" ]] || (( now - $(cat "$stamp") > one_day )); then
    echo "$now" > "$stamp"
    git -C "$repo" pull --ff-only --quiet 2>/dev/null
  fi

  # Always warn if dirty or needs pushing
  local gs
  gs=$(git -C "$repo" status --porcelain 2>/dev/null)
  [[ -n "$gs" ]] && echo "\e[33m~/.config has uncommitted changes\e[0m"

  local ahead
  ahead=$(git -C "$repo" rev-list --count @{u}..HEAD 2>/dev/null)
  [[ -n "$ahead" && "$ahead" -gt 0 ]] && echo "\e[33m~/.config has $ahead unpushed commit(s)\e[0m"
}

# Checkout and pull the default branch (aborts if working tree is dirty)
gg() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "gg: working tree is dirty, please commit or stash first" >&2
    return 1
  fi
  local default_branch
  default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')
  if [[ -z "$default_branch" ]]; then
    echo "gg: could not determine default branch" >&2
    return 1
  fi
  git checkout "$default_branch" && git pull && clear
}
