# ~/.config/zsh/modules/prompt/mise.zsh

ZSH_MISE_PROMPT=""

_vbe_mise_prompt() {
  local wanted=("go" "java")
  local shown=()
  local count_total=0
  local count_shown=0

  while IFS= read -r line; do
    local tool=${line%% *}
    local version=${line#* }
    (( count_total++ ))

    if [[ ${wanted[(Ie)$tool]} -ne 0 ]]; then
      shown+=("${tool}@${version}")
      (( count_shown++ ))
    fi
  done < <(mise current --yes 2>/dev/null)

  local count_extra=$(( count_total - count_shown ))
  (( count_extra > 0 )) && shown+=("+${count_extra} more")

  print "${(j: :)shown}"
}


# Step 2: Define the async callback
_vbe_mise_prompt_done() {
  local job=$1
  local code=$2
  local output=$3
  local more=$6

  if [[ $job == '[async]' && $code -eq 2 ]]; then
    _vbe_mise_async_start
    return
  fi

  [[ -n $output ]] && ZSH_MISE_PROMPT=$output || ZSH_MISE_PROMPT=""
  [[ $more == 1 ]] || zle reset-prompt
}

# Step 3: Hook to run before prompt
_vbe_mise_precmd() {
  async_flush_jobs mise_prompt
  async_job mise_prompt _vbe_mise_prompt
}

# Step 4: Start the async worker
_vbe_mise_async_start() {
  async_start_worker mise_prompt
  async_register_callback mise_prompt _vbe_mise_prompt_done
}

# Step 5: Call it ONCE here (do not repeat async_init)
_vbe_mise_async_start
add-zsh-hook precmd _vbe_mise_precmd

# Step 6: Set a fallback prompt (initial value before async fires)
# ZSH_MISE_PROMPT=$(mise current 2>/dev/null | awk '{print $1 "@" $2}' | paste -sd' ' -)

