#!/usr/bin/env bash

cd ~/Repos
git clone https://github.com/Valloric/ycmd.git
cd ycmd
git submodule update --init --recursive
./build.py --clang-completer

rsync --archive --verbose \
	--include "*sublime*" \
	--exclude '*' \
	data/sublime/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/


