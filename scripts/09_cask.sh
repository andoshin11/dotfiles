#!/bin/bash

for app in `cat ./etc/cask_list.txt`; do
    echo "Installing ${app}..."
    brew cask install $app
done

