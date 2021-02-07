#!/usr/bin/env bash

export __ext_go_commands="bug build clean doc env fix fmt generate get install list mod run test tool version vet"
export __ext_go_custom_commands="vendor"
complete -o default -W "${__ext_go_commands} ${__ext_go_custom_commands}" go
