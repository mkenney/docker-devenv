
FROM php:5

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

ENV HOSTNAME 'devenv'
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
USER root
RUN mkdir -p /root/src \
    && apt-get -qq update \
    && apt-get install -qqy apt-utils \
    && apt-get -qq upgrade \
    && apt-get -qq dist-upgrade

##############################################################################
# Configurations
##############################################################################

ENV PATH /root/bin:$PATH

ENV UTF8_LOCALE en_US
ENV TIMEZONE 'America/Denver'

ENV ORACLE_VERSION_LONG 11.2.0.3.0-2
ENV ORACLE_VERSION_SHORT 11.2
ENV ORACLE_HOME /usr/lib/oracle/${ORACLE_VERSION_SHORT}/client64
ENV LD_LIBRARY_PATH ${ORACLE_HOME}/lib
ENV TNS_ADMIN /home/dev/.oracle/network/admin
ENV CFLAGS "-I/usr/include/oracle/${ORACLE_VERSION_SHORT}/client64/"
ENV NLS_LANG American_America.AL32UTF8

##############################################################################
# UTF-8 Locale, timezone
##############################################################################

RUN apt-get install -qqy locales \
    && locale-gen C.UTF-8 ${UTF8_LOCALE} \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8 \
    && export LANG=C.UTF-8 \
    && export LANGUAGE=C.UTF-8 \
    && export LC_ALL=C.UTF-8 \
    && echo ${TIMEZONE} > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

##############################################################################
# Packages
##############################################################################

RUN apt-get install -qqy \
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
        ruby \
        sudo \
        tcpdump \
        telnet \
        tmux \
        unzip \
        wget \
        vim-nox \
    && curl -sL https://deb.nodesource.com/setup_5.x | bash - > /dev/null \
    && apt-get install -qqy \
        nodejs \
        build-essential \
    && npm install -g npm \
    && npm install -g bower \
    && npm install -g grunt-cli \
    && npm install -g gulp-cli \
    && npm install -g yo \
    && npm install -g generator-webapp

##############################################################################
# Dependencies
##############################################################################

# https://sourceforge.net/projects/cloc/
COPY container/cloc /usr/local/bin/

# Oracle instantclient debs created using `alien`
COPY container/oracle-instantclient${ORACLE_VERSION_SHORT}-basic_${ORACLE_VERSION_LONG}_amd64.deb /root/src/
COPY container/oracle-instantclient${ORACLE_VERSION_SHORT}-devel_${ORACLE_VERSION_LONG}_amd64.deb /root/src/
COPY container/oracle-instantclient${ORACLE_VERSION_SHORT}-sqlplus_${ORACLE_VERSION_LONG}_amd64.deb /root/src/

##############################################################################
# Oracle instantclient
##############################################################################

RUN groupadd dba -g 201 -o \
    && useradd oracle -u 102 -o -s /bin/bash -m -g dba \
    && echo "oracle:password" | chpasswd \
    && cd /root/src \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-basic_${ORACLE_VERSION_LONG}_amd64.deb \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-devel_${ORACLE_VERSION_LONG}_amd64.deb \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-sqlplus_${ORACLE_VERSION_LONG}_amd64.deb \
    && mkdir -p /oracle/product \
    && ln -s $ORACLE_HOME /oracle/product/latest \
    && mkdir -p /oracle/product/latest/network/admin \
    && rm -f /root/src/oracle-instantclient${ORACLE_VERSION_SHORT}-basic_${ORACLE_VERSION_LONG}_amd64.deb \
    && rm -f /root/src/oracle-instantclient${ORACLE_VERSION_SHORT}-devel_${ORACLE_VERSION_LONG}_amd64.deb \
    && rm -f /root/src/oracle-instantclient${ORACLE_VERSION_SHORT}-sqlplus_${ORACLE_VERSION_LONG}_amd64.deb

##############################################################################
# PHP
##############################################################################

# INI directory
ENV PHP_INI_DIR '/usr/local/etc/php/conf.d'

# server_env
ENV server_env dev

# Extensions and ini settings
RUN curl -L http://pecl.php.net/get/xdebug-2.4.0RC2.tgz > /usr/src/php/ext/xdebug.tgz \
    && tar -xf /usr/src/php/ext/xdebug.tgz -C /usr/src/php/ext/ \
    && rm /usr/src/php/ext/xdebug.tgz \
    && docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/${ORACLE_VERSION_SHORT}/client64/lib \
    && docker-php-ext-install oci8 \
    && docker-php-ext-install xdebug-2.4.0RC2 \
    && docker-php-ext-install pcntl \
    && php -m \
    && echo "memory_limit=-1"               > $PHP_INI_DIR/memory_limit.ini \
    && echo "date.timezone=${TIMEZONE}"     > $PHP_INI_DIR/date_timezone.ini \
    && echo "error_reporting=E_ALL"         > $PHP_INI_DIR/error_reporting.ini \
    && echo "display_errors=On"             > $PHP_INI_DIR/display_errors.ini \
    && echo "log_errors=On"                 > $PHP_INI_DIR/log_errors.ini \
    && echo "report_memleaks=On"            > $PHP_INI_DIR/report_memleaks.ini \
    && echo "error_log=syslog"              > $PHP_INI_DIR/error_log.ini

##############################################################################
# composer
##############################################################################

ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION master
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer config -g secure-http false \
    && cd ~/composer \
    && chmod -R g+rw,o+rw .
ENV PATH /root/.composer/vendor/bin:$PATH

##############################################################################
# phpunit
##############################################################################

RUN cd /root/src \
    && wget https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && phpunit --version

##############################################################################
# phpDocumentor
##############################################################################

RUN pear channel-discover pear.phpdoc.org \
    && pear install phpdoc/phpDocumentor

##############################################################################
# PHP tools
##############################################################################

RUN pear install --alldeps php_codesniffer \
    && pear channel-discover pear.phpmd.org \
    && pear channel-discover pear.pdepend.org \
    && pear install phpmd/PHP_PMD

##############################################################################
# users
##############################################################################

# Add a user and configure both accounts
RUN groupadd dev \
    && useradd dev -s /bin/bash -m -g dev -G root \
    && echo "dev:password" | chpasswd \
    && echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && cd /root/src \
    && git clone https://github.com/mkenney/terminal_config.git \
    && cd /root/src/terminal_config/ \
    && git submodule update --init --recursive \
    && cd /root/src \
    && rsync -a terminal_config/ ~/ \
    && rsync -a terminal_config/ ~dev/ \
    && rsync -a terminal_config/ ~oracle/ \
    && rm -rf terminal_config \
    && echo "set tags=/src/tags"                               | tee -a ~/.vimrc        ~dev/.vimrc        ~oracle/.vimrc        \
    && echo "export ORACLE_HOME=$(echo $ORACLE_HOME)"          | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH)"  | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export TNS_ADMIN=$(echo $TNS_ADMIN)"              | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export CFLAGS=$(echo $CFLAGS)"                    | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export NLS_LANG=$(echo $NLS_LANG)"                | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export LANG=$(echo $LANG)"                        | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export LANGUAGE=$(echo $LANGUAGE)"                | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export LC_ALL=$(echo $LC_ALL)"                    | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && echo "export PATH=$(echo $PATH)"                        | tee -a ~/.bash_profile ~dev/.bash_profile ~oracle/.bash_profile \
    && chown -R dev:dev ~dev/. \
    && cd /root/ \
    && vim +PluginInstall +qall > /dev/null 2>&1

##############################################################################
# ~ fin ~
##############################################################################

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# devenv support scripts
COPY container/init.sh /
COPY container/attach.sh /

USER dev
# Don't forget to configure vim for the dev user. do this here
RUN cd ~/ && vim +PluginInstall +qall > /dev/null 2>&1
VOLUME ["/src"]
WORKDIR /src
CMD ["/bin/bash"]
