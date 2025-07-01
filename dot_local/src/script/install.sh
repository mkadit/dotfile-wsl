#!/bin/bash

set -euo pipefail

packages=(
  bat
  build-essential
  fzf
  inetutils-telnet
  jc
  jq
  liblua5.1-0-dev
  lnav
  make
  tmux
  tree
  unzip
  vifm
  zsh
  postgresql-client
  mysql-client
  sqlite3
)

sudo apt update

for pkg in "${packages[@]}"; do
  if ! dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "Installing $pkg..."
    sudo apt install -y "$pkg"
  else
    echo "$pkg is already installed."
  fi
done

# Install Mise
curl https://mise.run | sh

# Install Rust
cargo install ripgrep
cargo install bob-nvim
cargo install fd
cargo install btop
cargo install tree-sitter
cargo install navi
cargo install zoxide
cargo install mprocs
cargo install fselect

# Install Neovim
bob use stable

# Change shell to ZSH
chsh -s "$(which zsh)"

# install other binary
