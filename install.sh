#!/bin/bash

ln -sf $PWD/.bash_aliases ~/.bash_aliases

# link awesome files
AWESOME_DIR=~/.config/awesome
mkdir -p $AWESOME_DIR
ln -sf $PWD/awesome/rc.lua $AWESOME_DIR/rc.lua
ln -sf $PWD/awesome/volume.lua $AWESOME_DIR/volume.lua
if [ ! -d $AWESOME_DIR/themes ]; then
  ln -sf $PWD/awesome/themes $AWESOME_DIR/themes
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
