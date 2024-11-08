#!/usr/bin/env bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

python3 -m venv ~/.vim/venv
. ~/.vim/venv/bin/activate
pip install pynvim
pip install flake8

vim +PlugInstall +qall > /dev/null
vim +UpdateRemotePlugins +qall > /dev/null

