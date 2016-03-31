# SOURCE REPOSITORY

* [mkenney/docker-devenv](https://github.com/mkenney/docker-devenv)

The devenv script is available in the bin/ folder and an auto-completion
script is available in the bash/ folder.

# DOCKER IMAGE

* [mkenney/devenv](https://hub.docker.com/r/mkenney/devenv/)

Based on [php:5 Offical](https://hub.docker.com/_/php/) (debian:jessie).
The default bash environment is based on [mkenney/terminal_config](https://github.com/mkenney/terminal_conf)
and, when using the  `devenv` cli, initializes and attaches to a tmux
session when you connect to the container. My `.tmux.conf` remaps the
activation shortcut to `Ctrl-\` so you can override that with `--tmux=PATH`.

The default user is modified when the container is initialized so it is
the owner of the project directory on the host and belongs to the same
group so new files will be created with the same uid/gid on the host.

By default, `~/.ssh/` and `~/.oracle/` (for [oracle wallet](http://docs.oracle.com/cd/B19306_01/network.102/b14266/cnctslsh.htm#g1033548))
are mounted into the home directory and if a `tnsnames.ora` file exists
on the host at `/oracle/product/latest/network/admin/tnsnames.ora` it will
be copied to the same location inside the container. This should be enough
to automate connecting to oracle (sqlplus is installed in the container).
If the connection fails, make sure the path to the wallet files is correct.
Take a look at `~/.oracle/network/admin/sqlnet.ora` and make sure the path
doesn't contain your username from the host machine. `(DIRECTORY = $HOME/.oracle/network/wallet)`
will work for both the container and the host.

## Installed apt packages

* curl exuberant-ctags git graphviz htop less libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libbz2-dev libaio1 python python-dev python3 python3-dev rsync rsyslog ruby sudo tcpdump telnet tmux unzip wget vim-nox

## Installed node packages

* nodejs:v5 build-essential npm:v3.8 bower:v1.7 grunt-cli:v1.1 gulp-cli:v1.2 yo:v1.7 generator-webapp

## PHP 5.6 packages

* oci8 composer phpunit phpdocumentor phpcodesniffer phpmd xdebug pcntl

## Oracle packages

* instantclient:v11.2 basic devel sqlplus

# NAME
     devenv -- Manage mkenney/devenv docker work environment containers

# SYNOPSYS
     devenv [-t TARGET] [-p PATH] [-c] [command]

# DESCRIPTION
     The devenv utility is used to manage mkenney/devenv docker containers
     to create a consistent bash-based shell environment. To detach from
     an instance, simply detach from the `tmux` session (`:detach`)

# OPTIONS
     Command modifiers and alternate data inputs. Most commands take their own
     arguments.

         -h, -?
             Show the command usage screen

         --help, help
             Show this extended help screen

         -d, --daemonize
             Used when attaching to an instance. If specified, allow the
             instance to continue running after detaching from the session,
             otherwise the container will be paused automatically.

             This is useful executing a long-running script to come back to
             or starting a daemon. If you forget to daemonize an instance,
             you can start it with the 'unpause' command after you detach.

         -p PATH, --path=PATH
             Specify the project path, this directory is mounted into /src
             inside the container. If omitted, the project path is set to
             the current directory.

         -t TARGET, --target=TARGET
             Specify an instance name. If omitted, current instances will be
             searched to see if any are attached to the project path. If none
             are found, TARGET is set to the basename of the project path.

         --tmux, --tmux=PATH
             Specify a tmux configuration file. If PATH is omitted then
             $HOME/.tmux.conf will be assumed. If the --tmux option is omitted
             then the .tmux.conf file from the docker image will be used.

# COMMANDS
     Available commands devenv can execute. TARGET refers to the name of the
     instance you are managing and PATH refers to the mounted working directory.
     If PATH is omitted, it defaults to the current directory.

     If TARGET is omitted, current instances are searched to see if any are attached
     to the specified PATH, and if so, TARGET is set to the instance name. If not,
     TARGET defaults to the basename of the PATH value.

         attach [TARGET]
             Attach to a current instance specified by the optional [TARGET]
             argument.

             EXAMPLES
                 devenv attach [TARGET]
                 devenv -t TARGET attach
                 devenv -p PATH attach

         init [TARGET] [PATH]
             Create and start a new instance.

             EXAMPLES
                 devenv create [TARGET] [PATH]
                 devenv -p PATH create [TARGET]
                 devenv -t TARGET create [PATH]
                 devenv -t TARGET -p PATH create

         kill [TARGET]
             Stop a running instance and clean up.

             EXAMPLES
                 devenv kill TARGET
                 devenv -t TARGET kill
                 devenv -p PATH kill

         ls [pattern]
             List currently running instances, optionally filtering results with
             a glob pattern. If pattern is '-q' (quiet) only instance names are
             returned.

             EXAMPLES
                 devenv ls
                 devenv ls java*
                 devenv ls *-php-v5.?
                 devenv ls -q

         pause [TARGET]
             Pause a running instance.

             EXAMPLES
                 devenv pause TARGET
                 devenv -t TARGET pause
                 devenv -p PATH pause

         restart [TARGET]
             Kill and re-create the specified running instance.

             EXAMPLES
                 devenv restart TARGET
                 devenv -t TARGET restart
                 devenv -p PATH restart

         rename [TARGET] NEW_NAME
             Rename a running or stopped instance. 'rename' does not accept a PATH
             argument.

             EXAMPLES
                 devenv rename TARGET NEW_NAME
                 devenv -t TARGET rename NEW_NAME

         self-update
             Update to the latest 'mkenney/devenv' docker image and 'devenv' control
             script.

             EXAMPLES
                 devenv self-update

         unpause [TARGET]
             Start a paused instance.

             EXAMPLES
                 devenv unpause TARGET
                 devenv -t TARGET unpause
                 devenv -p PATH unpause

# TODO
     - Improve error handling and messages

# AUTHORS
     Michael Kenney <mkenney@webbedlam.com>
