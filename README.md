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

3. Install and configure [Starship](https://starship.rs/):
```sh
curl -sS https://starship.rs/install.sh | sh

# Add the following to the end of ~/.bashrc:
eval "$(starship init bash)"

# Add the following to the end of ~/.zshrc:
eval "$(starship init zsh)"
```

4. Make sure tmux is installed, then install [TPM](https://github.com/tmux-plugins/tpm):
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then, just start tmux and run `prefix + I` to install all the plugins.

5. Install Neovim on your local system, then install [Packer](https://github.com/wbthomason/packer.nvim):
```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
cd ~/.config/nvim/
nvim lua/bezi/packer.lua
```

Once the packer file is loaded, run `:source %` in the window, then `:PackerInstall`.  I then quit and repeat, as the initial install can get a little screwy.

6. Make sure your shell config loads `bashrc` in this repo for aliases.

7. Run git setup:
```sh
git config --global user.name "Oscar Bezi"
git config --global user.email oscar.bezi@gmail.com
git config --global core.editor nvim
git config --global push.autoSetupRemote true
```
