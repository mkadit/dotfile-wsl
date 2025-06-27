# Async Kubernetes Context Prompt
function _vbe_kube_async_start() {
    async_start_worker kube_ctx
    async_register_callback kube_ctx _vbe_kube_done
}

function _vbe_kube_fetch() {
    local ctx ns
    ctx=$(kubectl config current-context 2>/dev/null) || return
    ns=$(kubectl config view --minify --output "jsonpath={..namespace}" 2>/dev/null)
    [[ -z $ns ]] && ns="default"
    print "${ctx}/${ns}"
}

function _vbe_kube_done() {
    local job=$1 return_code=$2 stdout=$3 more=$6
    [[ $job == '[async]' && $return_code -eq 2 ]] && { _vbe_kube_async_start; return }
    ZSH_KUBECTL_PROMPT=$stdout
    [[ $more == 1 ]] || zle reset-prompt
}

function _vbe_kube_precmd() {
    async_flush_jobs kube_ctx
    async_job kube_ctx _vbe_kube_fetch
}

_vbe_kube_async_start
add-zsh-hook precmd _vbe_kube_precmd

