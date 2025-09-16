# Some shared bash configs that I want to use across all my machines
#
# For any relevant bashrc, add:
# if [ -f "$HOME/.config/bashrc" ]; then
#     source "$HOME/.config/bashrc";
# fi

export EDITOR=nvim
alias glog='git log --pretty=oneline --graph --decorate --abbrev-commit --all';
alias gittree='git ls-files | tree --fromfile -C -a'
export ESLINT_USE_FLAT_CONFIG=true
