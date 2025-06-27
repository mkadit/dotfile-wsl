# ~/.zsh or custom script

# Krew install path
export KREW_ROOT="${KREW_ROOT:-$HOME/.krew}"
export PATH="${KREW_ROOT}/bin:$PATH"

# Check if krew is already installed
if ! command -v kubectl-krew >/dev/null 2>&1; then
  echo "🔧 krew not found, installing..."

  (
    set -e
    cd "$(mktemp -d)" || exit 1
    OS="$(uname | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m | sed 's/x86_64/amd64/;s/arm64/arm64/')"
    KREW="krew-${OS}_${ARCH}"
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
    tar zxvf "${KREW}.tar.gz"
    ./"${KREW}" install krew
  )

  echo "✅ krew installed."

  echo "installing plugins"
fi

