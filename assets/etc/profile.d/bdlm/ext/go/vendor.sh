#!/usr/bin/env bash

function __ext_go_vendor {
    go mod tidy -v && go mod vendor -v
}
