#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -yyq software-properties-common build-essential cmake zsh git

mkdir -p ~/bin

# zsh
OMZSH_TMP=$(mktemp)
curl -Lo $OMZSH_TMP https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
rm -rf ~/.oh-my-zsh
sh $OMZSH_TMP --unattended
rm $OMZSH_TMP

# zsh autosuggestions
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# scmpuff
SCMPUFF_TMP=$(mktemp -d)
SCMPUFF_VER=0.2.1
SCMPUFF_TAR=scmpuff_${SCMPUFF_VER}_linux_amd64

curl -L https://github.com/mroth/scmpuff/releases/download/v$SCMPUFF_VER/$SCMPUFF_TAR.tar.gz | tar xzv -C $SCMPUFF_TMP
mv $SCMPUFF_TMP/$SCMPUFF_TAR/scmpuff ~/bin
rm -rf $SCMPUFF_TMP

# neovim
if ! type nvim &> /dev/null ]]; then
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt-get update
	sudo apt-get install -yyq neovim
	# curl -LO https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage
	# chmod u+x nvim.appimage
	# mv nvim.appimage ~/bin/nvim
fi

# rg
wget https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
sudo dpkg -i ripgrep*.deb
rm ripgrep*.deb

# tmux
mkdir -p ~/.tmux/plugins
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

