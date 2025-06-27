# Dev environment in WSL

Due to work I use windows, and WSL primarily.
This is considered to be the latest dev env

## Components

- Shell: ZSH
- Multiplexer: Tmux
- Editor: NVIM
- File Manager: VIFM
- Package Controller: Mise
- Secret Mangement: SOPS (with Age for Encryption)

## Install

```bash
sudo apt install -y curl
sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init --apply mkadit/dotfile-wsl
```
