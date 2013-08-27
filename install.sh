#!/bin/bash

# awesome
AWESOME_DIR=~/.config/awesome
mkdir -p $AWESOME_DIR
ln -sf $PWD/awesome/rc.lua $AWESOME_DIR/rc.lua
ln -sf $PWD/awesome/volume.lua $AWESOME_DIR/volume.lua
if [ ! -d $AWESOME_DIR/themes ]; then
  ln -sf $PWD/awesome/themes $AWESOME_DIR/themes
fi
echo "Made soft links for awesome config files."

# vim
VIMRC=.vimrc
ln -sf $PWD/vim/$VIMRC ~/$VIMRC
echo "Made soft link of $VIMRC"

VIM_DIR=.vim

if [ $OSTYPE == 'msys' ]; then
  VIM_DIR=vimfiles
fi

mkdir -p ~/$VIM_DIR/autoload ~/$VIM_DIR/bundle

PATHOGEN=$PWD/vim/pathogen/autoload/pathogen.vim
PATHOGEN_LINK=~/$VIM_DIR/autoload/pathogen.vim

ln -sf $PATHOGEN $PATHOGEN_LINK
echo "Made sym link $PATHOGEN_LINK -> $PATHOGEN"
