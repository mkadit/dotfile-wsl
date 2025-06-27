BUN_DIR=$(which bun)

# _install_bun(){
#   # curl -fsSL https://bun.sh/install | bash
#   echo  $(command -v bun)
# }

# [[ ! $(command -v bun) ]] && _install_bun


# bun completions
# [ -s $BUN_DIR ] && source $BUN_DIR

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
