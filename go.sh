#!/usr/bin/env bash

if [[ $OS == 'linux' || $OS == 'wsl' ]]; then
    sudo apt-get install go
elif [[ $OS == 'macos' ]]; then
    brew install go
else
    echo 'Unknonw OS skipping go install'
fi

go get -u github.com/sourcegraph/go-langserver
