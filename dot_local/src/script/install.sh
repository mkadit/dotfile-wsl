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
  unison
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
cargo install --git https://github.com/MordechaiHadad/bob --locked
cargo install atuin
cargo install btop
cargo install fd-find
cargo install fselect
cargo install mprocs
cargo install navi
cargo install ripgrep
cargo install tree-sitter-cli
cargo install zoxide

# Change shell to ZSH
chsh -s "$(which zsh)"

# install other binary

# k3s
curl -sfL https://get.k3s.io | sh -
# k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
