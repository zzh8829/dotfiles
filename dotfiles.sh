#!/usr/bin/env bash

# rsync --archive --verbose \
# 	--exclude ".git/" \
# 	--exclude ".gitkeep" \
# 	--exclude ".DS_Store" \
# 	--include ".*" \
# 	--include ".*/**" \
# 	--exclude '*' \
# 	"$@" \
# 	. ~/

stow --adopt --verbose \
	bin \
	conda \
	editorconfig \
	eslint \
	gcloud \
	git \
	ipython \
	matplotlib \
	pylint \
	tmux \
	vim \
	zsh \
