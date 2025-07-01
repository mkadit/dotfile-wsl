#!/bin/bash

# go packages
go install github.com/Zxilly/go-size-analyzer/cmd/gsa@latest
go install github.com/vektra/mockery/v3@v3.3.2
go install -tags most github.com/xo/usql@master
go install github.com/derailed/k9s@latest
go install github.com/jesseduffield/lazydocker@latest

# tailwindcss
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
mv tailwindcss-linux-x64 ~/.local/bin/tailwindcss

# python tools
uv tool install tmuxp
uv tool install git-filter-repo
uv tool install kaskade
uv tool install --python 3.13 posting

# install nodejs tools
# bun install -g tailwindcss @tailwindcss/cli
