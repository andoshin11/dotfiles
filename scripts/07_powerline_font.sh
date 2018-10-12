#!/bin/bash

# Install powerline
git clone https://github.com/powerline/fonts ~$PWD/tmp
sh $PWD/tmp/install.sh
rm $PWD/tmp/install.sh

# Setup theme
fish -c 'fisher add oh-my-fish/theme-bobthefish'
