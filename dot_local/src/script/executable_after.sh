#!/bin/bash

# # install mise packages
# mise install
#
# # Install Neovim
# bob use stable

# go packages
# go install github.com/Zxilly/go-size-analyzer/cmd/gsa@latest
go install github.com/derailed/k9s@latest
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
go install github.com/spf13/cobra-cli@latest

# # tailwindcss
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
mv tailwindcss-linux-x64 ~/.local/bin/tailwindcss
#
# # python tools
uv tool install tmuxp
uv tool install git-filter-repo
uv tool install kaskade
uv tool install --python 3.13 posting

# install nodejs tools
bun install -g tailwindcss @tailwindcss/cli
