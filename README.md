# .bdlmrc

`.bdlmrc` provides a rich `bash` shell environment aimed at software developers, but should be useful for for all types of digital content creation.

## ABOUT

This project began as a way to easily move a consistent working enviroment around from system to system, but quickly became a full-fledged, well-rounded IDE. The goal of this project is to have a fully isolated, lightweight, consistent, virtual environment dedicated to each individual project someone may be working on.

The "environments" are managed by an intuitive CLI tool, each one containing common development tools needed for most day-to-day tasks (code development, run scripts in various langunages, etc.). The `dev` CLI tool allows treating a `docker` container instance, via the [volume mount system](https://docs.docker.com/storage/volumes/), as an individual project. Essentially, a fully dedicated, extremely lightweight, [Ubuntu 20.04 LTS (Focal Fossa) 64-bit Linux](https://releases.ubuntu.com/20.04/) instance dedicated to a single project. The [docker image](https://hub.docker.com/r/bdlm/.bdlmrc) can easily be extended to suit your own needs.

Because

## Installation

Installation is really just copying a fairly simple bash script into your path, but the script makes use of [Docker](https://www.docker.com/) and assumes that you can [run `docker` commands without sudo](https://docs.docker.com/engine/install/linux-postinstall/):

1. Install docker on your system. This command varies from system to system so you're on your own, but there are tons of [instructions online](https://www.google.com/search?q=install+docker&oq=install+docker&aqs=chrome.0.0l2j69i60l3j0.1975j0j1&sourceid=chrome&ie=UTF-8) so it should be easy. For example, if you happen to be using a Debian-based system it's as simple as `sudo apt-get install docker`. If you're on a Mac, things are less simple but still [pretty easy](https://docs.docker.com/engine/installation/mac/).
1. Linux users will want to make sure your user can [run `docker` commands without sudo](https://docs.docker.com/engine/install/linux-postinstall/).
1. Mac users will need to add some core utilities before proceeding to get super unusual rarely used unique functionality like `realpath` (some barebones Linux distributions may need to install some similar packages)...
  * Install [Homebrew](http://brew.sh/)
  * Run `brew install coreutils`
  * Add `/usr/local/opt/coreutils/libexec/gnubin` to your path (see the output of `brew install coreutils` for the exact path)
1. Select an installation directory in your path for the `dev` utility (lets assume `/usr/bin`) and run:
  * `sudo wget -nv -O /usr/bin/dev https://raw.githubusercontent.com/bdlm/.bdlmrc/master/bin/dev`
  * `sudo chmod +rwx /usr/bin/dev` (write permission lets it `self-update` as any user).
  * `dev self-update`

### Docker image

* [bdlm/.bdlmrc](https://hub.docker.com/r/bdlm/.bdlmrc)

The Linux environment is based on [`ubuntu:20.04`](https://hub.docker.com/_/ubuntu?tab=tags&page=1&ordering=last_updated&name=20.04). The default bash shell is based on [mkenney/.dotfiles](https://github.com/mkenney/.dotfiles) and, when using the `dev` cli, initializes and attaches to a `tmux` session when you connect to the container. The default `tmux` command-prefix key has been remapped to `M-space` (meta+space) to avoid conflicts with nested Tmux sessions. You can specify a secondary command-prefix key with the `--tmux-prefix` option or use your own `.tmux.conf` file with the `--tmux` option.

The default user is modified when the container is initialized so it runs as the owner of the project directory on the host and belongs to the same group so new files will be created with the same `uid` and `gid` on the host.

By default, `~/.ssh/` and `~/.oracle/` (for [oracle wallet](http://docs.oracle.com/cd/B19306_01/network.102/b14266/cnctslsh.htm#g1033548)) are mounted into the home directory and if a `tnsnames.ora` file exists on the host at `/oracle/product/latest/network/admin/tnsnames.ora` it will be copied to the same location inside the container. This should be enough to automate connecting to oracle (sqlplus is installed in the container) but ymmv. If the connection fails, make sure the path to the wallet files is correct. Take a look at `~/.oracle/network/admin/sqlnet.ora` and make sure the path doesn't contain your username from the host machine. `(DIRECTORY = $HOME/.oracle/network/wallet)` should work for both the container and the host in most environments.

Several additional directories are also automatically mounted if they exist to provide a seamless experience, including:
* `~/.aws`
* `~/.config`
* `~/.helm`
* `~/.kube`
* `~/.npm`
* `~/.oracle`
* `~/.ssh`
* `~/.tmux.conf`
* `~/.vim`
* `~/.vimrc`

#### Powerline

[Powerline](https://github.com/powerline/powerline) is installed and enabled in the default `tmux` and `vim` configurations. You can easily override it with your own configuration files by passing the `--tmux` or `--vimrc` options when starting a new instance with the `init` or `restart` commands.

If you do want to use `powerline`, you may want to install and use a compatible font in your terminal emulator. I use [iTerm 2](https://www.iterm2.com/) with the [Fira Code](https://github.com/tonsky/FiraCode) font without any issues. If you're using iTerm, you should also uncheck the "_Treat ambiguous-width characters as double width_" setting.

#### Common packages

* curl dialog emacs exuberant-ctags fonts-powerline git graphviz htop less libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev libbz2-dev libaio1 locate man powerline python python-dev python3 python3-dev python-pip python-powerline python-powerline-doc rsync rsyslog ruby sbcl slime sudo tcpdump telnet tmux unzip wget vim-nox vim-addon-manager

#### Node packages

* nodejs:v5 build-essential npm:v3.8 bower:v1.7 grunt-cli:v1.1 gulp-cli:v1.2 yo:v1.7 generator-webapp

#### Oracle packages

* instantclient:v11.2 basic devel sqlplus

#

# NAME
     dev -- Manage bdlm/.bdlmrc docker work environment containers

# SYNOPSYS
     dev [-t TARGET] [-p PATH] [-d] [command]

# DESCRIPTION
     The dev utility is used to manage bdlm/.bdlmrc docker containers to
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
             The default prefix key has been set to `M-space` (meta+space)
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
     Available commands 'dev' can execute. Most commands accept the
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
                 dev attach TARGET
                 dev -t TARGET attach
                 dev -p PATH attach

         build-tags [TARGET]
             Update the project ctags file.

             EXAMPLES
                 dev build-tags TARGET
                 dev -t TARGET build-tags
                 dev -p PATH build-tags

         init [TARGET] [PATH]
             Create a new instance.

             EXAMPLES
                 dev init TARGET PATH
                 dev -p PATH create TARGET
                 dev -t TARGET create PATH
                 dev -t TARGET -p PATH create

         kill [TARGET]
             Stop a running instance and clean up.

             EXAMPLES
                 dev kill TARGET
                 dev -t TARGET kill
                 dev -p PATH kill

         ls [pattern]
             List currently running instances, optionally filtering results
             with a glob pattern. If pattern is '-q' (quiet) only instance
             names are returned.

             EXAMPLES
                 dev ls
                 dev ls java*
                 dev ls *-php-v7.?
                 dev ls -q

         pause [TARGET]
             Pause a running instance.

             EXAMPLES
                 dev pause TARGET
                 dev -t TARGET pause
                 dev -p PATH pause

         restart [TARGET]
             Kill and re-create the specified running instance.

             EXAMPLES
                 dev restart TARGET
                 dev -t TARGET restart
                 dev -p PATH restart

         rename [TARGET] NEW_NAME
             Rename a running or stopped instance. 'rename' does not accept a
             PATH argument.

             EXAMPLES
                 dev rename TARGET NEW_NAME
                 dev -t TARGET rename NEW_NAME

         self-update
             Update to the latest 'bdlm/.bdlmrc' docker image and 'dev' control
             script.

             EXAMPLES
                 dev self-update

         unpause [TARGET]
             Start a paused instance.

             EXAMPLES
                 dev unpause TARGET
                 dev -t TARGET unpause
                 dev -p PATH unpause

# TODO
     - Improve error handling and messages

# AUTHORS
     Michael Kenney <mkenney@webbedlam.com>
