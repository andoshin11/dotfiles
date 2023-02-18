#!/bin/bash

mkdir -p $HOME/.ssh
cp $PWD/etc/ssh/config $HOME/.ssh/config
chmod 600 $HOME/.ssh/config
