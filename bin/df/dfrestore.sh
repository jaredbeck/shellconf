#!/bin/bash
set -e

DFDATADIR=/opt/df_linux/data
DFSAVEDIR="$DFDATADIR/save"
BACKUPDIR=~/Personal/green/incorporeal/gaming/computer/df/backup

function die {
  echo "$1" 1>&2
  exit 1
}

function assert_dir {
  if [ ! -d "$1" ]; then die "Directory not found: $1"; fi
}

function assert_file {
  if [ ! -f "$1" ]; then die "File not found: $1"; fi
}

assert_dir "$DFSAVEDIR"
assert_dir "$BACKUPDIR"

ls $BACKUPDIR
echo -n "File: "
read tarfile

tarpath="$BACKUPDIR/$tarfile"
assert_file "$tarpath"

tar -x -f $tarpath -C /tmp
assert_dir "/tmp$DFSAVEDIR"

# copy the save dir just in case
if [ -d "$DFSAVEDIR.bak" ]; then
  rm -r "$DFSAVEDIR.bak"
fi
mv "$DFSAVEDIR" "$DFSAVEDIR.bak"

mv "/tmp$DFSAVEDIR" "$DFDATADIR"

