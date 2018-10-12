#!/bin/bash

mkdir -p $HOME/.ssh
ssh-keygen -f $HOME/.ssh/id_rsa
cp $PWD/etc/ssh/config $HOME/.ssh/config

