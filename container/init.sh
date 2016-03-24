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
sudo rm -rf /var/run/rsyslogd.pid  > /dev/null 2>&1
sudo /usr/sbin/rsyslogd  > /dev/null 2>&1

##############################################################################
# project setup
##############################################################################

cd $PROJECT_PATH
if [ ! -f "/web.tags" ]; then
    sudo ctags-exuberant -f /web.tags --languages=+PHP,+JavaScript,+Perl,+Java -R && chmod +r /web.tags
fi

sudo chown oracle:dba /oracle/product/latest/network/admin/tnsnames.ora
sudo chmod 644 /oracle/product/latest/network/admin/tnsnames.ora

# do these last...
#sudo echo groupmod -g $(stat -c '%g' $PROJECT_PATH) dev
sudo groupmod -g $(stat -c '%g' $PROJECT_PATH) dev > /dev/null 2>&1
sudo chgrp dev ~dev/
sudo usermod -u $(stat -c '%u' $PROJECT_PATH) dev > /dev/null 2>&1
