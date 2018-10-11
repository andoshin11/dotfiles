#!/bin/bash

# Install powerline
mkdir -p ~/dev/powerline
git clone https://github.com/powerline/fonts ~/dev/powerline/
sh ~/dev/powerline/install.sh

# Setup theme
fish -c 'fisher add oh-my-fish/theme-bobthefish'
