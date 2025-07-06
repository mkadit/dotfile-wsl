# zunplugged: https://github.com/mattmc3/zsh_unplugged

# Plugin config
source ~/.config/zsh/modules/package/plugin_config.zsh

# a simple, ultra-fast plugin handler

# clone a plugin, identify its init file, source it, and add it to your fpath
function z-plugin-load() {
  local repo plugin_name plugin_dir initfile initfiles
  ZPLUGINDIR=${ZPLUGINDIR:-$HOME/.config/zsh/plugins}
  for repo in $@; do
    plugin_name=${repo:t}
    plugin_dir=$ZPLUGINDIR/$plugin_name
    initfile=$plugin_dir/$plugin_name.plugin.zsh
    if [[ ! -d $plugin_dir ]]; then
      echo "Cloning $repo"
      git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$repo $plugin_dir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugin_dir/*.plugin.{z,}sh(N) $plugin_dir/*.{z,}sh{-theme,}(N))
      [[ ${#initfiles[@]} -gt 0 ]] || { echo >&2 "Plugin has no init file '$repo'." && continue }
      ln -sf "${initfiles[1]}" "$initfile"
    fi
    fpath+=$plugin_dir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

# if you want to compile your plugins you may see performance gains
function z-plugin-compile() {
  ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  autoload -U zrecompile
  local f
  for f in $ZPLUGINDIR/**/*.zsh{,-theme}(N); do
    zrecompile -pq "$f"
  done
}


function z-plugin-update {
  ZPLUGINDIR=${ZPLUGINDIR:-$HOME/.config/zsh/plugins}
  for d in $ZPLUGINDIR/*/.git(/); do
    echo "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
  done
}

plugins=(
  # Load first
  zsh-users/zsh-autosuggestions
  zdharma-continuum/fast-syntax-highlighting
  # marlonrichert/zsh-autocomplete
  # jeffreytse/zsh-vi-mode
  mafredri/zsh-async # Async for git prompt
  # MichaelAquilina/zsh-auto-notify

  # Load defer to make the next plugins async
  romkatv/zsh-defer

  # Load after wraps
  Aloxaf/fzf-tab
  urbainvaes/fzf-marks
  djui/alias-tips
  # skywind3000/z.lua
)

# Load local functions
source ~/.config/zsh/modules/function/fzf_extend.zsh
source ~/.config/zsh/modules/function/mise.zsh
source ~/.config/zsh/modules/completion/mise.zsh

source ~/.config/zsh/modules/function/bun.zsh
source ~/.config/zsh/modules/completion/bun.zsh

source ~/.config/zsh/modules/completion/uv.zsh
source ~/.config/zsh/modules/completion/navi.zsh
source ~/.config/zsh/modules/completion/zoxide.zsh
source ~/.config/zsh/modules/completion/jc.zsh
source ~/.config/zsh/modules/completion/gopass.zsh
source ~/.config/zsh/modules/completion/kubectl.zsh
source ~/.config/zsh/modules/completion/k3d.zsh
source ~/.config/zsh/modules/completion/tmuxp.zsh
source ~/.config/zsh/modules/completion/yq.zsh

source ~/.config/zsh/modules/function/krew.zsh


source ~/.config/zsh/modules/completion/chezmoi.zsh

z-plugin-load $plugins
