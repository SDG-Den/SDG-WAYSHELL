#!/bin/bash

rm -rf /home/$(whoami)/.local/SDG-WAYSHELL
cp -r /home/$(whoami)/.cache/SDG-PKG/sdg-wayshell/local/* /home/$(whoami)/.local
sudo ln -sf /home/$(whoami)/.local/SDG-WAYSHELL/wayshell.sh /usr/bin/wayshell

rm -rf /home/$(whoami)/.local/docs/SDG-WAYSHELL
rm -rf /home/$(whoami)/.local/tips/SDG-WAYSHELL
mkdir -p /home/$(whoami)/.local/docs
mkdir -p /home/$(whoami)/.local/tips
cp -r /home/$(whoami)/.cache/SDG-PKG/sdg-wayshell/docs/* /home/$(whoami)/.local/docs
cp -r /home/$(whoami)/.cache/SDG-PKG/sdg-wayshell/tips/* /home/$(whoami)/.local/tips
