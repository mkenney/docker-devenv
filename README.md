# SOURCE REPOSITORY

* [mkenney/docker-devenv](https://github.com/mkenney/docker-devenv)

The devenv script is available in the bin/ folder and an auto-completion
script is available in the bash/ folder

# NAME
     devenv -- Manage mkenney/devenv docker work environment containers

# SYNOPSYS
     devenv [-t TARGET] [-p PATH] [-c] [command]

# DESCRIPTION
     The devenv utility is used to manage mkenney/devenv docker containers
     to create a consistent bash-based shell environment.

# OPTIONS
     Command modifiers and alternate data inputs. Most commands take their own
     arguments.

         -h, -?
             Show the command usage screen

         --help, help
             Show this extended help screen

         -d, --daemonize
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
     Available commands devenv can execute

         attach [TARGET]
             Attach to a running environment specified by the optional [TARGET]
             argument. If omitted, TARGET value defaults to the basename of the
             project path or the name of the current directory if none is
             specified. This is the default command.

             EXAMPLES
                 devenv attach [TARGET]
                 devenv -t TARGET attach
                 devenv -p PATH attach

         init [TARGET] [PATH]
             Create and start a new environment, optionally naming it and specifying
             the project path. The PATH defaults to the current directory and the
             TARGET defaults to the basename of the project path.

             EXAMPLES
                 devenv create [TARGET] [PATH]
                 devenv -p PATH create [TARGET]
                 devenv -t TARGET create [PATH]
                 devenv -t TARGET -p PATH create

         kill
             Stop a running environment and clean up

             EXAMPLES
                 devenv kill TARGET
                 devenv -t TARGET kill
                 devenv -p PATH kill

         ls [pattern]
             List currently running environments, optionally filtering results with
             a glob pattern

             EXAMPLES
                 devenv ls
                 devenv ls java*
                 devenv ls *-php-v5.?

         restart TARGET
             Kill, re-create and attach to the specified running environment

             EXAMPLES
                 devenv restart TARGET
                 devenv -t TARGET restart
                 devenv -p PATH restart

         rename TARGET NEW_NAME
             Rename a running or stopped environment

             EXAMPLES
                 devenv rename TARGET NEW_NAME
                 devenv -t TARGET rename NEW_NAME

         self-update
             Update to the latest mkenney/devenv docker image

             EXAMPLES
                 devenv self-update

         start TARGET
             Start a suspended environment

             EXAMPLES
                 devenv start TARGET

         stop TARGET
             Suspend a running environment

             EXAMPLES
                 devenv stop TARGET

# TODO
     - Improve error handling and messages
     - Search containers by PATH label to find the
       TARGET value for a PATH

# AUTHORS
     Michael Kenney <mkenney@webbedlam.com>
