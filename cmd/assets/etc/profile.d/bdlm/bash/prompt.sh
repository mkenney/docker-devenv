#!/usr/bin/env bash

#
# Set the bash prompt
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#

# Load color definitions
if [ "1" != "$__BDLM_CLR" ]; then
    source ~/.dotfiles/common/color
fi

export __BDLM_PROMPT_LAST_PWD=$PWD
export __BDLM_PROMPT_IN_GIT_REPO=$(git rev-parse --is-inside-work-tree 2> /dev/null)

kp() {
    if [ "enabled" = "$__BDLM_PROMPT_K8S_STATUS_LINE" ]; then
        eval "export __BDLM_PROMPT_K8S_STATUS_LINE="
    else
        eval "export __BDLM_PROMPT_K8S_STATUS_LINE=enabled"
    fi
}
#if [ "" != "$(which kubectl)" ]; then
#    export __BDLM_PROMPT_K8S_STATUS_LINE=enabled
#fi

__prompt_command() {
    # always first to capture the last shell error
    local last_status=$?

    local -a ps1_lines

    # detect ssh sessions
    ssh=
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        ssh=1
    else
        case $(ps -o comm= -p $PPID) in sshd|*/sshd)
            ssh=1;;
        esac
    fi
    sshprompt=
    if [ "1" == "$ssh" ]; then
        sshprompt=' \[${__BDLM_CLR_FG_36}\](ssh)\[${__BDLM_CLR_RST_ALL}\]'
    fi

    # username display
    userprompt=
    if [ "$EUID" = "0" ]; then
        # Root
        userprompt="${__BDLM_CLR_FG_124}${__BDLM_CLR_STL_BLINK}\](\u@\H)\[\e[0m\]\[${__BDLM_CLR_RST_ALL}\]"
    elif [ "true" = "$__IS_DEVENV" ]; then
        userprompt="${__BDLM_CLR_FG_88}(\u@${__DEVENV})\[${__BDLM_CLR_RST_ALL}\]"
    else
        userprompt="${__BDLM_CLR_FG_185}\](\u@\H)\[${__BDLM_CLR_RST_ALL}\]"
    fi

    # pwd display
    pwdprompt="\[${__BDLM_CLR_RST_ALL_FADED}\]$PWD\[${__BDLM_CLR_RST_ALL}\]"

    # k8s status line
    k8sprompt=
    if [ "enabled" = "$__BDLM_PROMPT_K8S_STATUS_LINE" ]; then
        k8sprompt="\[${__BDLM_CLR_FG_36}\]$(__k8s_ps1)\[${__BDLM_CLR_RST_ALL}\] "
    fi

    # git status line
    gitprompt=
    if [ "$__BDLM_PROMPT_LAST_PWD" != "$PWD" ]; then
        export __BDLM_PROMPT_IN_GIT_REPO=$(git rev-parse --is-inside-work-tree 2> /dev/null)
    fi
    if [ "true" = "$__BDLM_PROMPT_IN_GIT_REPO" ]; then # In a git repo
        gitprompt="\[${__BDLM_CLR_FG_75}\]$(__git_status)\[${__BDLM_CLR_RST_ALL}\]"
    fi

    # error state
    cursorprompt=" → "
    if  [ "0" != "$last_status" ] && [ "" != "$last_status" ]; then
        cursorprompt=" (\[${__BDLM_CLR_FG_124}\]$last_status\[${__BDLM_CLR_RST_ALL}\]) ⤳ "
    fi

    # Line 1 - host info, current path
    ps1_lines+="\n┌ ${userprompt}${sshprompt} \[${__BDLM_CLR_FG_115}\]\t\[${__BDLM_CLR_RST_ALL}\] - ${__BDLM_CLR_FG_250}${pwdprompt}${__BDLM_CLR_RST_ALL}"

    # Line 2 - k8s / git status, error state
    ps1_lines+="\n└ "
    if [ "" != "$k8sprompt" ] || [ "" != "$gitprompt" ]; then
        ps1_lines+="${k8sprompt}${gitprompt}"
    fi
    ps1_lines+="${cursorprompt}"

    # Make the cursor a blinking vertical line
    # http://stackoverflow.com/questions/4416909/anyway-change-the-cursor-vertical-line-instead-of-a-box
    ps1_lines+=$(echo -e -n "\[\x1b[\x35 q\]")

    export __BDLM_PROMPT_LAST_PWD=$PWD
    PS1="${ps1_lines[*]}"
}
export PROMPT_COMMAND=__prompt_command

export PS2='\[${__BDLM_CLR_RST_ALL_BOLD}\]\>\[${__BDLM_CLR_RST_ALL}\] '
