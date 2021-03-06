#!/usr/bin/env bash

# `git branch` wrapper
#   - If listing branches, format, highlight and sort the list.
#   - If creating a branch, automatically check it out.
function __ext_git_branch {

    # Colored & formatted list of branches
    if [ "$1" = "" ]; then
        cur_branch=$(command git rev-parse --abbrev-ref HEAD)
        color_end=$'\e[0m'
        while read -r line; do
            if [ ! -z "$line" ]; then
                parts=(${line// / })
                if [ "${parts[3]}" = "${cur_branch}" ]; then
                    color_start=$'\e[1;92m'
                    curr_char='*'
                else
                    color_start=$'\e[0;94m'
                    curr_char=' '
                fi
                echo "${color_start}${curr_char} ${parts[0]} ${parts[1]} ${color_start}${parts[3]}${color_end}"
            fi
        done <<< "$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:iso) %(refname:short)')"
    else

        # use the unaliased git command
        /usr/bin/env git branch "${@:1}"

        # checkout the specified branch, if any
        if [ "$2" = "" ]; then
            /usr/bin/env git checkout "${1}"
        fi
    fi
}
