# Async Docker Context Prompt
function _vbe_docker_async_start() {
    async_start_worker docker_ctx
    async_register_callback docker_ctx _vbe_docker_done
}

function _vbe_docker_fetch() {
    docker context show 2>/dev/null
}

function _vbe_docker_done() {
    local job=$1 return_code=$2 stdout=$3 more=$6
    [[ $job == '[async]' && $return_code -eq 2 ]] && { _vbe_docker_async_start; return }
    ZSH_DOCKER_CONTEXT=$stdout
    [[ $more == 1 ]] || zle reset-prompt
}

function _vbe_docker_precmd() {
    async_flush_jobs docker_ctx
    async_job docker_ctx _vbe_docker_fetch
}

_vbe_docker_async_start
add-zsh-hook precmd _vbe_docker_precmd

