#!/bin/bash
# 1. Aliases from Fish
fish -c "alias" | awk -F"[ =]" "{print \$2}"
# 2. Applications from Desktop files
ls /usr/share/applications/ | grep .desktop | xargs -I {} grep -h "^Exec=" /usr/share/applications/{} | cut -d"=" -f2 | cut -d" " -f1 | sed "s/%.*//" | xargs -n1 basename | sort -u

