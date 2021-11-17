#!/usr/bin/env bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip3 install neovim

vim +PlugInstall +qall > /dev/null
