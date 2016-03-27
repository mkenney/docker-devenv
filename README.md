# SOURCE REPOSITORY

* [mkenney/docker-devenv](https://github.com/mkenney/docker-devenv)

The devenv script is available in the bin/ folder and an auto-completion
script is available in the bash/ folder

# NAME
     $(basename ${0}) -- Manage ${CONTAINER_IMAGE} docker work environment containers

# SYNOPSYS
     $(basename ${0}) [-t TARGET] [-p PATH] [-c] [command]

# DESCRIPTION
     The $(basename ${0}) utility is used to manage ${CONTAINER_IMAGE} docker containers
     to create a consistent bash-based shell environment.

# OPTIONS
     Command modifiers and alternate data inputs. Most commands take their own
     arguments.

         -h, -?
             Show the command usage screen

         --help, help
             Show this extended help screen

         -s, --sustain
             Used when attaching to an environment. If specified, allow the
             environent to continue running after detaching from the session,
             otherwise the environment container will be paused automatically.
             This is useful executing a long-running script to come back to or
             starting a daemon.

         -p PATH, --path=PATH
             Specify the project path, this directory is mounted into /src
             inside the environment. If omitted, the project path is set to
             the current directory.

         -t TARGET, --target=TARGET
             Specify an environment name. If omitted, the environment name
             is set to the basename of the project path.

# COMMANDS
     Available commands $(basename ${0}) can execute

         attach [TARGET]
             Attach to a running environment specified by the optional [TARGET]
             argument. If omitted, TARGET value defaults to the basename of the
             project path or the name of the current directory if none is
             specified. This is the default command.

             EXAMPLES
                 $(basename ${0}) attach [TARGET]
                 $(basename ${0}) -t TARGET attach
                 $(basename ${0}) -p PATH attach

         init [TARGET] [PATH]
             Create and start a new environment, optionally naming it and specifying
             the project path. The PATH defaults to the current directory and the
             TARGET defaults to the basename of the project path.

             EXAMPLES
                 $(basename ${0}) create [TARGET] [PATH]
                 $(basename ${0}) -p PATH create [TARGET]
                 $(basename ${0}) -t TARGET create [PATH]
                 $(basename ${0}) -t TARGET -p PATH create

         kill
             Stop a running environment and clean up

             EXAMPLES
                 $(basename ${0}) kill TARGET
                 $(basename ${0}) -t TARGET kill
                 $(basename ${0}) -p PATH kill

         ls [pattern]
             List currently running environments, optionally filtering results with
             a glob pattern

             EXAMPLES
                 $(basename ${0}) ls
                 $(basename ${0}) ls java*
                 $(basename ${0}) ls *-php-v5.?

         restart TARGET
             Kill, re-create and attach to the specified running environment

             EXAMPLES
                 $(basename ${0}) restart TARGET
                 $(basename ${0}) -t TARGET restart
                 $(basename ${0}) -p PATH restart

         rename TARGET NEW_NAME
             Rename a running or stopped environment

             EXAMPLES
                 $(basename ${0}) rename TARGET NEW_NAME
                 $(basename ${0}) -t TARGET rename NEW_NAME

         self-update
             Update to the latest ${CONTAINER_IMAGE} docker image

             EXAMPLES
                 $(basename ${0}) self-update

         start TARGET
             Start a suspended environment

             EXAMPLES
                 $(basename ${0}) start TARGET

         stop TARGET
             Suspend a running environment

             EXAMPLES
                 $(basename ${0}) stop TARGET

# TODO
     - Improve error handling and messages
     - Search containers by PATH label to find the
       TARGET value for a PATH

# AUTHORS
     Michael Kenney <mkenney@webbedlam.com>
