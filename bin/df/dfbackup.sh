#!/bin/bash
set -e

DFSAVEDIR=/opt/df_linux/data/save
BACKUPDIR=~/Personal/green/incorporeal/gaming/computer/df/backup

source "$(dirname $0)/../lib_bash.sh"

assert_dir "$DFSAVEDIR"
assert_dir "$BACKUPDIR"

stamp=`date +%Y%m%d-%H%M`
tarfile="$BACKUPDIR/$stamp.tar"
tar cf "$tarfile" "$DFSAVEDIR"

size="$(du -h $tarfile | cut -f 1)"
echo "Backed up $stamp.tar ($size)"

