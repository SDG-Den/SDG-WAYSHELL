#!/bin/bash

### dependencies
unipkg install any waybar
unipkg install any jq
unipkg install any procps-ng

# set working directory
WORKDIR=/home/$(whoami)/.cache/SDG-PKG/sdg-wayshell

# install default configs
cp -r $WORKDIR/config/* /home/$(whoami)/.config

# install binaries
cp -r $WORKDIR/local/* /home/$(whoami)/.local

# install docs and tips
mkdir -p /home/$(whoami)/.local/docs
mkdir -p /home/$(whoami)/.local/tips
cp -r $WORKDIR/docs/* /home/$(whoami)/.local/docs
cp -r $WORKDIR/tips/* /home/$(whoami)/.local/tips

# make entrypoint executable
chmod a+x /home/$(whoami)/.local/SDG-WAYSHELL/wayshell.sh
chmod a+x /home/$(whoami)/.local/SDG-WAYSHELL/modules/*.sh

# symlink entrypoint
sudo ln -sf /home/$(whoami)/.local/SDG-WAYSHELL/wayshell.sh /usr/bin/wayshell

# verify binary
which wayshell || echo "INSTALL FAILED!"
