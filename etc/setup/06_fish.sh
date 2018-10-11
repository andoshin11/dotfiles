#!/bin/bash

brew install fish
sudo sh -c "echo '/usr/local/bin/fish' >> /etc/shells"
sudo chsh -s /usr/local/bin/fish

# Install fisherman
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher

# deploy config file
ln -sfvn $PWD/config.fish $HOME/.config/fish/config.fish
