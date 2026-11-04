#!/usr/bin/env bash
# Bootstrap ~/.config on a new machine: wire shell rc files to this repo,
# install tmux plugin manager, point ssh at the shared config, set git
# identity. Idempotent — safe to re-run anytime.
set -eu

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

ensure_line() {
  local line=$1 file=$2
  mkdir -p "$(dirname "$file")"
  [ -e "$file" ] || : >"$file"
  grep -qxF -- "$line" "$file" || printf '\n%s\n' "$line" >>"$file"
}

# Symlink a harness's instruction file to the shared AGENTS.md. Replaces a
# plain file or stale link; leaves a correct link alone.
ensure_link() {
  local target=$1 link=$2
  mkdir -p "$(dirname "$link")"
  [ "$(readlink "$link" 2>/dev/null)" = "$target" ] && return
  rm -f "$link"
  ln -s "$target" "$link"
}

# Shell rc files: source the shared bashrc and init starship.
ensure_line '[ -f "$HOME/.config/bashrc" ] && source "$HOME/.config/bashrc"' "$HOME/.bashrc"
ensure_line 'eval "$(starship init bash)"'                                   "$HOME/.bashrc"
ensure_line '[ -f "$HOME/.config/bashrc" ] && source "$HOME/.config/bashrc"' "$HOME/.zshrc"
ensure_line 'eval "$(starship init zsh)"'                                    "$HOME/.zshrc"

# SSH includes the shared config (host-specific bits stay in ~/.ssh/config).
# ~/.ssh/sockets/ is required by ssh_config's ControlPath multiplexing.
mkdir -p "$HOME/.ssh" "$HOME/.ssh/sockets" && chmod 700 "$HOME/.ssh" "$HOME/.ssh/sockets"
ensure_line "Include $CONFIG/ssh_config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"

# tmux plugin manager and the plugins it manages.
TPM="$HOME/.tmux/plugins/tpm"
if [ ! -e "$TPM" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM"
elif [ ! -d "$TPM/.git" ]; then
  echo "bootstrap: warn: $TPM exists but isn't a git checkout, skipping" >&2
fi
if command -v tmux >/dev/null 2>&1 && [ -x "$TPM/bin/install_plugins" ]; then
  "$TPM/bin/install_plugins" >/dev/null || \
    echo "bootstrap: warn: tmux plugin install failed; run <prefix>+I after starting tmux" >&2
else
  echo "bootstrap: tmux not on PATH, skipping plugin install — run <prefix>+I after starting tmux" >&2
fi

# Agent instructions: one shared AGENTS.md, symlinked to each harness's
# expected path so pi, Claude Code, and others all read the same file.
ensure_link "$CONFIG/AGENTS.md" "$HOME/.claude/CLAUDE.md"
ensure_link "$CONFIG/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"

# Git identity. Set only if unset so per-repo / per-machine overrides win.
git config --global --get user.name           >/dev/null || git config --global user.name           "Oscar Bezi"
git config --global --get user.email          >/dev/null || git config --global user.email          "oscar.bezi@gmail.com"
git config --global --get core.editor         >/dev/null || git config --global core.editor         nvim
git config --global --get push.autoSetupRemote >/dev/null || git config --global push.autoSetupRemote true

echo "bootstrap: done."
