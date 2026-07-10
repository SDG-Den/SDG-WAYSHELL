#!/bin/bash

WORKDIR="$HOME/.cache/SDG-PKG/sdg-wayshell"

rm -rf "$HOME/.local/SDG-WAYSHELL"
cp -r "$WORKDIR/local/"* "$HOME/.local/"

rm -rf "$HOME/.local/docs/SDG-WAYSHELL" "$HOME/.local/tips/SDG-WAYSHELL"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"

sudo ln -sf "$HOME/.local/SDG-WAYSHELL/wayshell.sh" /usr/bin/wayshell
