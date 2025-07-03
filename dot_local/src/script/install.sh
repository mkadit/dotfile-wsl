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
  make
  mysql-client
  postgresql-client
  rng-tools
  sqlite3
  tldr
  tmux
  tree
  unzip
  vifm
  zsh
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
# mise install

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install ripgrep
cargo install bob-nvim
cargo install fd
cargo install btop
cargo install tree-sitter
cargo install navi
cargo install zoxide
cargo install mprocs
cargo install fselect

# Change shell to ZSH
chsh -s "$(which zsh)"

# install other binary
