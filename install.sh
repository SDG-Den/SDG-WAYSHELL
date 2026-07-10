#!/bin/bash

### dependencies
unipkg install any waybar
unipkg install any jq
unipkg install any procps-ng

WORKDIR="$HOME/.cache/SDG-PKG/sdg-wayshell"

cp -r "$WORKDIR/config/"* "$HOME/.config/"
cp -r "$WORKDIR/local/"* "$HOME/.local/"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"

chmod a+x "$HOME/.local/SDG-WAYSHELL/wayshell.sh"
chmod a+x "$HOME/.local/SDG-WAYSHELL/modules/"*.sh

sudo ln -sf "$HOME/.local/SDG-WAYSHELL/wayshell.sh" /usr/bin/wayshell

which wayshell || echo "INSTALL FAILED!"
