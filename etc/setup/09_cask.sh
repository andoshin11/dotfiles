#!/bin/bash

array=(firefox franz alfred caffeine dropbox 1password diskwave clipy chromium gyazo docker-toolbox spotify skype plex-media-server vlc iterm2)

for var in ${array[@]}
do
	brew cask install $var
done
