#!/bin/sh
set -e

DFSAVEDIR=/opt/df_linux/data/save
BACKUPDIR=~/Personal/green/incorporeal/gaming/computer/df/backup

if [ -d "$DFSAVEDIR" ] && [ -d "$BACKUPDIR" ]; then
  TODAYSTAMP=`date +%Y%m%d`
  tar cf "$BACKUPDIR/$TODAYSTAMP.tar" "$DFSAVEDIR"
fi

