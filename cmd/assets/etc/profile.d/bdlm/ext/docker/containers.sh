#!/usr/bin/env bash

# add 'clean' to the current list of custom commands
export _docker_custom_commands="${_docker_custom_commands} containers"

#
# Clean docker containers and images
# http://stackoverflow.com/questions/17236796/how-to-remove-old-docker-containers
#
function __ext_docker_containers {
    if [ "" != "$(docker ps -aq --no-trunc)" ]; then
        for a in $(docker inspect --format='{{.Name}}' $(docker ps -aq --no-trunc)); do
            echo "${a:1:${#a}-1}"
        done
    fi
}
