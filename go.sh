#!/usr/bin/env bash

if [[ $OS == 'linux' || $OS == 'wsl' ]]; then
    sudo apt-get install go
elif [[ $OS == 'macos' ]]; then
    brew install go
else
    echo 'Unknonw OS skipping go install'
fi

GO111MODULE=on go get golang.org/x/tools/gopls@latest
