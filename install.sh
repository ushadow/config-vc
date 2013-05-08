#!/bin/sh

VIMRC=.vimrc
ln -sf $PWD/vim/$VIMRC ~/$VIMRC
echo "Made soft link of $VIMRC"
