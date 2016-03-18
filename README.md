# NAME
    devenv -- Manage mkenney/devenv docker work environment containers

# SYNOPSYS
    devenv [*-h*] [*-t target*] [*-p path*] COMMAND

# DESCRIPTION
    The devenv utility is used to manage mkenney/devenv docker containers
    to create a consistent bash-based shell environment.

# OPTIONS
    Command modifiers. Options are parsed using the \`getops\` utility,
    so all options must come before any command arguments

        -h
            Show this help screen

        -p path
            Specify the project path, this directory is mounted
            into /project inside the environment. If omitted, the
            project path is set to the current directory.

        -t target
            Specify an environment name. If omitted, the environment
            name is set to the basename of the project path.

# COMMANDS
    Available commands $(basename ${0}) can execute

        attach
            Attach to a running environment specified by the -t option.

            \`devenv [-t env_name] attach\`

        create
            Create and start a new environment at the path specified
            by the -p option.

            \`devenv [-t env_name] [-p project_path] create\`

        help
            Show this help screen

        kill
            Stop a running environment and clean up

            \`devenv [-t env_name] kill\`

        ls
            List currently running environments

        refresh / restart"
            Stop, remove and re-create the specified running environment"

            \`devenv [-t env_name] refresh\`"

        rename
            Rename an environment

            \`devenv [-t env_name] rename new_name\`

        self-update
            Update to the latest image

        start
            Start a suspended environment

            \`devenv [-t env_name] start\`

        stop
            Suspend a running environment

            \`devenv [-t env_name] stop\`

# AUTHORS
    Michael Kenney <mkenney@webbedlam.com>
