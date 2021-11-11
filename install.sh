#!/bin/sh

set -ex

if type git &> /dev/null; then
	echo "Git Found"
elif type apt-get &> /dev/null; then
	sudo apt-get update
	sudo apt-get install -yyq git
elif type yum &> /dev/null; then
	sudo yum update
	sudo yum install -y git
else
	echo "Could not find or install git"
	exit 1
fi

cd ~
rm -rf ~/.dotfiles

if ssh -T git@github.com 2> /dev/null; [ $? -eq 1]; then
	git clone git@github.com:zzh8829/dotfiles .dotfiles
else
	git clone https://github.com/zzh8829/dotfiles .dotfiles
fi

cd .dotfiles
