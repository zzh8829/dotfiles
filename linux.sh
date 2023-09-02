#!/usr/bin/env bash

set -xe

if type apt-get &> /dev/null; then
	PM=apt-get
	sudo apt-get update
	sudo apt-get install -yyq software-properties-common build-essential cmake zsh stow
elif type yum &> /dev/null; then
	PM=yum
	sudo yum update
	sudo yum install zsh git stow
else
	echo "What linux is this"
	exit 1
fi


mkdir -p ~/bin

# zsh
OMZSH_TMP=$(mktemp)
curl -Lo $OMZSH_TMP https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
rm -rf ~/.oh-my-zsh
sh $OMZSH_TMP --unattended
rm $OMZSH_TMP

# zsh autosuggestions
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# scmpuff
SCMPUFF_TMP=$(mktemp -d)
SCMPUFF_VER=0.3.0
SCMPUFF_TAR=scmpuff_${SCMPUFF_VER}_linux_x64

curl -L https://github.com/mroth/scmpuff/releases/download/v$SCMPUFF_VER/$SCMPUFF_TAR.tar.gz | tar xzv -C $SCMPUFF_TMP
mv $SCMPUFF_TMP/scmpuff ~/bin
rm -rf $SCMPUFF_TMP

# neovim
if ! type nvim &> /dev/null; then
	if [[ $PM = 'apt-get' ]]; then
		sudo add-apt-repository -y ppa:neovim-ppa/stable && \
			sudo apt-get update && \
			sudo apt-get install -yyq neovim
	fi
	# curl -LO https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage
	# chmod u+x nvim.appimage
	# mv nvim.appimage ~/bin/nvim
fi

# rg
if [[ $PM = 'apt-get' ]]; then
	wget https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
	sudo dpkg -i ripgrep*.deb || true 
	rm ripgrep*.deb
else
	sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
	sudo yum -y install ripgrep
fi

# tmux
mkdir -p ~/.tmux/plugins
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

