#!/bin/bash

### dependencies
unipkg install any waybar
unipkg install any jq
unipkg install any procps-ng

# set working directory
WORKDIR=$HOME/.cache/SDG-PKG/sdg-wayshell

# install default configs
cp -r $WORKDIR/config/* $HOME/.config

# install binaries
cp -r $WORKDIR/local/* $HOME/.local

# install docs and tips
mkdir -p $HOME/.local/docs
mkdir -p $HOME/.local/tips
cp -r $WORKDIR/docs/* $HOME/.local/docs
cp -r $WORKDIR/tips/* $HOME/.local/tips

# make entrypoint executable
chmod a+x $HOME/.local/SDG-WAYSHELL/wayshell.sh
chmod a+x $HOME/.local/SDG-WAYSHELL/modules/*.sh

# symlink entrypoint
sudo ln -sf $HOME/.local/SDG-WAYSHELL/wayshell.sh /usr/bin/wayshell

# verify binary
which wayshell || echo "INSTALL FAILED!"

