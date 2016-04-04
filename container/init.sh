#!/bin/bash

echo "Creating new dev session..."

##############################################################################
# start system logger
##############################################################################

sudo /usr/sbin/rsyslogd > /dev/null

#############################################################################
# Run-once updates
#############################################################################

# Custom tmux prefix string
if [ "" != "$TMUX_PREFIX" ]; then
    echo "# Custom prefix key set with --tmux-prefix" >> /home/dev/.tmux.conf
    echo "set-option -g prefix2 $TMUX_PREFIX" >> /home/dev/.tmux.conf
fi

#############################################################################
# set tnsnames permissions
##############################################################################

sudo chown oracle:dba /oracle/product/latest/network/admin/tnsnames.ora
sudo chmod 644 /oracle/product/latest/network/admin/tnsnames.ora

##############################################################################
# "become" the user that owns the project directory
#
# do this last, in this order. sudo will stop working for the rest of the
# session after executing usermod
##############################################################################

sudo groupmod -g $(stat -c '%g' $PROJECT_PATH) -o dev > /dev/null 2>&1
sudo chgrp dev ~dev/
sudo usermod -u $(stat -c '%u' $PROJECT_PATH) -o dev > /dev/null 2>&1
