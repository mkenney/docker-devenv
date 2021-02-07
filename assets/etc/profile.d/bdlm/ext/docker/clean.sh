#!/usr/bin/env bash

# add 'clean' to the current list of custom commands
export _docker_custom_commands="${_docker_custom_commands} clean"

#
# Clean docker containers and images
# http://stackoverflow.com/questions/17236796/how-to-remove-old-docker-containers
#
function __ext_docker_clean {

	EXITED=$(docker ps -a -q -f "status=exited")
	DANGLING=$(docker images -q -f "dangling=true")
	EXECUTE="N"

	if [ "-h" == "${1}" ] || [ "--help" == "${1}" ]; then
		echo "    deprecated, please use \`docker system prune\`"
		echo
		echo "    \`docker clean\`"
		echo "        Remove dangling containers and images interactively"
		echo
		echo "    \`docker clean -f\`"
		echo "        Remove all dangling containers and images without prompting"
		return
	fi


	if [ "" != "${EXITED}" ]; then
		echo "    deprecated, please use \`docker system prune\`"
		echo
		echo -e "The following containers have exited and will be removed:"
		echo
		docker ps -a -f "status=exited"
		if [ "-f" == "${1}" ] || [ "--force" == "${1}" ]; then
			EXECUTE="y"
		else
			echo
			read -p "Do you want to remove the listed containers? [y/N]: " EXECUTE
		fi

		echo
		if [ "y" == "${EXECUTE}" ]; then
			if [ -n "$EXITED" ]; then
				for CONTAINER_ID in `docker ps -a -q -f "status=exited"`; do
					docker rm $CONTAINER_ID > /dev/null
					echo -e "Removed container ${CONTAINER_ID}"
				done
			else
				echo "No containers to remove"
			fi
		else
			echo "Skipping containers"
		fi
	fi

	if [ "" != "${DANGLING}" ]; then
		echo "    deprecated, please use \`docker system prune\`"
		echo
		echo -e "The following images are dangling and will be removed:"
		echo
		docker images -f "dangling=true"
		if [ "-f" == "${1}" ] || [ "--force" == "${1}" ]; then
			EXECUTE="y"
		else
			echo
			read -p "Do you want to remove the listed images? [y/N]: " EXECUTE
		fi

		echo
		if [ "y" == "${EXECUTE}" ]; then
			if [ -n "$DANGLING" ]; then
				for IMAGE_ID in `docker images -q -f "dangling=true"`; do
					docker rmi $IMAGE_ID > /dev/null
					echo -e "Removed image ${IMAGE_ID}"
				done
			else
				echo "No images to remove"
			fi
		else
			echo "Skipping images"
		fi
	fi

	if [ "" == "${EXITED}" ] && [ "" == "${DANGLING}" ]; then
		echo
		echo -e "Nothing to clean"
	fi
}
