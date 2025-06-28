#!/bin/bash

# go packages
go install github.com/Zxilly/go-size-analyzer/cmd/gsa@latest Γöé
go install github.com/vektra/mockery/v3@v3.3.2 Γöé
go install github.com/xo/usql@latest Γöé
go install -tags most github.com/xo/usql@master Γöé
go install github.com/derailed/k9s@latest Γöé
go install github.com/jesseduffield/lazydocker@latest Γöé

# Install tailwindcss
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
mv tailwindcss-linux-x64 ~/.local/bin/tailwindcss

# install git-filter-repo
pip install --user pipx
pipx install git-filter-repo
