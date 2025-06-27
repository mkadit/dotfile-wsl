export PATH=$HOME/.fnm:$PATH

_install_fnm() {
    FNM_INSTALL_URL="https://fnm.vercel.app/install"

    FNM_INSTALL_SCRIPT=$(curl -fsSL $FNM_INSTALL_URL 2>/dev/null) \
    || FNM_INSTALL_SCRIPT=$(wget -qO- $FNM_INSTALL_URL 2>/dev/null) \
    || {echo "curl or wget required to install fnm"; return 1}

    bash -s -- --skip-shell <<< $FNM_INSTALL_SCRIPT || return 1
    return 0
}

if ! command -v fnm &>/dev/null; then
    _install_fnm
fi

# load pyenv if it is installed
if command -v fnm &>/dev/null; then
    eval "$(fnm env)"
    fnm completions --shell zsh > $HOME/.zfunc/_fnm
    fpath+=~/.zfunc
fi
