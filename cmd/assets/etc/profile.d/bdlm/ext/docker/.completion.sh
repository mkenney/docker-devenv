#!/usr/bin/env bash

# Docker-compose built-in commands from https://docs.docker.com/v1.6/compose/cli/
export _dc_commands="build bundle config create down events exec help images kill logs pause port ps pull push restart rm run scale start stop top unpause up --force-recreate"

# Docker built-in commands from `docker help`
export _docker_commands="checkpoint config container image network node plugin secret service stack swarm system trust volume attach build commit cp create deploy diff events exec export history images import info inspect kill load login logout logs pause port ps pull push rename restart rm rmi run save search start stats stop tag top unpause update version wait"

# List of custom commands, space delimited.  This var should be
# updated by your resources/lib/[docker-command] files
export _docker_custom_commands=""

#
# Return the list of standard and custom commands as well as current
# container names for tab-completion
#
_docker_autocomplete() {
	local cur prev opts _docker_container_names
	COMPREPLY=()

	_docker_container_names=""
	# Add all current container names to the auto-complete command list
	if [ "" != "$(docker ps -aq --no-trunc)" ]; then
		for a in $(docker inspect --format='{{.Name}}' $(docker ps -aq --no-trunc)); do
			_docker_container_names="$_docker_container_names ${a:1:${#a}-1}"
		done
	fi
	# Add image names
	#if [ "" != "$(docker images -q -f "dangling=false")" ]; then
	#	for a in $(docker images -q -f "dangling=false" --format "{{.Repository}}"); do
	#		_docker_container_names="$_docker_container_names ${a:1:${#a}-1}"
	#	done
	#fi
	#_docker_container_names=$(for a in $(docker inspect --format='{{.Name}}' $(docker ps -aq --no-trunc)); do echo ${a:1:${#a}-1}; done)

	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="${_docker_commands} ${_docker_custom_commands} ${_docker_container_names}"

	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	return 0
}

complete -o default -F _docker_autocomplete docker
complete -o default -F _docker_autocomplete d
complete -o default -W "${_dc_commands}" docker-compose
complete -o default -W "${_dc_commands}" dc
