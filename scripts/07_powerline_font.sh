#!/bin/bash

# Install powerline
mkdir -p $HOME/dev/powerline
git clone https://github.com/powerline/fonts $HOME/dev/powerline
sh $HOME/dev/powerline/install.sh

# Setup theme
fish -c 'fisher add oh-my-fish/theme-bobthefish'
