#!/bin/bash

LOCALDIR=SDG-WAYSHELL
DOCDIR=SDG-WAYSHELL
TIPDIR=SDG-WAYSHELL
entrypoint=wayshell.sh
command=wayshell

WORKDIR=$(pwd)

rm -rf "$HOME/.local/docs/$DOCDIR" "$HOME/.local/tips/$TIPDIR" "$HOME/.local/$LOCALDIR" "$HOME/.local/matugen"

mkdir -p "$HOME/.local/$LOCALDIR" "$HOME/.local/matugen"
cp -r "$WORKDIR/config/"* "$HOME/.config/" 2>/dev/null || true
cp -r "$WORKDIR/local/"* "$HOME/.local/"
cp -r "$WORKDIR/docs/"* "$HOME/.local/docs/"
cp -r "$WORKDIR/tips/"* "$HOME/.local/tips/"
cp -r "$WORKDIR/matugen/"* "$HOME/.local/matugen/"

chmod a+x "$HOME/.local/SDG-WAYSHELL/wayshell.sh"
chmod a+x "$HOME/.local/SDG-WAYSHELL/modules/"*.sh

sudo ln -sf "$HOME/.local/$LOCALDIR/$entrypoint" /usr/bin/$command

which $command || echo "INSTALL FAILED!"
