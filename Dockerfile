#
# MIT License
#
# Copyright (c) 2017 Michael Kenney
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
FROM ubuntu:20.04
LABEL org.label-schema.description="This service provides a flexible base for linux development environments." \
    org.label-schema.license="MIT"\
    org.label-schema.name="DevEnv" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/bdlm/.bdlmrc/blob/master/README.md" \
    org.label-schema.vcs-url="https://github.com/bdlm/.bdlmrc" \
    org.label-schema.vendor="mkenney@webbedlam.com"

# Load support scripts and resources
COPY bin/dev /usr/local/bin/dev
COPY assets /tmp/assets

# Global configurations
WORKDIR /tmp
ENV DEBIAN_FRONTEND=noninteractive \
    IS_DEVENV=true \
    HOSTNAME=devenv \
    PATH=/root/bin:$PATH \
    TERM=xterm-256color \
    TIMEZONE=America/Denver

# UTF-8 Locales
RUN apt-get update \
    && apt-get install -qqy --no-install-recommends \
        debconf \
        gettext \
        gnupg  \
        locales \
        netbase
COPY assets/etc/locale.gen /etc/locale.gen
COPY assets/etc/default/locale /etc/default/locale
RUN locale-gen \
    && dpkg-reconfigure locales
ENV UTF8_LOCALE=en_US \
    LC_CTYPE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Upgrades
RUN cd / \
    && mkdir -p /src \
    && apt-get -qq update \
    && apt-get install -qqy apt-utils \
    && apt-get -qq upgrade \
    && apt-get -qq dist-upgrade

# Main apt-get installs
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 0xE0C56BD4 \
    && echo "deb http://repo.yandex.ru/clickhouse/deb/stable/ main/" | tee /etc/apt/sources.list.d/clickhouse.list \
    && apt-get update
RUN set -x \
    && apt-get install -qqy \
        autogen \
        automake \
        build-essential \
        clickhouse-client \
        cmake \
        curl \
        default-jdk \
        dialog \
        exuberant-ctags \
        gcc \
        git \
        graphviz \
        htop \
        iputils-ping \
        less \
        libaio1 \
        libbz2-dev \
        libevent-dev \
        libfreetype6-dev \
        libmcrypt-dev \
        libncurses5-dev \
        libpq-dev \
        libyaml-dev \
        locate \
        man \
        mono-complete \
        mysql-client \
        ncurses-dev \
        nodejs \
        npm \
        openssh-client \
        openssh-server \
        php \
        powerline \
        python3 \
        python3-dev \
        python3-pip \
        python3-powerline \
        rsync \
        rsyslog \
        ruby \
        ruby-dev \
        sbcl \
        silversearcher-ag \
        slime \
        sshfs \
        sudo \
        tcpdump \
        telnet \
        unzip \
        vim-nox \
        wget \
    # Golang
    && apt-get remove golang \
    && apt-get autoremove \
    && wget -c https://golang.org/dl/go1.15.2.linux-amd64.tar.gz \
    && shasum -a 256 go1.15.2.linux-amd64.tar.gz \
    && tar -C /usr/local -xvzf go1.15.2.linux-amd64.tar.gz

# npm and node tools
RUN npm install -g \
    bower \
    grunt-cli \
    gulp-cli \
    markdown-styles \
    typescript

# Latest vim from source
RUN git clone https://github.com/vim/vim \
    && cd vim \
    && make distclean \
    && ./configure \
        --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --with-python3-config-dir=$(python3-config --configdir) \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr/local \
    && make \
    && make install \
    && update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1 \
    && update-alternatives --set editor /usr/local/bin/vim \
    && update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1 \
    && update-alternatives --set vi /usr/local/bin/vim \
    && vim --version

# Current tmux from source
RUN curl -OL https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz \
    && tar xf tmux-2.4.tar.gz \
    && cd tmux-2.4 \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -f tmux-2.4.tar.gz \
    && rm -rf tmux-2.4

# Oracle instantclient
ENV ORACLE_VERSION_LONG=11.2.0.3.0-2
ENV ORACLE_VERSION_SHORT=11.2
ENV ORACLE_HOME=/usr/lib/oracle/${ORACLE_VERSION_SHORT}/client64
ENV LD_LIBRARY_PATH=${ORACLE_HOME}/lib
ENV TNS_ADMIN=/home/dev/.oracle/network/admin
ENV CFLAGS="-I/usr/include/oracle/${ORACLE_VERSION_SHORT}/client64/"
ENV NLS_LANG=American_America.AL32UTF8
COPY oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb /tmp/oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb
COPY oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb /tmp/oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb
COPY oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb /tmp/oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb
RUN set -x \
    && groupadd dba -g 201 -o \
    && useradd oracle -u 102 -o -s /bin/bash -m -g dba \
    && echo "oracle:password" | chpasswd \
    && cd /tmp \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-basic_${ORACLE_VERSION_LONG}_amd64.deb \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-devel_${ORACLE_VERSION_LONG}_amd64.deb \
    && dpkg -i oracle-instantclient${ORACLE_VERSION_SHORT}-sqlplus_${ORACLE_VERSION_LONG}_amd64.deb \
    && mkdir -p /oracle/product \
    && ln -s $ORACLE_HOME /oracle/product/latest \
    && mkdir -p /oracle/product/latest/network/admin \
    && rm -f /oracle-instantclient${ORACLE_VERSION_SHORT}-basic_${ORACLE_VERSION_LONG}_amd64.deb \
    && rm -f /oracle-instantclient${ORACLE_VERSION_SHORT}-devel_${ORACLE_VERSION_LONG}_amd64.deb \
    && rm -f /oracle-instantclient${ORACLE_VERSION_SHORT}-sqlplus_${ORACLE_VERSION_LONG}_amd64.deb

# Kubernetes support
RUN set -x \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Terraform
RUN set -x \
    && curl -OL https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_amd64.zip \
    && unzip terraform_0.14.6_linux_amd64.zip \
    && mv terraform /usr/local/bin/terraform \
    && chmod 0755 /usr/local/bin/terraform \
    && rm -f terraform_0.14.6_linux_amd64.zip

# Powerline config
COPY assets/powerline/ /usr/share/powerline/
RUN mkdir -p /usr/local/powerline \
    && ln -s /usr/share/powerline/bindings/tmux/powerline.conf /usr/local/powerline/powerline.conf

# PostgreSQL support
RUN apt-get install -qqy postgresql-client

# MySQL / MariaDB support
RUN apt-get install -qqy mysql-client

# Fetch/configure various resources
RUN set -x \
    && mkdir -p /root/src/github.com/mkenney \
    && git clone https://github.com/bdlm/didyoumean.git /root/src/github.com/bdlm/didyoumean \
    && git clone https://github.com/bdlm/didyoumean.git /root/src/github.com/bdlm/.bdlmrc \
    && git clone https://github.com/mkenney/git-import.git /root/src/github.com/mkenney/git-import \
    && git clone https://github.com/mkenney/.dotfiles.git /root/src/github.com/mkenney/.dotfiles

# Configure user shells
RUN set -x \
    && cp -f /tmp/assets/etc/profile /etc/profile \
    #
    && cp -R /root/src/github.com/mkenney/.dotfiles /root/.dotfiles \
    && cd /root \
    && cd .dotfiles \
    && git submodule update --init --recursive \
    # initialize shell scripts
    && cd /root \
    && ./.dotfiles/init.sh \
    # YouCompleteMe support
    && cd /root/.vim/bundle/YouCompleteMe \
    && ./install.py \
    && cd /root/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/tern_runtime \
    && npm install --production \
    # YouCompleteMe support
    && rsync -a /root/.dotfiles/ /root/src/github.com/mkenney/.dotfiles/

# Configure user account
RUN set -x \
    # Add a dev user
    && groupadd dev \
    && useradd dev -s /bin/bash -m -g dev -G root \
    && echo "dev:password" | chpasswd \
    && echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir -p /home/dev/go \
    # .dotfiles
    && rsync -a /root/.dotfiles/ /home/dev/.dotfiles/ \
    && chown -R dev:dev /home/dev/.dotfiles \
    && cd /home/dev \
    && sudo -u dev ./.dotfiles/init.sh

# per-user pip installs
RUN set -x \
    # awscli
    && pip3 install --upgrade --user awscli \
    && sudo -u dev pip3 install --upgrade --user awscli


# SSH keys and mount scripts
RUN set -x \
    # SSH keys used for communicating between containers
    && cp -R /tmp/assets/network /home/dev/network \
    && chown -R dev:dev /home/dev/network \
    && cp -f /tmp/assets/network/sshd_config /etc/ssh/sshd_config \
    && /etc/init.d/ssh start \
    # sshfs wrapper scripts
    && cp -f /tmp/assets/network/mountenv /usr/local/bin \
    && chmod 0755 /usr/local/bin/mountenv \
    && cp -f /tmp/assets/network/umountenv /usr/local/bin \
    && chmod 0755 /usr/local/bin/umountenv \
    && chmod 777 /mnt

# Configure environments
ENV K8S_STATUS_LINE=disabled
RUN echo "set tags=/src/tags.devenv,./tags.devenv"          | tee /root/.vimrc        >> /home/dev/.vimrc        \
    && echo "export ORACLE_HOME=$(echo $ORACLE_HOME)"          | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH)"  | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export TNS_ADMIN=$(echo $TNS_ADMIN)"              | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export CFLAGS=$(echo $CFLAGS)"                    | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export NLS_LANG=$(echo $NLS_LANG)"                | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LANG=$(echo $LANG)"                        | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LANGUAGE=$(echo $LANGUAGE)"                | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export LC_ALL=$(echo $LC_ALL)"                    | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export TERM=$(echo $TERM)"                        | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export PATH=\$PATH:$(echo $PATH)"                 | tee /root/.bash_profile >> /home/dev/.bash_profile \
    && echo "export K8S_STATUS_LINE=disabled"                  | tee /root/.bash_profile >> /home/dev/.bash_profile

##############################################################################
# ~ fin ~
##############################################################################

# generate the initial locate database
# cleanup apt-get cache
# add devenv support scripts
# remove repo resources
RUN updatedb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cp /tmp/assets/attach.sh / \
    && cp /tmp/assets/build-tags.sh / \
    && cp /tmp/assets/init.sh / \
    && rm -rf /tmp/assets

USER dev
VOLUME ["/src"]
WORKDIR /src
CMD ["/bin/bash"]
