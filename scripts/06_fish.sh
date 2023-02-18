#!/bin/bash

brew install fish
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
sudo chsh -s /opt/homebrew/bin/fish

# Install fisherman
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher

# deploy config file
ln -sfvn $PWD/config.fish $HOME/.config/fish/config.fish
