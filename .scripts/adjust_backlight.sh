#!/bin/bash
echo $1

sudo light $1;
notify-send "Brightness: $(sudo light)"  -h string:x-canonical-private-synchronous:anything

