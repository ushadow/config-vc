#!/bin/bash

ln -sf $PWD/.bash_aliases ~/.bash_aliases
ln -sf $PWD/.xinitrc ~/.xinitrc

# link awesome files
AWESOME_DIR=~/.config/awesome
if [ ! -d $AWESOME_DIR ]; then
  ln -sf $PWD/awesome $AWESOME_DIR
fi
echo "Made sym links for awesome config files."

# link vim files
VIMRC=.vimrc
ln -sf $PWD/vim/$VIMRC ~/$VIMRC
echo "Made a sym link of $VIMRC"

VIM_DIR=.vim

if [ $OSTYPE == 'msys' ]; then
  VIM_DIR=vimfiles
fi

mkdir -p $VIM_DIR
BUNDLE_DIR=~/$VIM_DIR/bundle 
if [ ! -d $BUNDLE_DIR ]; then
  ln -sf $PWD/vim/bundle $BUNDLE_DIR 
fi

mkdir -p ~/$VIM_DIR/autoload 
PATHOGEN=$PWD/vim/pathogen/autoload/pathogen.vim
PATHOGEN_LINK=~/$VIM_DIR/autoload/pathogen.vim

ln -sf $PATHOGEN $PATHOGEN_LINK
echo "Made sym link $PATHOGEN_LINK -> $PATHOGEN"
