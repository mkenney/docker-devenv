# MIT License
#
# Copyright (c) 2016 Michael Kenney
# Copyright (c) 2021 Bedlam Software
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
FROM ubuntu:20.04
LABEL org.label-schema.description="This service provides a flexible base image for linux development environments." \
    org.label-schema.license="MIT" \
    org.label-schema.name="bdlm/dev" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/bdlm/dev/blob/master/README.md" \
    org.label-schema.vcs-url="https://github.com/bdlm/dev" \
    org.label-schema.vendor="bdlm@webbedlam.com"

# Global configurations
WORKDIR /tmp
ENV DEBIAN_FRONTEND=noninteractive \
    __IS_DEVENV=true \
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
RUN mkdir -p /src \
    && apt-get -qq update \
    && apt-get install -qqy apt-utils \
    && apt-get -qq upgrade \
    && apt-get -qq dist-upgrade

# Main apt-get installs
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 0xE0C56BD4 \
    && echo "deb http://repo.yandex.ru/clickhouse/deb/stable/ main/" | tee /etc/apt/sources.list.d/clickhouse.list \
    && apt-get update
RUN apt-get install -qqy \
        autogen \
        automake \
        bash-completion \
        build-essential \
        clickhouse-client \
        cmake \
        curl \
        default-jdk \
        dialog \
        docker.io \
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
        postgresql-client \
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
        wget

# Golang
RUN apt-get remove golang \
    && apt-get autoremove \
    && wget -c https://golang.org/dl/go1.15.8.linux-amd64.tar.gz \
    && shasum -a 256 go1.15.8.linux-amd64.tar.gz \
    && tar -C /usr/local -xvzf go1.15.8.linux-amd64.tar.gz \
    && ln -s /usr/local/go/bin/go /usr/local/bin/go \
    && ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# Node and Npm tools
RUN npm install -g \
    bower \
    grunt-cli \
    gulp-cli \
    markdown-styles \
    typescript

# Latest Vim from source
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
    && update-alternatives --set vi /usr/local/bin/vim

# Current Tmux from source
RUN curl -OL https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz \
    && tar xf tmux-2.4.tar.gz \
    && cd tmux-2.4 \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -f tmux-2.4.tar.gz \
    && rm -rf tmux-2.4

# Oracle instantclient - don't poke it...
ENV ORACLE_HOME=/usr/lib/oracle/11.2/client64
ENV LD_LIBRARY_PATH=${ORACLE_HOME}/lib
ENV TNS_ADMIN=/home/dev/.oracle/network/admin
ENV CFLAGS="-I/usr/include/oracle/11.2/client64/"
ENV NLS_LANG=American_America.AL32UTF8
COPY assets/oracle/oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb /tmp/oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb
COPY assets/oracle/oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb /tmp/oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb
COPY assets/oracle/oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb /tmp/oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb
RUN set -x \
    && groupadd dba -g 201 -o \
    && useradd oracle -u 102 -o -s /bin/bash -m -g dba \
    && echo "oracle:password" | chpasswd \
    && dpkg -i oracle-instantclient11.2-basic_11.2.0.3.0-2_amd64.deb \
    && dpkg -i oracle-instantclient11.2-devel_11.2.0.3.0-2_amd64.deb \
    && dpkg -i oracle-instantclient11.2-sqlplus_11.2.0.3.0-2_amd64.deb \
    && mkdir -p /oracle/product \
    && ln -s $ORACLE_HOME /oracle/product/latest \
    && mkdir -p /oracle/product/latest/network/admin

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
COPY assets/usr/share/powerline/ /usr/share/powerline/
RUN mkdir -p /usr/local/powerline \
    && ln -s /usr/share/powerline/bindings/tmux/powerline.conf /usr/local/powerline/powerline.conf

# Fetch/configure various resources
RUN set -x \
    && mkdir -p /usr/local/src \
    && git clone https://github.com/bdlm/.bdlm.git /usr/local/src/github.com/bdlm/.bdlm \
    && sed -i'' 's/C-space/M-space/g' /usr/local/src/github.com/bdlm/.bdlm/tmux/.tmux.conf
COPY assets/usr/local/src/github.com/bdlm/.bdlm/prompt/prompt.sh /usr/local/src/github.com/bdlm/.bdlm/prompt/prompt.sh

# Configure user shells
# do this in the user home directory, most scripts use either $HOME or ~ in some way.
RUN set -x \
    # initialize bdlm shell configurations
    && ln -s /usr/local/src/github.com/bdlm/.bdlm /root/.bdlm \
    && /root/.bdlm/init.sh --force \
    # compile YouCompleteMe Vim plugin
    && cd /root/.vim/bundle/YouCompleteMe \
    && ./install.py \
    && cd /root/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/tern_runtime \
    && npm install --production

# Configure user account
RUN set -x \
    # Add a dev user
    && groupadd dev \
    && useradd dev -s /bin/bash -m -g dev -G root \
    # password
    && echo "dev:password" | chpasswd \
    # sudo
    && echo "dev ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
    # golang
    && mkdir -p /home/dev/go \
    # docker
    && usermod -aG docker dev \
    # shell configuration
    && ln -s /usr/local/src/github.com/bdlm/.bdlm /home/dev/.bdlm \
    && sudo -u dev /home/dev/.bdlm/init.sh --force

# per-user pip installs
RUN set -x \
    # awscli
    && pip3 install --upgrade --user awscli \
    && sudo -u dev pip3 install --upgrade --user awscli

# SSH keys and mount scripts
COPY assets/network /home/dev/network
COPY assets/network/sshd_config /etc/ssh/sshd_config
COPY assets/network/mountenv /usr/local/bin/
COPY assets/network/umountenv /usr/local/bin/
RUN set -x \
    # SSH keys used for communicating between containers
    && chown -R dev:dev /home/dev/network \
    && /etc/init.d/ssh start \
    # sshfs wrapper scripts
    && chmod 0755 /usr/local/bin/mountenv \
    && chmod 0755 /usr/local/bin/umountenv \
    && chmod 777 /mnt

# Configure environments
ENV K8S_STATUS_LINE=disabled
RUN echo "set tags=/src/tags.devenv,./tags.devenv"             | tee /root/.vimrc        >> /home/dev/.vimrc        \
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

# load support scripts and resources
# generate the locate database
# cleanup apt-get cache
# add devenv support scripts
# remove repo resources
COPY bin/dev /usr/local/bin/dev
COPY assets/attach.sh /attach.sh
COPY assets/build-tags.sh /build-tags.sh
COPY assets/init.sh /init.sh
RUN updatedb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

USER dev
VOLUME ["/src"]
WORKDIR /src
CMD ["/bin/bash"]
