#!/usr/bin/env bash

rsync --archive --verbose \
	--exclude ".git/" \
	--exclude ".DS_Store" \
	--include ".*" \
	--include ".*/**" \
	--exclude '*' \
	. ~/
