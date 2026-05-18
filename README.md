# config
This repository sets up my `~/.config` directory how I like it.  It keeps it simple, with just NeoVim, Tmux, and Starship as the terminal.

Consider this the next generation of [my dotfiles](https://github.com/bezi/dotfiles/tree/master).

## Getting Started
1. (Optional) Install a NerdFont from [here](https://www.nerdfonts.com/font-downloads).
All of them work, but I prefer Inconsolata.
Not necessary if you're setting up a remote editing setup and your local terminal emulator has been set up already to use a NerdFont.

2. Clone this configuration by first running `ssh-keygen` and uploading your [SSH key](https://github.com/settings/keys) to GitHub.  Then:
```sh
cd ~/.config
git init
git remote add origin git@github.com:bezi/config.git
git fetch origin
git checkout --track origin/master
```

3. Make sure `starship`, `tmux`, `git`, and `nvim` are installed (via `brew`, `nix`, your distro's package manager, etc.), then run the bootstrap script:
```sh
~/.config/bootstrap.sh
```
This is idempotent — it wires `~/.bashrc` and `~/.zshrc` to source this repo's `bashrc` and init Starship, clones [TPM](https://github.com/tmux-plugins/tpm) into `~/.tmux/plugins/tpm`, adds `Include ~/.config/ssh_config` to `~/.ssh/config`, and sets the global git identity. Re-run it any time you change machines or want to re-apply.

On macOS, also add `UseKeychain yes` to `~/.ssh/config` above the include line.

4. Start tmux and press `prefix + I` to install the tmux plugins (default prefix is `ctrl-b`).

5. Open `nvim` once to let [lazy.nvim](https://github.com/folke/lazy.nvim) auto-bootstrap its plugins.
