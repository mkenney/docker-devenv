#!/usr/bin/env bash

# add 'ls' to the current list of custom commands
export __git_commands="${__git_commands} ls"

#
# List all files tracked by git
#
function __ext_git_ls {
    git ls-tree -r --name-only HEAD | while read filename; do
        echo "$(git log -1 --format="%at | %h | %an | %ad |" -- $filename) $filename"
    done
}
