# Prompt
autoload -Uz async
async_init

source ~/.config/zsh/modules/prompt/git_prompt.zsh
source ~/.config/zsh/modules/prompt/kubectl.zsh
source ~/.config/zsh/modules/prompt/docker.zsh
source ~/.config/zsh/modules/prompt/mise.zsh

setopt PROMPT_SUBST
export VIRTUAL_ENV_DISABLE_PROMPT=yes

function virtenv_indicator {
    [[ -z $VIRTUAL_ENV ]] && psvar[1]='' || psvar[1]=${VIRTUAL_ENV##*/}
}
add-zsh-hook precmd virtenv_indicator


PS1="%B%{$fg[magenta]%}%(1V.%B%{$fg[red]%}(%B%{$fg[magenta]%}%1v%B%{$fg[red]%}).)"  # vi-mode
PS1+="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}"


# 🐳 Docker context (green)
PS1+=' %{$fg[green]%}🐳${ZSH_DOCKER_CONTEXT}%{$reset_color%}'
# ☸️ Kubernetes context/namespace (yellow)
PS1+=' %{$fg[yellow]%}☸️${ZSH_KUBECTL_PROMPT}%{$reset_color%}'
# Add this line right after Docker and Kubernetes segments
PS1+=' %{$fg[cyan]%}💼${ZSH_MISE_PROMPT}%{$reset_color%}'


# 🧬 Git info (from vcs_info)
PS1+='${vcs_info_msg_0_}'

# ⏎ New line with $ prompt
PS1+=$'\n'"%F{magenta}$%f "

