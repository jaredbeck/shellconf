#!/usr/bin/env sh
set -e

# Inventory routes by processing a production log file

# Remove lines that don't begin with ..
egrep '(Processing|Completed)' production.log > 2.log

# Assuming no dollar signs exist in the input ..
# Put "Processing" and "Completed" on the same line
cat 2.log | tr "\n" '$' | sed 's/$Completed//g' | tr '$' "\n" > 3.log

# Project only the fields we want
cat 3.log | sed -E 's/(Processing )([[:alnum:]:]+#[[:alnum:]_]+)(.*)(\[[A-Z]+])([^[]*)(\[http.*\])/\2 \4 \6/g' > 4.log

# Get distinct lines
cat 4.log | sort | uniq > 5.log

# Replace numbers in URL with ":n" to indicate dynamic sement
cat 5.log | sed -E 's/\/[0-9]+\//\/:n\//g' | sort | uniq > 6.log

# www.ggchapters.org is the same as ggchapters.org
cat 6.log | sed 's/www.ggchapters.org/ggchapters.org/g' | sort | uniq > 7.log

# Replace numbers at the ends of URLs with ":n" to indicate dynamic segment
cat 7.log | sed -E 's/\/[0-9]*]/\/:n]/g' | sort | uniq > 8.log
