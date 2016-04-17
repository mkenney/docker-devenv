#!/usr/bin/env bash

for a in $(ls -1 $HOME/.bash/); do
    if [ -f "$HOME/.bash/$a" ]; then
        source $HOME/.bash/$a
    fi
done
