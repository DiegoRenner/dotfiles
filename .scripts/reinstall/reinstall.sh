#!/bin/bash

for pkgName in $(cat packages.txt)
do
	yay  -S $pkgName --noconfirm --overwrite="*"
done
