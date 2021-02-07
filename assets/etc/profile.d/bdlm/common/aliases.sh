#!/usr/bin/env bash

# typos / shortcuts
alias a="cal"
alias cls='clear'
alias cp='cp -i'
alias csl='clear'
alias e='exit'
alias ed="emacs"
alias em="emacs"
alias iv='vim'
alias ivm='vim'
alias l='ls -1'
alias lcs='clear'
alias ll='ls -l'
alias ls='ls -aF --time-style=+"%a %Y-%m-%d %T" --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias suod='sudo'
alias top='htop -d 5'
alias vi='vim'
alias yes="echo no"

# tools
alias busy='while [ TRUE ]; do head -n 100 /dev/urandom; sleep .05; done | hexdump -C | grep --color=none "ca fe"'
alias cloc="perl ~/.dotfiles/cloc.pl"
alias grep='grep --color=auto'
alias less="less --quit-if-one-screen --ignore-case --status-column --quit-on-intr --LONG-PROMPT --silent --tilde --RAW-CONTROL-CHARS --mouse --save-marks"
alias locate='locate -i'
alias pstree='pstree -ahlpuU'
alias rsync='rsync --progress'
alias sdot='source ~/.bashrc'
