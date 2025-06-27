# Incorporate git information into prompt

[[ $USERNAME != "root" ]] && [[ $ZSH_NAME != "zsh-static" ]] && {

    # Async helpers
    _vbe_vcs_async_start() {
        async_start_worker vcs_info
        async_register_callback vcs_info _vbe_vcs_info_done
    }
    _vbe_vcs_info() {
        cd -q $1
        vcs_info
        print ${vcs_info_msg_0_}
    }
    _vbe_vcs_info_done() {
        local job=$1
        local return_code=$2
        local stdout=$3
        local more=$6
        if [[ $job == '[async]' ]]; then
            if [[ $return_code -eq 2 ]]; then
                # Need to restart the worker. Stolen from
                # https://github.com/mengelbrecht/slimline/blob/master/lib/async.zsh
                _vbe_vcs_async_start
                return
            fi
        fi
        vcs_info_msg_0_=$stdout
        [[ $more == 1 ]] || zle reset-prompt
    }
    _vbe_vcs_chpwd() {
        vcs_info_msg_0_=
    }
    _vbe_vcs_precmd() {
        async_flush_jobs vcs_info
        async_job vcs_info _vbe_vcs_info $PWD
    }

    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    () {
        # local formats="${PRCH[branch]} %b%c%u"
        local formats=" %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%} %{$fg[magenta]%}%b%{$fg[blue]%})"
        zstyle    ':vcs_info:*:*' formats           $formats
        zstyle    ':vcs_info:*:*' check-for-changes true

        zstyle ':vcs_info:git*+set-message:*' hooks git-st git-untracked git-remotebranch

        +vi-git-untracked () {
            if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
                git status --porcelain | grep '??' &> /dev/null ; then
                # This will show the marker if there are any untracked files in repo.
                # If instead you want to show the marker only if there are untracked
                # files in $PWD, use:
                #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
                hook_com[staged]+='T'
            fi
        }
        +vi-git-st() {
            local ahead behind
            local -a gitstatus

            # Exit early in case the worktree is on a detached HEAD
            git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

            local -a ahead_and_behind=(
                $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
            )

            ahead=${ahead_and_behind[1]}
            behind=${ahead_and_behind[2]}

            (( $ahead )) && gitstatus+=( "+${ahead}" )
            (( $behind )) && gitstatus+=( "-${behind}" )

            hook_com[misc]+=${(j:/:)gitstatus}
        }
         +vi-git-remotebranch() {
            local remote

            # Are we on a remote-tracking branch?
            remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
                --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

            # The first test will show a tracking branch whenever there is one. The
            # second test, however, will only show the remote branch's name if it
            # differs from the local one.
            if [[ -n ${remote} ]] ; then
            #if [[ -n ${remote} && ${remote#*/} != ${hook_com[branch]} ]] ; then
                hook_com[branch]="${hook_com[branch]} [${remote}]"
            fi
        }

    }

    # Asynchronous VCS status
    # source $HOME/github/zsh-async/async.zsh
    async_init
    _vbe_vcs_async_start
    add-zsh-hook precmd _vbe_vcs_precmd
    add-zsh-hook chpwd _vbe_vcs_chpwd

    # Add VCS information to the prompt
    _vbe_add_prompt_vcs () {
	_vbe_prompt_segment cyan default ${vcs_info_msg_0_}
    }
}

