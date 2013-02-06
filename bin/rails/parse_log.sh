#!/usr/bin/env sh
set -e

# Remove lines that don't begin with ..
egrep '(Processing|Completed)' production.log > 2.log

# Assuming no dollar signs exist in the input ..
# Put "Processing" and "Completed" on the same line
cat 2.log | tr "\n" '$' | sed 's/$Completed//g' | tr '$' "\n" > 3.log

# Project only the fields we want
cat 3.log | sed -E 's/(Processing )([[:alnum:]:]+#[[:alnum:]]+)(.*)(\[[A-Z]+])([^[]*)(\[http.*\])/\2 \4 \6/g' > 4.log

# Get distinct lines
cat 4.log | sort | uniq > 5.log
