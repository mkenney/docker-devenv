#!/bin/bash

##############################################################################
# ctags setup
##############################################################################

echo "Building exuberant ctags..."

cd $PROJECT_PATH
ctags_flags=

# add excludes
if [ "" != "$CTAGS_EXCLUDES" ]; then # defined by `docker run`
    for a in $(echo $CTAGS_EXCLUDES | sed "s/,/ /g"); do
        ctags_flags="$ctags_flags --exclude=$a"
    done
fi

# --fields=+l for Valloric/YouCompleteMe support
ctags-exuberant --fields=+l --exclude=.git --exclude=node_modules --exclude=vendor $ctags_flags -f /src/tags.devenv --append -R $PROJECT_PATH > /dev/null 2>&1
