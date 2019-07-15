#!/usr/bin/env bash

rsync --archive --verbose \
	--include "*sublime*" \
	--exclude '*' \
	data/sublime/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/
