#!/bin/bash

echo "Creating new dev session..."

##############################################################################
# env
##############################################################################

export TERM=xterm
export PATH=/root/.composer/vendor/bin:$PATH

##############################################################################
# logger
##############################################################################

sudo killall -9 rsyslogd > /dev/null 2>&1
sudo rm -f /var/run/rsyslogd.pid > /dev/null 2>&1
sudo /usr/sbin/rsyslogd > /dev/null 2>&1

##############################################################################
# project setup
##############################################################################

cd $PROJECT_PATH
if [ ! -f "/web.tags" ]; then
    sudo ctags-exuberant -f /web.tags --exclude='.git' --exclude='node_modules' --languages=+PHP,+JavaScript,+Perl,+Java -R /src && sudo chmod +r /src/web.tags
fi

##############################################################################
# import tnsnames
##############################################################################

sudo chown oracle:dba /oracle/product/latest/network/admin/tnsnames.ora
sudo chmod 644 /oracle/product/latest/network/admin/tnsnames.ora

##############################################################################
# "become" the user that owns the project directory
# do this last, in this order. sudo will stop working for the rest of the
# session after executing usermod
##############################################################################

sudo groupmod -g $(stat -c '%g' $PROJECT_PATH) -o dev > /dev/null 2>&1
sudo chgrp dev ~dev/
sudo usermod -u $(stat -c '%u' $PROJECT_PATH) -o dev > /dev/null 2>&1
