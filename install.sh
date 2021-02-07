#!/usr/bin/env bash

##############################################################################
##############################################################################
##
##  Globals and defaults
##
##############################################################################
##############################################################################

SELF=$0
DEFAULT_PATH=/usr/local/bin

__BRC_INSTALLER_URL=https://raw.githubusercontent.com/bdlm/.bdlmrc/master/install.sh
__BDLMRC_INSTALLER_LOCAL=/tmp/devenv-installer.sh

__BDLMRC_EXECUTABLE_URL=https://raw.githubusercontent.com/bdlm/.bdlmrc/master/bin/devenv
__BDLMRC_EXECUTABLE_TMPFILE=/tmp/devenv.tmp
__BDLMRC_EXECUTABLE_NAME=devenv
__BDLMRC_EXECUTABLE_PATH=


##############################################################################
##############################################################################
##
##  Lib
##
##############################################################################
##############################################################################

function __get_args {
    ret_val=
    for var in "$@"; do
        if [ "-" != "${var:0:1}" ]; then
            if [ "" == "$ret_val" ]; then
                ret_val="$var"
            else
                ret_val="$ret_val $var"
            fi
        fi
    done
    echo $ret_val | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

function __get_opts {
    declare ret_val=
    for var in "$@"; do
        if [ "--" == "${var:0:2}" ]; then
            if [ "" == "$ret_val" ]; then
                ret_val="${var:2}"
            else
                ret_val="$ret_val ${var:2}"
            fi
        fi
    done
    echo $(echo $ret_val | tr " " "\n" | sort | uniq | tr "\n" " " | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
}

function __get_flags {
    declare ret_val=
    for var in "$@"; do
        if [ "-" == "${var:0:1}" ] && [ "-" != "${var:1:1}" ]  && [ "" != "${var:1}" ]; then
            if [ "" == "$ret_val" ]; then
                ret_val="${var:1}"
            else
                ret_val="$ret_val ${var:1}"
            fi
        fi
    done
    echo $ret_val | tr " " "\n" | sort | uniq | tr "\n" " " | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

#
# Usage
#
function __usage {
    if [ "sh" == "$SELF" ] || [ "bash" == "$SELF" ]; then
        SELF="bash -s"
    fi

    echo "
    Usage: install.sh COMMAND [--prefix=PATH]

    Commands:
        install        Install the \`$__BDLMRC_EXECUTABLE_NAME\` command
        update         Update the \`$__BDLMRC_EXECUTABLE_NAME\` command
        remove         Delete the \`$__BDLMRC_EXECUTABLE_NAME\` command

    Options:
        --prefix=PATH  Optional, the location to use for the \`$__BDLMRC_EXECUTABLE_NAME\`
                       command. If omitted, your PATH will be searched.
                       Default '/usr/local/bin'.

    Examples:
        $ curl -L $__BRC_INSTALLER_URL | bash -s install --path=\$HOME/bin
        $ curl -L $__BRC_INSTALLER_URL | bash -s update
        $ curl -L $__BRC_INSTALLER_URL | bash -s remove
"
}
function __help {
    if [ "sh" == "$SELF" ] || [ "bash" == "$SELF" ]; then
        SELF="bash -s"
    fi

    echo "
    Name
        install.sh -- \`$__BDLMRC_EXECUTABLE_NAME\` install manager

    Synopsys
        install.sh COMMAND [--prefix=PATH]

    Summary
        Manage your $__BDLMRC_EXECUTABLE_NAME installation

    Commands
        install
                Install the \`$__BDLMRC_EXECUTABLE_NAME\` command

        remove
                Install the \`$__BDLMRC_EXECUTABLE_NAME\` command

        update
                Update the \`$__BDLMRC_EXECUTABLE_NAME\` command

    Common Options
        All commands accept the options listed below

        --prefix=PATH
                Optional, the location to place the \`$__BDLMRC_EXECUTABLE_NAME\` executable into, defaults to
                '/usr/local/bin'

    Examples
        $ curl -L $__BRC_INSTALLER_URL | bash -s install
"
}


##############################################################################
##############################################################################
##
##  Download the master install script and execute it locally
##
##  Loosely based on https://npmjs.org/install.sh, run as `curl | sh`
##  http://www.gnu.org/s/hello/manual/autoconf/Portable-Shell.html
##
##############################################################################
##############################################################################
if [ "sh" == "$SELF" ] || [ "bash" == "$SELF" ]; then

    #
    # Download and execute the install script
    #
    curl -f -L -s $__BRC_INSTALLER_URL > $__BDLMRC_INSTALLER_LOCAL
    exit_code=$?
    if [ 0 -ne $exit_code -eq 0 ]; then
        echo
        echo "Install failed: Could not download 'install.sh' from $__BRC_INSTALLER_URL" >&2
        exit $exit_code

    else
        if head $__BDLMRC_INSTALLER_LOCAL | grep -q '404: Not Found'; then
            echo "Install failed: The installation script could not be found at $__BRC_INSTALLER_URL"  >&2
            rm -f $__BDLMRC_INSTALLER_LOCAL
            exit 404
        fi
        if ! [ -s $__BDLMRC_INSTALLER_LOCAL ]; then
            echo
            echo "Install failed: Invalid or empty script at $__BRC_INSTALLER_URL" >&2
            exit 1
        fi
        (exit 0) # Reset $?
    fi

    bash $__BDLMRC_INSTALLER_LOCAL $@
    exit_code=$?
    rm -f $__BDLMRC_INSTALLER_LOCAL
    exit $exit_code
fi


##############################################################################
##############################################################################
##
##  asdf
##
##############################################################################
##############################################################################

#
INSTALL_ARG="$(__get_args $@)"
case $INSTALL_ARG in
    install|remove|update)
        ;;
    *)
        echo "Invalid command: '$INSTALL_ARG'"
        __help
        exit 1
esac

INSTALL_OPT_PREFIX=
for opt in "$(__get_opts $@)"; do
    option=${opt%%=*}
    value=${opt#*=}

    case $option in

        # Sanitize any prefix input
        prefix)
            INSTALL_OPT_PREFIX=$opt
            dir=$(dirname $value)
            value=$(basename $value)
            if [ "/" == "$value" ]; then value= ; fi

            if [ "" == "$dir" ]; then
                dir='./'
            elif [ "/" != "$dir" ]; then
                dir="$dir/"
            fi
            __BDLMRC_EXECUTABLE_PATH="${dir}${value}"
            ;;

        *)
            if [ "" != "$opt" ]; then
                echo "Option provided but not defined: --$option"
                __usage
                exit 1
            fi
    esac
done

#
# No install prefix specified, search the user's path for an existing install
#
if [ "" == "$INSTALL_OPT_PREFIX" ]; then
    tmp=$(which $__BDLMRC_EXECUTABLE_NAME)
    if [ 0 -eq $? ] && [ "" != "$tmp" ]; then
        __BDLMRC_EXECUTABLE_PATH=$(dirname $tmp)
    fi
fi
if [ "" == "$__BDLMRC_EXECUTABLE_PATH" ]; then
    __BDLMRC_EXECUTABLE_PATH=$DEFAULT_PATH
fi

case $INSTALL_ARG in

    #
    # Install the `devenv` command
    #
    install|update)

        # Download and validate the script
        curl -f -L -s $__BDLMRC_EXECUTABLE_URL > $__BDLMRC_EXECUTABLE_TMPFILE
        exit_code=$?
        if [ $exit_code -ne 0 ]; then
            echo
            echo "$INSTALL_ARG failed: Could not download '$__BDLMRC_EXECUTABLE_URL'"
            exit $exit_code
        fi
        if grep -q '404: Not Found' $__BDLMRC_EXECUTABLE_TMPFILE; then
            usage
            echo
            echo "Not found: $__BDLMRC_EXECUTABLE_URL";
            exit 404
        fi
        if ! [ -s $__BDLMRC_EXECUTABLE_TMPFILE ]; then
            echo
            echo "$INSTALL_ARG failed: Invalid or empty script or download failed -- $__BDLMRC_EXECUTABLE_URL > $__BDLMRC_EXECUTABLE_TMPFILE"
            exit $exit_code
        fi
        (exit 0)

        # Create the installation directory
        mkdir -p "$__BDLMRC_EXECUTABLE_PATH"
        exit_code=$?
        if [ 0 -ne $exit_code ]; then
            echo
            echo "$INSTALL_ARG failed: Could not create directory '$__BDLMRC_EXECUTABLE_PATH'"
            exit $exit_code
        fi
        (exit 0)

        # Cat the tempfile into the command file instead of moving it so that
        # symlinkys aren't destroyed
        result=$( (cat $__BDLMRC_EXECUTABLE_TMPFILE > $__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME) 2>${__BDLMRC_EXECUTABLE_TMPFILE}.err)
        exit_code=$?
        errors=$(< ${__BDLMRC_EXECUTABLE_TMPFILE}.err)
        if [ 0 -ne $exit_code ] || [ "" != "$errors" ]; then
            echo "$errors"
            echo
            echo "$INSTALL_ARG failed: Could not write to '$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME'"
            if [ "${my_string/denied}" == "$my_string" ]; then
                echo "   ...do you need more sudo?"
            fi
            rm -f ${__BDLMRC_EXECUTABLE_TMPFILE}.err
            exit $exit_code
        fi
        (exit 0)

        # Set the execute bit
        result=$( (chmod +x $__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME) 2>${__BDLMRC_EXECUTABLE_TMPFILE}.err)
        exit_code=$?
        errors=$(< ${__BDLMRC_EXECUTABLE_TMPFILE}.err)
        if [ 0 -ne $exit_code ] || [ "" != "$errors" ]; then
            echo "$errors"
            echo
            echo "$INSTALL_ARG failed: Could not set execute bit on '$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME'"
            if [ "${my_string/permissions}" == "$my_string" ]; then
                echo "   ...do you need more sudo?"
            fi
            rm -f ${__BDLMRC_EXECUTABLE_TMPFILE}.err
            exit $exit_code
        fi
        (exit 0)

        # Cleanup the tempfile
        rm -f $__BDLMRC_EXECUTABLE_TMPFILE
        exit_code=$?
        if [ 0 -ne $exit_code ]; then
            echo
            echo "Error: Could not delete tempfile '$__BDLMRC_EXECUTABLE_TMPFILE'"
            exit $exit_code
        fi
        (exit 0)

        # w00t
        echo
        echo "$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME: $INSTALL_ARG succeeded"
        exit 0
        ;;

    #
    # Remove the `devenv` command
    #
    remove)
        if [ ! -f "$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME" ]; then
            echo "$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME does not exist"
            exit 1
        fi
        if [ -L "$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME" ]; then
            orig=$(readlink -f "$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME")
            echo "$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME is a symbolic link to $orig"
            echo "Removing $orig"
            rm -f "$orig"
            error_code=$?
            if [ 0 -ne $error_code ]; then
                echo "There was an error deleting $orig"
                exit $error_code
            fi
        fi
        echo "Removing $__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME"
        rm -f "$__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME"
            error_code=$?
            if [ 0 -ne $error_code ]; then
                echo "There was an error deleting $__BDLMRC_EXECUTABLE_PATH/$__BDLMRC_EXECUTABLE_NAME"
                exit $error_code
            fi
        echo "Done."
        exit 0
        ;;
esac
