# SOURCE REPOSITORY

* [mkenney/docker-devenv](https://github.com/mkenney/docker-devenv)

The devenv script is available in the bin/ folder and an auto-completion
script is available in the bash/ folder.

# DOCKER IMAGE

* [mkenney/devenv](https://hub.docker.com/r/mkenney/devenv/)

Based on [php:5 Offical](https://hub.docker.com/_/php/) (debian/jessie).
The default bash environment is based on [mkenney/terminal_config](https://github.com/mkenney/terminal_conf)
and, when using the  `devenv` cli, initializes and attaches to a tmux
session when you connect to the container. My `.tmux.conf` remaps the activation
shortcut to `Ctrl-\` so you can override that with `--tmux=PATH`.

The default user is modified when the container is initialized so it is
the owner of the project directory on the host and belongs to the same
group so new files will be created with the same uid/gid on the host.

By default, `~/.ssh/` and `~/.oracle/` (for [oracle wallet](http://docs.oracle.com/cd/B19306_01/network.102/b14266/cnctslsh.htm#g1033548))
are mounted into the home directory and if a `tnsnames.ora` file exists
on the host at `/oracle/product/latest/network/admin/tnsnames.ora` it will
be copied to the same location inside the container. This should be enough
to automate connecting to oracle (sqlplus is installed in the container).
If the connection fails, make sure the path to the wallet files take a
look at `~/.oracle/network/admin/sqlnet.ora` and make sure the path to the
wallet directory doesn't contain your username from the host machine.
`$HOME/.oracle/network/wallet` will work for both the container and the
host.

## Installed apt-get packages

* curl exuberant-ctags git graphviz htop less libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libbz2-dev libaio1 python python-dev python3 python3-dev rsync rsyslog ruby sudo tcpdump telnet tmux unzip wget vim-nox

## Installed node packages

* nodejs:v5 build-essential npm:v3.8 bower:v1.7 grunt-cli:v1.1 gulp-cli:v1.2 yo:v1.7 generator-webapp

## PHP 5.6 and supporting packages

* oracleinstantclient:v11.2 oci8 composer phpunit phpdocumentor phpcodesniffer phpmd

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

         --tmux, --tmux=PATH
             Specify a tmux configuration file. If PATH is omitted then
             $HOME/.tmux.conf will be assumed. If the --tmux option is omitted
             then the .tmux.conf file from the docker image will be used.

# COMMANDS
     Available commands devenv can execute

         attach [TARGET]
             Attach to a running environment specified by the optional [TARGET]
             argument. If omitted, runing environments are searched to see if
             they are attached to the specified PATH (which defaults to the current
             directory). If none are found then TARGET is set to the basename of
             the PATH value. This is the default command.

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
             a glob pattern. If pattern is '-q' (quiet) only environment names are
             returned.

             EXAMPLES
                 devenv ls
                 devenv ls java*
                 devenv ls *-php-v5.?
                 devenv ls -q

         pause TARGET
             Pause a running environment

             EXAMPLES
                 devenv pause TARGET

         restart TARGET
             Kill and re-create the specified running environment

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

         unpause TARGET
             Start a paused environment

             EXAMPLES
                 devenv unpause TARGET

# TODO
     - Improve error handling and messages

# AUTHORS
     Michael Kenney <mkenney@webbedlam.com>
