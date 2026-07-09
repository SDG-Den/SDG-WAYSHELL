#!/bin/bash

rm -rf $HOME/.local/SDG-WAYSHELL
cp -r $HOME/.cache/SDG-PKG/sdg-wayshell/local/* $HOME/.local
sudo ln -sf $HOME/.local/SDG-WAYSHELL/wayshell.sh /usr/bin/wayshell

rm -rf $HOME/.local/docs/SDG-WAYSHELL
rm -rf $HOME/.local/tips/SDG-WAYSHELL
mkdir -p $HOME/.local/docs
mkdir -p $HOME/.local/tips
cp -r $HOME/.cache/SDG-PKG/sdg-wayshell/docs/* $HOME/.local/docs
cp -r $HOME/.cache/SDG-PKG/sdg-wayshell/tips/* $HOME/.local/tips
