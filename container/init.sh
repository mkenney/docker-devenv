#!/bin/bash

echo "Creating new dev session..."

##############################################################################
# Dev env
##############################################################################

export TERM=xterm
export PATH=/root/.composer/vendor/bin:$PATH

##############################################################################
# System logger
##############################################################################

sudo killall -9 rsyslogd > /dev/null
sudo rm -rf /var/run/rsyslogd.pid  > /dev/null
sudo /usr/sbin/rsyslogd  > /dev/null

##############################################################################
# Project setup
##############################################################################

cd $PROJECT_PATH
if [ ! -f "/web.tags" ]; then
    sudo ctags-exuberant -f /web.tags --languages=+PHP,+JavaScript -R && chmod +r /web.tags
fi

sudo groupmod -g $(stat -c '%g' $PROJECT_PATH) dev > /dev/null
sudo usermod -u $(stat -c '%u' $PROJECT_PATH) dev > /dev/null

##############################################################################
# Tmux setup
##############################################################################

TMUXSESSION=tmuxdev

# Create a new tmux session
tmux new-session    -d -s $TMUXSESSION

# System logs
tmux rename-window     -t $TMUXSESSION:1 'Logs'
tmux send-keys         -t $TMUXSESSION:1 "sudo tail -f /var/log/messages" C-m

# Db Patches
tmux new-window        -t $TMUXSESSION:2 -n 'Vim'
tmux send-keys         -t $TMUXSESSION:2 "cd ${PROJECT_PATH} && clear && vim" C-m

tmux new-window        -t $TMUXSESSION:3 -n 'Shell'
tmux send-keys         -t $TMUXSESSION:3 "cd ${PROJECT_PATH} && clear" C-m

tmux select-window     -t $TMUXSESSION:3 # set my window toggle order
tmux select-window     -t $TMUXSESSION:2

#/bin/bash /attach.sh
