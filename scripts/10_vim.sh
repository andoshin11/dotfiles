#!/bin/bash

# Install dein.vim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > tmp/installer.sh
mkdir -p $HOME/.vim/dein
sh tmp/installer.sh $HOME/.vim/dein
rm tmp/installer.sh

# Required options
mkdir $HOME/.vim/backup

