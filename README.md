# SOURCE REPOSITORY

* [mkenney/docker-devenv](https://github.com/mkenney/docker-devenv)

The devenv script is available in the bin/ folder and an auto-completion
script is available in the bash/ folder

# NAME
    devenv -- Manage mkenney/devenv docker work environment containers

# SYNOPSYS
    devenv [-t TARGET] [-p PATH] [command]

# DESCRIPTION
    The devenv utility is used to manage mkenney/devenv docker containers
    to create a consistent bash-based shell environment.

# OPTIONS
    Command modifiers. Most commands take their own arguments. The `init` command
    however requires any path or target name specifications be pased using the
    options below

        -h, -?
            Show the command usage screen

        --help, help
            Show this extended help screen

        -p PATH, --path=PATH
            Specify the project path, this directory is mounted into
            /src inside the environment. If omitted, the project path is
            set to the current directory.

        -t TARGET, --target=TARGET
            Specify an environment name. If omitted, the environment
            name is set to the basename of the project path.

# COMMANDS
    Available commands devenv can execute

        attach [TARGET]
            Attach to a running environment specified by the optional [TARGET]
            argument. If omitted, TARGET value defaults to the basename of the
            project path or the name of the current directory if none is specified.
            This is the default command.

            `devenv attach [TARGET]`
            `devenv -t TARGET attach`
            `devenv -p PATH attach`

        init [TARGET] [PATH]
            Create and start a new environment, optionally naming it and specifying
            the project path. The PATH defaults to the current directory and the
            TARGET defaults to the basename of the project path.

            `devenv create [TARGET] [PATH]`
            `devenv -p PATH create [TARGET]`
            `devenv -t TARGET create [PATH]`
            `devenv -t TARGET -p PATH create`

        kill
            Stop a running environment and clean up

            `devenv kill TARGET`
            `devenv -t TARGET kill`
            `devenv -p PATH kill`

        ls [pattern]
            List currently running environments

        refresh TARGET, reload TARGET, restart TARGET
            Kill and re-create the specified running environment

            `devenv restart TARGET`
            `devenv -t TARGET restart`
            `devenv -p PATH restart`

        rename TARGET NEW_NAME
            Rename a running or stopped environment

            `devenv rename TARGET NEW_NAME`
            `devenv -t TARGET rename NEW_NAME`

        self-update
            Update to the latest mkenney/devenv docker image

        start TARGET
            Start a suspended environment

            `devenv start my_project`

        stop TARGET
            Suspend a running environment

            `devenv stop my_project`

# TODO
    Improve error handling and messages

# AUTHORS
    Michael Kenney <mkenney@webbedlam.com>

