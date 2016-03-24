
FROM php:5

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

ENV HOSTNAME 'devenv'
ENV DEBIAN_FRONTEND noninteractive
USER root
RUN mkdir -p /root/src
RUN apt-get update
RUN apt-get install -y apt-utils

##############################################################################
# Configurations
##############################################################################

ENV PHP_TIMEZONE 'America/Denver'

##############################################################################
# System logger
##############################################################################

RUN apt-get install -y rsyslog && \
    rm -rf /var/run/rsyslogd.pid

##############################################################################
# UTF-8 Locale
##############################################################################

RUN apt-get install -y locales && \
    locale-gen C.UTF-8 en_US && \
    dpkg-reconfigure locales && \
    dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

RUN export LANG=C.UTF-8 && \
    export LANGUAGE=C.UTF-8 && \
    export LC_ALL=C.UTF-8

##############################################################################
# Apps
##############################################################################

RUN apt-get install -y \
    git \
    htop \
    less \
    rsync \
    sudo \
    tcpdump \
    telnet \
    tmux \
    unzip \
    wget \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libbz2-dev \
    libaio1

COPY container/cloc /usr/local/bin/

##############################################################################
# Oracle instantclient
##############################################################################

# Copy instantclient debs created using `alien`
COPY container/oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb /root/src/
COPY container/oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb /root/src/
COPY container/oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb /root/src/

RUN groupadd dba && \
    useradd oracle -s /bin/bash -m -g dba && \
    echo "oracle:password" | chpasswd

RUN cd /root/src && \
    dpkg -i oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb && \
    dpkg -i oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb && \
    dpkg -i oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb && \
    export ORACLE_HOME=/usr/lib/oracle/11.2/client64 && \
    export LD_LIBRARY_PATH="$ORACLE_HOME/lib" && \
    export CFLAGS="-I/usr/include/oracle/11.2/client64/" && \
    echo 'export ORACLE_HOME=/oracle/product/latest' >> /root/.bashrc && \
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib' >> /root/.bashrc && \
    echo 'export TNS_ADMIN=/usr/share/httpd/.oracle/network/admin' >> /root/.bashrc && \
    echo 'export NLS_LANG=American_America.AL32UTF8' >> /root/.bashrc && \
    mkdir -p /oracle/product && \
    ln -s "$ORACLE_HOME" /oracle/product/latest && \
    mkdir -p /oracle/product/latest/network/admin

##############################################################################
# PHP
##############################################################################

# Extensions
RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib && \
    docker-php-ext-install oci8

# Config
ENV PHP_INI_DIR '/usr/local/etc/php/conf.d'
RUN echo "memory_limit=-1"               > $PHP_INI_DIR/memory_limit.ini && \
    echo "date.timezone=${PHP_TIMEZONE}" > $PHP_INI_DIR/date_timezone.ini && \
    echo "error_reporting=E_ALL"         > $PHP_INI_DIR/error_reporting.ini && \
    echo "display_errors=On"             > $PHP_INI_DIR/display_errors.ini && \
    echo "log_errors=On"                 > $PHP_INI_DIR/log_errors.ini && \
    echo "report_memleaks=On"            > $PHP_INI_DIR/report_memleaks.ini && \
    echo "error_log=syslog"              > $PHP_INI_DIR/error_log.ini && \
    echo "extension=oci8.so"             > $PHP_INI_DIR/oci8.ini

##############################################################################
# Composer
##############################################################################

ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION master
RUN apt-get install -y curl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

##############################################################################
# phpDocumentor
##############################################################################

RUN apt-get install -y graphviz && \
    pear channel-discover pear.phpdoc.org && \
    pear install phpdoc/phpDocumentor

##############################################################################
# phpunit
##############################################################################

WORKDIR /tmp
RUN composer require "phpunit/phpunit:~5.1.0" --prefer-source --no-interaction
RUN ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit

##############################################################################
# Vim
##############################################################################

RUN apt-get install -y \
    exuberant-ctags \
    vim

RUN pear install --alldeps php_codesniffer && \
    pear channel-discover pear.phpmd.org && \
    pear channel-discover pear.pdepend.org && \
    pear install phpmd/PHP_PMD && \
    export PATH=/root/.composer/vendor/bin:$PATH

##############################################################################
# Users
##############################################################################

# Add a user
RUN groupadd dev && \
    useradd dev -s /bin/bash -m -g dev -G root && \
    echo "dev:password" | chpasswd && \
    echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    cd ~dev/ && \
    git clone https://github.com/mkenney/terminal_config.git && \
    rsync -av terminal_config/ ./ && \
    chown -R dev:dev . && \
    rsync -av terminal_config/ ~/ && \
    cd ~/ && \
    git submodule update --init --recursive && \
    vim +PluginInstall +qall > /dev/null

USER dev
RUN cd ~/ && \
    git submodule update --init --recursive && \
    vim +PluginInstall +qall > /dev/null && \
    export ORACLE_HOME=/usr/lib/oracle/12.1/client64 && \
    export LD_LIBRARY_PATH="$ORACLE_HOME/lib" && \
    export CFLAGS="-I/usr/include/oracle/$SHORT_VERSION/client64/" && \
    echo 'export ORACLE_HOME=/oracle/product/latest' >> ~/.bashrc && \
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib' >> ~/.bashrc && \
    echo 'export TNS_ADMIN=/usr/share/httpd/.oracle/network/admin' >> ~/.bashrc && \
    echo 'export NLS_LANG=American_America.AL32UTF8' >> ~/.bashrc

RUN export LANG=C.UTF-8 && \
    export LANGUAGE=C.UTF-8 && \
    export LC_ALL=C.UTF-8
USER root


##############################################################################
# ~ fin ~
##############################################################################

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY container/init.sh /
COPY container/attach.sh /
USER dev
VOLUME ["/app"]
CMD ["/bin/bash"]
