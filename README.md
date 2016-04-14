# SOURCE REPOSITORY

* [mkenney/docker-devenv](https://github.com/mkenney/docker-devenv)

The `devenv` script is available in the `bin/` folder and an auto-completion script is available in the `bash/` folder.

# Installation

It's really just a bash script, but it uses docker and assumes that you can run `docker` commands without sudo so you might need some setup.

1. Install docker on your system. This command varies from system to system so you're on your own, but there are tons of [instructions online](https://www.google.com/search?q=install+docker&oq=install+docker&aqs=chrome.0.0l2j69i60l3j0.1975j0j1&sourceid=chrome&ie=UTF-8) so it should be easy. For example, if you happen to be using a Debian-based system it's as simple as `sudo apt-get install docker`.
2. Make sure your user [belongs to the docker group](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo).
3. Select an installation directory in your path (lets assume `/usr/bin`) and run `sudo wget -nv -O /usr/bin/devenv https://raw.githubusercontent.com/mkenney/docker-devenv/master/bin/devenv && sudo chmod +rwx /usr/bin/devenv && devenv self-update`.
4. Profit

# ABOUT

This project began as a way for me to easily move my development enviroment around with me, but is quickly turning into my primary IDE.

The goal is to have a fully scripted development environment build that contains all the tools I need to do my daily work (mainly PHP, Javascript, Perl, Bash, Python, etc.) and a control script that allows me to treat container instances as individual projects. Essentially, a fully customized linux instance dedicated to a single software development project.

## Docker image

* [mkenney/devenv](https://hub.docker.com/r/mkenney/devenv/)

Based on [php:5 Offical](https://hub.docker.com/_/php/) (debian:jessie). The default bash environment is based on [mkenney/terminal_config](https://github.com/mkenney/terminal_config) and, when using the `devenv` cli, initializes and attaches to a tmux session when you connect to the container. Because this assumes `vim` will be the primary editor, the default command-prefix key has been remapped to `C-\`. You can specify a secondary prefix key with the `--tmux-prefix` option or use your own `.tmux.conf` file using the `--tmux` option.

The default user is modified when the container is initialized so it becomes the owner of the project directory on the host and belongs to the same group so new files will be created with the same uid/gid on the host.

By default, `~/.ssh/` and `~/.oracle/` (for [oracle wallet](http://docs.oracle.com/cd/B19306_01/network.102/b14266/cnctslsh.htm#g1033548)) are mounted into the home directory and if a `tnsnames.ora` file exists on the host at `/oracle/product/latest/network/admin/tnsnames.ora` it will be copied to the same location inside the container. This should be enough to automate connecting to oracle (sqlplus is installed in the container) but ymmv. If the connection fails, make sure the path to the wallet files is correct. Take a look at `~/.oracle/network/admin/sqlnet.ora` and make sure the path doesn't contain your username from the host machine. `(DIRECTORY = $HOME/.oracle/network/wallet)` should work for both the container and the host in most environments.

### Powerline

Powerline is installed and enabled in the default tmux and vim configurations, you can easily override it with your own configuration files by passing the `--tmux` or `--vimrc` options when starting a new instance with the `init` or `restart` commands.

If you do want to use `powerline`, you may want to install and use a compatible font in your terminal emulator. I use [iTerm 2](https://www.iterm2.com/) with the [Liberation Mono Powerline](https://github.com/powerline/fonts/tree/master/LiberationMono) font. If you're using iTerm, you should also uncheck the "Treat ambiguous-width characters as double width" setting.

### Common packages

* curl dialog exuberant-ctags fonts-powerline git graphviz htop less libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libbz2-dev libaio1 locate man powerline python python-dev python3 python3-dev python-pip python-powerline python-powerline-doc rsync rsyslog ruby sudo tcpdump telnet tmux unzip wget vim-nox vim-addon-manager

### Node packages

* nodejs:v5 build-essential npm:v3.8 bower:v1.7 grunt-cli:v1.1 gulp-cli:v1.2 yo:v1.7 generator-webapp

### PHP 5.6 packages

* oci8 composer phpunit phpdocumentor phpcodesniffer phpmd xdebug pcntl

### Oracle packages

* instantclient:v11.2 basic devel sqlplus

# NAME
     devenv -- Manage mkenney/devenv docker work environment containers

# SYNOPSYS
     devenv [-t TARGET] [-p PATH] [-d] [command]

# DESCRIPTION
     The devenv utility is used to manage mkenney/devenv docker containers to
     create a consistent bash-based shell environment. To detach from an
     instance, simply detach from the 'tmux' session (':detach')

# OPTIONS
     Command modifiers and alternate data inputs. Most commands take their
     own arguments.

         -h, -?
             Show the command usage screen

         --help, help
             Show this extended help screen

         --ctags-exclude
             Used to specify files or directories that should be excluded when
             compiling the tags file. The value can be either a comma-
             separated list of glob patterns or this option can be specified
             multiple times.

         -d, --daemonize
             Used when initializing or restarting an instance. If specified,
             allow the instance to continue running after detaching from the
             session, otherwise the container will be paused automatically.

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
             $HOME/.tmux.conf will be assumed. If the --tmux option
             is omitted then the .tmux.conf file from the docker image will
             be used.

         --tmux-prefix=PREFIX
             The default prefix key has been set to C-\ (control+backslash)
             to keep it from interfering with the default vim 'PageUp'
             binding. You can specify your preferred prefix binding when
             initializing an instance with this option. For example, to
             restore the default tmux prefix binding, use '--tmux-prefix=C-b'
             when initializing a new instance.

         --vimrc, --vimrc=PATH
             Specify a vim configuration file. If PATH is omitted then
             $HOME/.vimrc will be assumed. If the --vimrc option is
             omitted entirely then the default .vimrc file included with the
             docker image will be used.

             In addition, this script will attempt to mount a .vim/ folder
             from the same location as the .vimrc file.

# COMMANDS
     Available commands 'devenv' can execute. Most commands accept the
     optional TARGET or PATH arguments. TARGET refers to the name of the
     instance you are manipulating and PATH refers to the working directory
     that gets mounted into the /src directory in the instance.

     If PATH is omitted, it defaults to the current directory. If TARGET is,
     omitted, current instances are searched to see if any are attached to
     PATH, and if so, TARGET is set to that instance name. If not, TARGET
     defaults to the basename of the PATH value.

     If TARGET is specified but PATH is omitted, the reverse behavior happens
     and current instances are searced for one named TARGET. If one is found,
     PATH is set to the path the TARGET instance is attached to, otherwise the
     default again becomes the current directory.

     Both TARGET and PATH can be specified using the option arguments --target
     and --path respectively.

         attach [TARGET]
             Attach to an instance specified by the [TARGET] argument.

             EXAMPLES
                 devenv attach TARGET
                 devenv -t TARGET attach
                 devenv -p PATH attach

         build-tags [TARGET]
             Update the project ctags file.

             EXAMPLES
                 devenv build-tags TARGET
                 devenv -t TARGET build-tags
                 devenv -p PATH build-tags

         init [TARGET] [PATH]
             Create a new instance.

             EXAMPLES
                 devenv init TARGET PATH
                 devenv -p PATH create TARGET
                 devenv -t TARGET create PATH
                 devenv -t TARGET -p PATH create

         kill [TARGET]
             Stop a running instance and clean up.

             EXAMPLES
                 devenv kill TARGET
                 devenv -t TARGET kill
                 devenv -p PATH kill

         ls [pattern]
             List currently running instances, optionally filtering results
             with a glob pattern. If pattern is '-q' (quiet) only instance
             names are returned.

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
             Rename a running or stopped instance. 'rename' does not accept a
             PATH argument.

             EXAMPLES
                 devenv rename TARGET NEW_NAME
                 devenv -t TARGET rename NEW_NAME

         self-update
             Update to the latest 'mkenney/devenv' docker image and 'devenv'
             control script.

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
