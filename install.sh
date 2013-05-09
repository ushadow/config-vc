#!/bin/sh

VIMRC=.vimrc
ln -sf $PWD/vim/$VIMRC ~/$VIMRC
echo "Made soft link of $VIMRC"

mkdir -p ~/.vim/autoload ~/.vim/bundle
ln -sf $PWD/vim/pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
echo "Made soft link of ./vim/pathogen.vim"
