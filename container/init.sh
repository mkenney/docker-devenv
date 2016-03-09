#!/bin/bash

##############################################################################
# System logger
##############################################################################

sudo rsyslogd

##############################################################################
# Project setup
##############################################################################

cd /project && sudo ctags-exuberant -f /web.tags --languages=+PHP,+JavaScript -R
echo ":set tags=~/web.tags" >> /home/developer/.vimrc

##############################################################################
# Tmux setup
##############################################################################

TMUXSESSION=tmuxdev
tmux attach-session -t $TMUXSESSION
if [ $? != 0 ]
then
	echo "Creating new dev session..."

	# Create a new tmux session
	tmux new-session -d -s $TMUXSESSION

	# System logs
	tmux rename-window     -t $TMUXSESSION:1 'Logs'
	tmux send-keys         -t $TMUXSESSION:1 "sudo tail -f /var/log/messages" C-m

	# Db Patches
	tmux new-window        -t $TMUXSESSION:2 -n 'Vim'
	tmux send-keys         -t $TMUXSESSION:2 "cd /project && clear && vim" C-m

	tmux new-window        -t $TMUXSESSION:3 -n 'Shell'
	tmux send-keys         -t $TMUXSESSION:3 "cd /project && clear" C-m

	echo "Done."

	tmux select-window      -t $TMUXSESSION:3 # so my window toggle order
	tmux select-window      -t $TMUXSESSION:2
	tmux attach-session     -t $TMUXSESSION
fi
