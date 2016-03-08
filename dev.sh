#!/bin/env sh

if [ "" == "${1}" ]; then
	project_path=$(realpath ".")
else
	project_path=$(realpath "${1}")
fi
project_name=$(basename $project_path)
container_name=dev-${project_name}

running=$(docker inspect --format="{{ .State.Running }}" ${container_name} 2> /dev/null)
if [ $? -eq 1 ]; then
	running=false
fi

ghost=$(docker inspect --format="{{ .State.Ghost }}" ${container_name} 2> /dev/null)
if [ "true" == "${ghost}" ]; then
	docker stop $container_name
	docker kill $container_name
	docker rm   $container_name
	running=false
fi

paused=$(docker inspect --format="{{ .State.Paused }}" ${container_name} 2> /dev/null)
if [ "true" == "${paused}" ]; then
	docker start -ai $container_name
	running=true
fi

other=$(docker ps -aq --filter status="running" | grep ${container_name})
if [ "true" != "${running}" ] && [ "" != "${other}" ]; then
	docker stop $container_name
	docker kill $container_name
	docker rm   $container_name
	running=false
fi

exited=$(docker ps -a -f "status=exited" | grep "${container_name}")
if [ "true" != "${running}" ] && [ "" != "${exited}" ]; then
	docker rm   $container_name
	running=false
fi

if [ "true" != "${running}" ]; then
	echo "Container not running, starting..."
	docker run \
		-itd \
		-h ${project_name} \
		-e HOSTNAME=${project_name} \
		--add-host ${project_name}:127.0.0.1 \
		-e TERM=$TERM \
		-v ${project_path}:/project:rw \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--name ${container_name} \
		mkenney/dev
fi

docker exec -ti $container_name script /dev/null -c 'sh /tmux.sh'
