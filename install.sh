#!/bin/sh

set -ex

if type git &> /dev/null; then
  echo "Git Found"
if type apt-get &> /dev/null; then
	sudo apt-get update
	sudo apt-get install -yyq git
elif type yum &> /dev/null; then
	sudo yum update
	sudo yum install git
else
	echo "Could not find or install git"
	exit 1
fi

cd ~
rm -rf ~/.dotfiles
git clone git@github.com:zzh8829/dotfiles .dotfiles
cd .dotfiles
