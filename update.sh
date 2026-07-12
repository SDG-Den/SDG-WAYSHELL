#!/bin/bash

WORKDIR="$HOME/.cache/SDG-PKG/sdg-wayshell"

rm -rf "$HOME/.local/SDG-WAYSHELL"
cp -r "$WORKDIR/local/"* "$HOME/.local/"

rm "$HOME/.local/matugen/01-wayshell.toml"
mkdir -p "$HOME/.local/matugen"
cp -r "$WORKDIR/matugen/"* "$HOME/.local/matugen/"

rm -rf "$HOME/.local/docs/SDG-WAYSHELL" "$HOME/.local/tips/SDG-WAYSHELL"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"

sudo ln -sf "$HOME/.local/SDG-WAYSHELL/wayshell.sh" /usr/bin/wayshell
