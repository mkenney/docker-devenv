#!/bin/bash

echo "Creating new dev session..."

##############################################################################
# environment setup
##############################################################################

sudo /usr/sbin/rsyslogd > /dev/null

##############################################################################
# project setup
##############################################################################

cd $PROJECT_PATH
if [ ! -f "/src/tags" ]; then
    sudo ctags-exuberant --exclude='.git' --exclude='node_modules' --languages=+PHP,+JavaScript,+Perl,+Java,+Python -R /src
fi

##############################################################################
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
