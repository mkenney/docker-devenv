
FROM php:5

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

ENV HOSTNAME 'devenv'
ENV DEBIAN_FRONTEND noninteractive
USER root
RUN mkdir -p /root/src
RUN apt-get update && \
    apt-get install -y apt-utils

##############################################################################
# Configurations
##############################################################################

ENV PHP_TIMEZONE 'America/Denver'

##############################################################################
# UTF-8 Locale
##############################################################################

RUN apt-get install -y locales && \
    locale-gen C.UTF-8 en_US && \
    dpkg-reconfigure locales && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

RUN export LANG=C.UTF-8 && \
    export LANGUAGE=C.UTF-8 && \
    export LC_ALL=C.UTF-8

##############################################################################
# Packages
##############################################################################

RUN apt-get install -y \
        curl \
        exuberant-ctags \
        git \
        graphviz \
        htop \
        less \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libbz2-dev \
        libaio1 \
        rsync \
        rsyslog \
        sudo \
        tcpdump \
        telnet \
        tmux \
        unzip \
        wget \
        vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

##############################################################################
# Dependencies
##############################################################################

# https://sourceforge.net/projects/cloc/
COPY container/cloc /usr/local/bin/

# Oracle instantclient debs created using `alien`
COPY container/oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb /root/src/
COPY container/oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb /root/src/
COPY container/oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb /root/src/

##############################################################################
# Oracle instantclient
##############################################################################

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
RUN curl -L http://pecl.php.net/get/xdebug-2.4.0RC2.tgz > /usr/src/php/ext/xdebug.tgz && \
    tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ && \
    rm /usr/src/php/ext/xdebug.tgz && \
    docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/11.2/client64/lib && \
    docker-php-ext-install oci8 && \
    docker-php-ext-install xdebug-2.4.0RC2 && \
    docker-php-ext-install pcntl && \
    php -m

# Config
ENV PHP_INI_DIR '/usr/local/etc/php/conf.d'
RUN echo "memory_limit=-1"               > $PHP_INI_DIR/memory_limit.ini && \
    echo "date.timezone=${PHP_TIMEZONE}" > $PHP_INI_DIR/date_timezone.ini && \
    echo "error_reporting=E_ALL"         > $PHP_INI_DIR/error_reporting.ini && \
    echo "display_errors=On"             > $PHP_INI_DIR/display_errors.ini && \
    echo "log_errors=On"                 > $PHP_INI_DIR/log_errors.ini && \
    echo "report_memleaks=On"            > $PHP_INI_DIR/report_memleaks.ini && \
    echo "error_log=syslog"              > $PHP_INI_DIR/error_log.ini

##############################################################################
# composer
##############################################################################

ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION master
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer config -g secure-http false && \
    cd ~/composer && \
    chmod -R g+rw,o+rw .

##############################################################################
# phpunit
##############################################################################

WORKDIR /root/src
RUN wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit && \
    phpunit --version

##############################################################################
# phpDocumentor
##############################################################################

RUN pear channel-discover pear.phpdoc.org && \
    pear install phpdoc/phpDocumentor

##############################################################################
# vim
##############################################################################

RUN pear install --alldeps php_codesniffer && \
    pear channel-discover pear.phpmd.org && \
    pear channel-discover pear.pdepend.org && \
    pear install phpmd/PHP_PMD && \
    export PATH=/root/.composer/vendor/bin:$PATH

##############################################################################
# users
##############################################################################

# Add a user
RUN groupadd dev && \
    useradd dev -s /bin/bash -m -g dev -G root && \
    echo "dev:password" | chpasswd && \
    echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    cd ~dev/ && \
    git clone https://github.com/mkenney/terminal_config.git && \
    rsync -a terminal_config/ ./ && \
    chown -R dev:dev . && \
    rsync -a terminal_config/ ~/ && \
    cd ~/ && \
    git submodule update --init --recursive > /dev/null 2>&1 && \
    vim +PluginInstall +qall > /dev/null 2>&1

USER dev
RUN cd ~/ && \
    git submodule update --init --recursive > /dev/null 2>&1 && \
    vim +PluginInstall +qall > /dev/null 2>&1 && \
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

COPY container/init.sh /
COPY container/attach.sh /

USER dev
VOLUME ["/src"]
WORKDIR /src
CMD ["/bin/bash"]
