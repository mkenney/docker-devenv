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
# Users
##############################################################################

# Add a user
COPY tmux.sh /
RUN groupadd developer && \
	useradd developer -s /bin/bash -m -g developer -G root && \
	echo developer:password | chpasswd && \
	echo "developer ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \

# Terminal environment
	mkdir -p /root/src && \
	cd /root/src && \
	git clone https://github.com/mkenney/terminal_config.git && \
	rsync -av terminal_config/ ~/ && \
	rsync -av terminal_config/ ~developer/ && \
	chown -R developer:developer ~developer/ && \
	rm -rf terminal_config/

USER developer
RUN export TERM=xterm
USER root

##############################################################################
# Vim
##############################################################################

RUN apt-get install -y \
	exuberant-ctags \
	vim

##############################################################################
# Init
##############################################################################

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/*

USER developer
VOLUME ["/project"]
WORKDIR  /project
CMD ["/bin/bash"]