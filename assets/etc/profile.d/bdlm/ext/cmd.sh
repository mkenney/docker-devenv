#!/usr/bin/env bash

# extend any tool with additional commands
export __BDLM_EXT_DIR=${HOME}/.bdlm/ext

# command wrapper
#   Executes any custom commands found in the $__BDLM_EXT_DIR directory.
__bdlm_ext_cmd() {
    arg=1
    cmd="__bdlm_ext"
    found=0
    shift_to=1
    tst=$cmd

    # search for matching exported function
    for part in "${@}"; do
        ((arg=arg+1))
        tst="${tst}_${part}"
        if [ "function" = "$(type -t "${tst}")" ] && [ "${#cmd}" -lt "${#tst}" ]; then
            shift_to=$arg
            cmd=$tst
            found=1
        fi
    done

    # execute matching function, else execute the default command
    if [ "1" = "$found" ]; then
        echo "executing extension '$(echo $cmd ${@:$shift_to})'"
        $(echo $cmd ${@:$shift_to})
    else
        /usr/bin/env $1 "${@:2}"
    fi
}
export -f __bdlm_ext_cmd

# load all of the custom commands in $__BDLM_EXT_DIR
__bdlm_ext_load() {
    for ext in $(find $__BDLM_EXT_DIR -maxdepth 1 -type d -and -not -name '.*'); do
        if [ "$ext" != "$__BDLM_EXT_DIR" ]; then
            # alias the command to the __bdlm_ext_cmd wrapper method
            alias $(basename $ext)="__didyoumean __bdlm_ext_cmd $(basename $ext)"
            for cmd in $(find $ext -maxdepth 1 -type f); do
                # source files and export custom functions
                # function names must match '__ext_[command]_[custom command or override]'
                source $ext/$(basename $cmd)
                if [ "function" = "$(type -t "__ext_$(basename $ext)_$(basename $cmd)")" ]; then
                    export -f "__ext_$(basename $ext)_$(basename $cmd)"
                fi
            done
        fi
    done
}
export -f __bdlm_ext_load

__bdlm_ext_load
