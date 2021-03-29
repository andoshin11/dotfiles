#!/bin/bash

brew install nodebrew
mkdir -p  $HOME/.nodebrew/src
nodebrew install-binary stable
nodebrew use $(nodebrew list | head -n1)

$HOME/.nodebrew/current/bin/npm install -g yarn
