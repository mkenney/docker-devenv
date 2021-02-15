#!/usr/bin/env bash

TMUXSESSION=$HOSTNAME

tmux attach-session -t $TMUXSESSION
if [ $? != 0 ]; then

##############################################################################
# tmux setup
##############################################################################

    echo "Creating tmux session..."

    # Create a new tmux session
    tmux new-session    -d -s $TMUXSESSION

    # System logs
    tmux rename-window     -t $TMUXSESSION:0 'Logs'
    tmux send-keys         -t $TMUXSESSION:0 "sudo tail -f /var/log/syslog" C-m

    # editor
    tmux new-window        -t $TMUXSESSION:1
    tmux send-keys         -t $TMUXSESSION:1 "cd ${PROJECT_PATH} && clear" C-m
    if [ "true" != "${__IS_SCRATCH}" ]; then
        tmux send-keys      -t $TMUXSESSION:1 "vim ." C-m
    fi

    # shell
    tmux new-window        -t $TMUXSESSION:2
    tmux send-keys         -t $TMUXSESSION:2 "cd ${PROJECT_PATH} && clear" C-m

    # toggle order
    tmux select-window     -t $TMUXSESSION:2
    tmux select-window     -t $TMUXSESSION:1

    echo "Done."
    tmux attach-session    -t $TMUXSESSION
fi
