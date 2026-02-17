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
alias tmx-name='(){ tmux rename-window "$1" && tmux set-option -w allow-rename off && tmux set-option -w automatic-rename off; }'
alias cld='ENABLE_TOOL_SEARCH=false claude --dangerously-skip-permissions'
