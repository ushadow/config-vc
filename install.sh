#!/bin/sh

VIMRC=.vimrc
ln -sf $PWD/vim/$VIMRC ~/$VIMRC
echo "Made soft link of $VIMRC"

VIM_DIR=.vim

if [[ $OSTYPE == 'msys' ]]; then
  VIM_DIR=vimfiles
fi

mkdir -p ~/$VIM_DIR/autoload ~/$VIM_DIR/bundle

PATHOGEN=$PWD/vim/pathogen/autoload/pathogen.vim 
PATHOGEN_LINK=~/$VIM_DIR/autoload/pathogen.vim

ln -sf $PATHOGEN $PATHOGEN_LINK
echo "Made sym link $PATHOGEN_LINK -> $PATHOGEN"
