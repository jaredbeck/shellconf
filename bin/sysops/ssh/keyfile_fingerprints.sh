#!/usr/bin/env bash

# In linux, keyfiles are in /etc/ssh.  On macs, in /private/etc.
POTENTIAL_DIRS=( '/etc/ssh' '/private/etc' )
for d in "${POTENTIAL_DIRS[@]}"; do
  if [ -d $d ]; then SSH_KEYFILE_DIR=$d; fi
done

for f in `ls $SSH_KEYFILE_DIR/ssh_host_*_key.pub`; do
  ssh-keygen -lf "$f"
done
