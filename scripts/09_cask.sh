#!/bin/bash

installed=`brew cask list`

for app in `cat ./etc/cask_list.txt`; do
    if [[ -z `echo "${installed}" | grep "^${app}$"` ]]; then
	echo "$(tput setaf 4)Installing ${app}...$(tput sgr0)"
        brew cask install $app
        echo "$(tput setaf 2)Installed ${app}!$(tput sgr0)"
    else
        echo "$(tput setaf 3)${app} is already installed. $(tput sgr0)"
    fi
done

