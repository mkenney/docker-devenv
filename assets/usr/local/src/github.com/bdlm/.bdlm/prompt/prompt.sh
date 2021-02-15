#!/usr/bin/env bash
# Set the bash prompt
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt

# Load color definitions
if [ "1" != "$__BDLM_CLR" ]; then
    source ~/.bdlm/color/color.sh
fi

# state tracking
export __BDLM_PROMPT_LAST_EUID=$EUID
export __BDLM_PROMPT_LAST_PWD=$PWD
export __BDLM_PROMPT_IN_GIT_REPO=$(git rev-parse --is-inside-work-tree 2> /dev/null)

# cache
export __BDLM_PROMPT_PWD="\[${__BDLM_CLR_RST_ALL_FADED}\]$PWD\[${__BDLM_CLR_RST_ALL}\]"
if [ "$EUID" = "0" ]; then # Root
    export __BDLM_PROMPT_USER="${__BDLM_CLR_FG_124}${__BDLM_CLR_STL_BLINK}\](\u@\H)\[\e[0m\]\[${__BDLM_CLR_RST_ALL}\]"
elif [ "true" = "$__IS_DEVENV" ]; then # bdlm/dev
    export __BDLM_PROMPT_USER="${__BDLM_CLR_FG_88}Project: \H\[${__BDLM_CLR_RST_ALL}\]"
else # standard user
    export __BDLM_PROMPT_USER="${__BDLM_CLR_FG_185}\](\u@\H)\[${__BDLM_CLR_RST_ALL}\]"
fi
export __BDLM_PROMPT_TOOLS=
export __BDLM_PROMPT_SSHSTATE=

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
    local last_status=$? # always first to capture the last shell error
    local -a ps1_lines

    # detect directory changes
    if [ "$__BDLM_PROMPT_LAST_PWD" != "$PWD" ]; then
        export __BDLM_PROMPT_IN_GIT_REPO=$(git rev-parse --is-inside-work-tree 2> /dev/null)
        export __BDLM_PROMPT_PWD="\[${__BDLM_CLR_RST_ALL_FADED}\]$PWD\[${__BDLM_CLR_RST_ALL}\]"
    fi

    # detect user changes
    if [ "$__BDLM_PROMPT_LAST_EUID" != "$EUID" ]; then
        export __BDLM_PROMPT_LAST_EUID=$EUID
        if [ "$EUID" = "0" ]; then
            # Root
            export __BDLM_PROMPT_USER="${__BDLM_CLR_FG_124}${__BDLM_CLR_STL_BLINK}\](\u@\H)\[\e[0m\]\[${__BDLM_CLR_RST_ALL}\]"
        elif [ "true" = "$__IS_DEVENV" ]; then
            export __BDLM_PROMPT_USER="${__BDLM_CLR_FG_88}Project: \H\[${__BDLM_CLR_RST_ALL}\]"
        else
            export __BDLM_PROMPT_USER="${__BDLM_CLR_FG_185}\](\u@\H)\[${__BDLM_CLR_RST_ALL}\]"
        fi
    fi

    # detect ssh sessions
    __BDLM_PROMPT_SSHSTATE=0
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        __BDLM_PROMPT_SSHSTATE=1
    else
        case $(ps -o comm= -p $PPID) in sshd|*/sshd)
            __BDLM_PROMPT_SSHSTATE=1;;
        esac
    fi
    export __BDLM_PROMPT_SSHSTATE

    # tools state prompt
    gitprompt=
    k8sprompt=
    if [ "true" = "$__BDLM_PROMPT_IN_GIT_REPO" ] || [ "enabled" = "$__BDLM_PROMPT_K8S_STATUS_LINE" ]; then
        if [ "enabled" = "$__BDLM_PROMPT_K8S_STATUS_LINE" ]; then
            k8sprompt="\[${__BDLM_CLR_FG_36}\]$(__k8s_ps1)\[${__BDLM_CLR_RST_ALL}\] "
        fi

        # git status line
        if [ "true" = "$__BDLM_PROMPT_IN_GIT_REPO" ]; then # In a git repo
            gitprompt="\[${__BDLM_CLR_FG_75}\]$(__git_status)\[${__BDLM_CLR_RST_ALL}\]"
        fi
    fi
    export __BDLM_PROMPT_TOOLS=" ${k8sprompt}${gitprompt}"

    # SSH state prompt
    __BDLM_PROMPT_SSH=
    if [ "1" == "$__BDLM_PROMPT_SSHSTATE" ]; then
        __BDLM_PROMPT_SSH=' \[${__BDLM_CLR_FG_36}\](ssh)\[${__BDLM_CLR_RST_ALL}\]'
    fi
    export __BDLM_PROMPT_SSH

    # error state
    cursorprompt="→ "
    errorstate=
    if  [ "0" != "$last_status" ] && [ "" != "$last_status" ]; then
        cursorprompt="⤳ "
        errorstate="(\[${__BDLM_CLR_FG_124}\]$last_status\[${__BDLM_CLR_RST_ALL}\]) "
    fi

    # 3-line status prompt
    ps1_lines+="\n┌ ${__BDLM_PROMPT_USER}${__BDLM_PROMPT_SSH}${__BDLM_PROMPT_TOOLS}"
    ps1_lines+="\n│ \[${__BDLM_CLR_FG_115}\]\t\[${__BDLM_CLR_RST_ALL}\] - ${__BDLM_CLR_FG_250}${__BDLM_PROMPT_PWD}${__BDLM_CLR_RST_ALL}"
    ps1_lines+="\n└ ${errorstate}${cursorprompt}"

    # Make the cursor a blinking vertical line
    # http://stackoverflow.com/questions/4416909/anyway-change-the-cursor-vertical-line-instead-of-a-box
    ps1_lines+=$(echo -e -n "\[\x1b[\x35 q\]")

    export __BDLM_PROMPT_LAST_PWD=$PWD
    PS1="${ps1_lines[*]}"
}
export PROMPT_COMMAND=__prompt_command

export PS2='\[${__BDLM_CLR_RST_ALL_BOLD}\]\>\[${__BDLM_CLR_RST_ALL}\] '
