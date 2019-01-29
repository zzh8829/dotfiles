#!/bin/bash

sudo apt-get update
sudo apt-get install build-essential cmake zsh

mkdir -p ~/bin

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone git://github.com/zsh-users/zsh-autosuggestion ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# scmpuff
SCMPUFF_TMP=$(mktemp -d)
SCMPUFF_VER=0.2.1
SCMPUFF_TAR=scmpuff_${SCMPUFF_VER}_linux_amd64

curl -L https://github.com/mroth/scmpuff/releases/download/v$SCMPUFF_VER/$SCMPUFF_TAR.tar.gz | tar xzv -C $SCMPUFF_TMP
mv $SCMPUFF_TMP/$SCMPUFF_TAR/scmpuff ~/bin
rm -rf $SCMPUFF_TMP

# neovim
curl -LO https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage ~/bin/nvim

wget https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
sudo dpkg -i ripgrep*.deb
rm ripgrep*.deb

