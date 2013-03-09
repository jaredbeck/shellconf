#!/bin/sh
set -e

DFSAVEDIR=/opt/df_linux/data/save
BACKUPDIR=~/Personal/green/incorporeal/gaming/computer/df/backup

if [ -d "$DFSAVEDIR" ] && [ -d "$BACKUPDIR" ]; then
  STAMP=`date +%Y%m%d-%H%M`
  tar cf "$BACKUPDIR/$STAMP.tar" "$DFSAVEDIR"
fi

