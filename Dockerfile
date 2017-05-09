FROM php:7

ENV DEBIAN_FRONTEND noninteractive

##############################################################################
# Configurations
##############################################################################

ENV HOSTNAME 'devenv'
ENV TERM xterm

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
# Upgrade
##############################################################################

RUN set -x \
    && cd / \
    && mkdir -p /src \
    && apt-get -qq update \
    && apt-get install -qqy apt-utils \
    && apt-get -qq upgrade \
    && apt-get -qq dist-upgrade

##############################################################################
# UTF-8 Locale, timezone
##############################################################################

RUN set -x \
    && apt-get install -qqy locales \
    && locale-gen C.UTF-8 ${UTF8_LOCALE} \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8 \
    && export LANG=C.UTF-8 \
    && export LANGUAGE=C.UTF-8 \
    && export LC_ALL=C.UTF-8 \
    && echo ${TIMEZONE} > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# set this here, c.utf-8 doesn't exist until now
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

##############################################################################
# Packages
##############################################################################

RUN set -x \
    && apt-get install -qqy \
        autogen \
        automake \
        curl \
        dialog \
        emacs24 \
        exuberant-ctags \
        gcc \
        git \
        graphviz \
        htop \
        less \
        libevent-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libncurses5-dev \
        libpng12-dev \
        libbz2-dev \
        libaio1 \
        locate \
        man \
        powerline \
        python \
        python-dev \
        python3 \
        python3-dev \
        python-pip \
        python-powerline \
        python-powerline-doc \
        rsync \
        rsyslog \
        ruby \
        sbcl \
        slime \
        sudo \
        tcpdump \
        telnet \
        unzip \
        wget \
        vim-nox \
        vim-addon-manager \
        x11-xserver-utils \
        zsh \

    # install current tmux
    && curl -OL https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz \
    && tar xf tmux-2.4.tar.gz \
    && cd tmux-2.4 \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -f tmux-2.4.tar.gz \
    && rm -rf tmux-2.4 \

    # locate db
    && updatedb \

    # install node and tools
    && curl -sL https://deb.nodesource.com/setup_5.x | bash - > /dev/null \
    && apt-get install -qqy \
        nodejs \
        build-essential \

    # Upgrade npm
    # Don't use npm to self-upgrade, see issue https://github.com/npm/npm/issues/9863
    && curl -L https://npmjs.org/install.sh | sh \

    # Install node packages
    && npm install --silent -g \
        npm \
        bower \
        grunt-cli \
        gulp-cli \
        markdown-styles \
        yarn

COPY bin/devenv /usr/local/bin/devenv
COPY _image /_image

##############################################################################
# Oracle instantclient
##############################################################################

RUN set -x \
    && groupadd dba -g 201 -o \
    && useradd oracle -u 102 -o -s /bin/bash -m -g dba \
    && echo "oracle:password" | chpasswd \
    && cd /_image \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-basic_${ORACLE_VERSION_LONG}_amd64.deb \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-devel_${ORACLE_VERSION_LONG}_amd64.deb \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-sqlplus_${ORACLE_VERSION_LONG}_amd64.deb \
    && mkdir -p /oracle/product \
    && ln -s $ORACLE_HOME /oracle/product/latest \
    && mkdir -p /oracle/product/latest/network/admin \

    # cleanup
    && rm -f /oracle-instantclient${ORACLE_VERSION_SHORT}-basic_${ORACLE_VERSION_LONG}_amd64.deb \
    && rm -f /oracle-instantclient${ORACLE_VERSION_SHORT}-devel_${ORACLE_VERSION_LONG}_amd64.deb \
    && rm -f /oracle-instantclient${ORACLE_VERSION_SHORT}-sqlplus_${ORACLE_VERSION_LONG}_amd64.deb

##############################################################################
# PHP
##############################################################################

# INI directory
ENV PHP_INI_DIR /usr/local/etc/php/conf.d

# server_env
ENV server_env dev

# Extensions and ini settings
RUN set -x \
    # Packages
    # - libaio1 is required for oci8
    # - libicu-dev is required for intl
    # - libmemcached-dev is required for memcached
    # - libvpx-dev is required for GD
    # - libwebp-dev is required for GD
    # - libxpm-dev is required for GD
    # - libxml2-dev is required for soap
    # - php-pear is just good stuff
    && apt-get install -qqy \
        libaio1 \
        libicu-dev \
        libvpx-dev \
        libwebp-dev \
        libxpm-dev \
        libxml2-dev \
        php-pear \

    # Configure and install oci8
    # Don't poke it or it'll break
    && cp /usr/include/oracle/${ORACLE_VERSION_SHORT}/client64/* /oracle/product/latest/ \
    && cd /oracle/product/latest \
    && ln -s lib/libnnz11.so       libnnz.so \
    && ln -s lib/libnnz11.so       libnnz11.so \
    && ln -s lib/libclntsh.so.11.1 libclntsh.so \
    && ln -s lib/libclntsh.so.11.1 libclntsh.so.11.1 \
    && echo "instantclient,/oracle/product/latest" | pecl install oci8-2.1.1.tgz \
    && echo "extension=oci8.so" > $PHP_INI_DIR/oci8.ini \

    # Extensions
    && docker-php-source extract \
    && docker-php-ext-configure gd \
        --enable-gd-jis-conv \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ \
        --with-xpm-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j$NPROC \
        gd \
        iconv \
        intl \
        mbstring \
        mcrypt \
        mysqli \
        pdo_mysql \
        pcntl \
        soap \
        sockets \
        zip \

    # INI settings
    && echo "memory_limit=-1"           > $PHP_INI_DIR/memory_limit.ini \
    && echo "date.timezone=${TIMEZONE}" > $PHP_INI_DIR/date_timezone.ini \
    && echo "error_reporting=E_ALL"     > $PHP_INI_DIR/error_reporting.ini \
    && echo "display_errors=On"         > $PHP_INI_DIR/display_errors.ini \
    && echo "log_errors=On"             > $PHP_INI_DIR/log_errors.ini \
    && echo "report_memleaks=On"        > $PHP_INI_DIR/report_memleaks.ini \
    && echo "error_log=syslog"          > $PHP_INI_DIR/error_log.ini

##############################################################################
# xdebug (for code-coverage reports)
##############################################################################

RUN set -x \
    && yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.coverage_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini

##############################################################################
# composer
##############################################################################

RUN set -x \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && /usr/local/bin/composer config -g secure-http false

##############################################################################
# codeception (includes phpunit)
##############################################################################

RUN set -x \
    && composer global require "codeception/codeception:*"

##############################################################################
# phpDocumentor
##############################################################################

RUN set -x \
    && apt-get -q -y install graphviz \
    && pear channel-discover pear.phpdoc.org \
    && pear install phpdoc/phpDocumentor

##############################################################################
# linting
##############################################################################

COPY /_image/RpStandard /usr/local/phpcs/RpStandard
COPY /_image/phpcs-ruleset.xml /usr/local/phpcs/phpcs-ruleset.xml
COPY /_image/phpmd-ruleset.xml /usr/local/phpmd/phpmd-ruleset.xml
COPY /_image/run-phpcs-checks /run-phpcs-checks
COPY /_image/run-phpmd-checks /run-phpmd-checks
COPY /_image/run-phpsyntax-checks /run-phpsyntax-checks

RUN set -x \

    # CodeSniffer
    && cd /usr/local/bin \
    && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && mkdir -p /usr/local/phpcs \

    # Mess Detector
    && cd /usr/local/bin \
    && curl -OL http://static.phpmd.org/php/latest/phpmd.phar \
    && mkdir -p /usr/local/phpmd \

    && chmod +x /usr/local/bin/php*.phar \

    # wrapper scripts
    && chmod 0755 /run-phpcs-checks \
    && chmod 0755 /run-phpmd-checks \
    && chmod 0755 /run-phpsyntax-checks

##############################################################################
# terraform
##############################################################################

RUN set -x \
    && curl -OL https://releases.hashicorp.com/terraform/0.9.4/terraform_0.9.4_linux_amd64.zip \
    && unzip terraform_0.9.4_linux_amd64.zip \
    && /usr/local/bin/terraform \
    && chmod 0755 /usr/local/bin/terraform

##############################################################################
# users
##############################################################################

# Add a dev user and configure all accounts
RUN set -x \
    && groupadd dev \
    && useradd dev -s /bin/bash -m -g dev -G root \
    && echo "dev:password" | chpasswd \
    && echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \

    # powerline config
    && rsync -ac /_image/powerline/ /usr/share/powerline/ \
    && mkdir -p /usr/local/powerline \
    && ln -s /usr/share/powerline/bindings/tmux/powerline.conf /usr/local/powerline/powerline.conf \

    # .dotfiles
    && git clone https://github.com/mkenney/.dotfiles.git /root/.dotfiles \
    && /root/.dotfiles/init.sh \

    && git clone https://github.com/mkenney/.dotfiles.git /home/dev/.dotfiles \
    && chown -R dev:dev /home/dev/.dotfiles \
    && sudo -u dev /home/dev/.dotfiles/init.sh \

    # oracle
    && echo "export ORACLE_HOME=$(echo $ORACLE_HOME)"          | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH)"  | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export TNS_ADMIN=$(echo $TNS_ADMIN)"              | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export CFLAGS=$(echo $CFLAGS)"                    | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export NLS_LANG=$(echo $NLS_LANG)"                | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LANG=$(echo $LANG)"                        | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LANGUAGE=$(echo $LANGUAGE)"                | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LC_ALL=$(echo $LC_ALL)"                    | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export TERM=xterm"                                | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export PATH=$(echo $PATH)"                        | tee /root/.bash_profile >> /home/dev/.bash_profile

##############################################################################
# ~ fin ~
##############################################################################

# cleanup apt cache
# add devenv support scripts
# remove repo resources
RUN set -x \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cp /_image/attach.sh / \
    && cp /_image/build-tags.sh / \
    && cp /_image/init.sh / \
    && rm -rf /_image

USER dev
VOLUME ["/src"]
WORKDIR /src
CMD ["/bin/bash"]
