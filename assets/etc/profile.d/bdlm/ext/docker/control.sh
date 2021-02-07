#!/usr/bin/env bash

# add 'control' to the current list of custom commands
export _docker_custom_commands="${_docker_custom_commands} control"

#
# Execute `docker exec -ti ${1} ${2}`
#
function __ext_docker_control {
    if [ "" != "$2" ]; then
        docker exec -ti ${1} ${@:2}
    else
        docker exec -ti ${1} bash
    fi

}
