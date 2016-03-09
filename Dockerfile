FROM debian:latest

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOSTNAME 'dev-env'
USER root
RUN apt-get update

##############################################################################
# System logger
##############################################################################

RUN apt-get install -y rsyslog && \
	rm -rf /var/run/rsyslogd.pid && \
	exec /usr/sbin/rsyslogd

##############################################################################
# Locale
##############################################################################

# UTF-8 locale
RUN apt-get install -y \
		apt-utils \
		locales && \

	locale-gen en_US.UTF-8 en_us && \
	dpkg-reconfigure locales && \
	dpkg-reconfigure locales && \
	locale-gen C.UTF-8 && \
	/usr/sbin/update-locale LANG=C.UTF-8

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

##############################################################################
# PHP
##############################################################################

RUN apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng12-dev \
	libbz2-dev \
	php5-cli \
	php5-gd \
	php5-mcrypt \
	php-pear

# PHP configurations
ENV PHP_INI_DIR '/etc/php5/cli'
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini && \
	echo "date.timezone=${PHP_TIMEZONE:-UTC}" > $PHP_INI_DIR/conf.d/date_timezone.ini

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
# Apps
##############################################################################

RUN apt-get install -y \
	git \
	htop \
	less \
	php-pear \
	rsync \
	sudo \
	tcpdump \
	telnet \
	tmux \
	unzip \
	wget

##############################################################################
# Vim
##############################################################################

RUN apt-get install -y \
	exuberant-ctags \
	vim

RUN pear install --alldeps php_codesniffer && \
	composer global require phpmd/phpmd

##############################################################################
# Users
##############################################################################

# Add a user
COPY container/init.sh /
RUN groupadd developer && \
	useradd developer -s /bin/bash -m -g developer -G root && \
	echo developer:password | chpasswd && \
	echo "developer ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \

# Terminal environment
	mkdir -p /root/src && \
	cd /root/src && \
	git clone https://github.com/mkenney/terminal_config.git && \
	cd terminal_config/ && \
	git submodule update --init --recursive && \
	cd ../ && \
	rsync -av terminal_config/ ~/ && \
	rsync -av terminal_config/ ~developer/ && \
	chown -R developer:developer ~developer/ && \
	rm -rf terminal_config/ && \
	/usr/bin/vim +BundleInstall +qall > /dev/null

USER developer
RUN export TERM=xterm && \
	/usr/bin/vim +BundleInstall +qall > /dev/null
USER root

##############################################################################
# Init
##############################################################################

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/*

USER developer
RUN export PATH=/root/.composer/vendor/bin:$PATH

VOLUME ["/project"]
WORKDIR /project
CMD ["/bin/bash"]