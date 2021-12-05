#!/bin/bash

if [ "$1" = "zurich" ]
then
	tee /home/diego/.xprofile > /dev/null << 'EOF'
#!/usr/bin/env sh

# This file runs when a DM logs you into a graphical session.
# If you use startx/xinit like a Chad, this file will also be sourced.

#setbg &			# set the background with the `setbg` script
xcompmgr &		# xcompmgr for transparency
#$STATUSBAR &		# script for updating the status bar
#dunst &			# dunst for notifications
xset r rate 300 50 &	# Speed xrate up
unclutter &		# Remove mouse when idle
if [ $(glxinfo | grep "OpenGL vendor" | grep NVIDIA | cut -d " " -f 4) = "NVIDIA" ]
then 
	nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
	./.scripts/screenlayout_zurich.sh
else
	./.scripts/screenlayout_no_ext.sh
fi
pacwall -ug &
EOF
	sudo tee /etc/optimus-manager/xsetup-nvidia.sh > /dev/null << 'EOF'
#!/bin/sh

# Everything you write here will be executed by the display manager when setting up the login screen in Nvidia mode.
# (but before optimus-manager sets up PRIME with xrandr commands).
/home/diego/.scripts/screenlayout_zurich.sh
EOF
	sudo tee /etc/optimus-manager/xsetup-hybrid.sh > /dev/null << 'EOF'
#!/bin/sh

# Everything you write here will be executed by the display manager when setting up the login screen in "hybrid" mode.
/home/diego/.scripts/screenlayout_no_ext.sh
EOF

elif [ "$1" = "riehen" ]
then
	tee /home/diego/.xprofile > /dev/null << 'EOF'
#!/usr/bin/env sh

# This file runs when a DM logs you into a graphical session.
# If you use startx/xinit like a Chad, this file will also be sourced.

#setbg &			# set the background with the `setbg` script
xcompmgr &		# xcompmgr for transparency
#$STATUSBAR &		# script for updating the status bar
#dunst &			# dunst for notifications
xset r rate 300 50 &	# Speed xrate up
unclutter &		# Remove mouse when idle
if [ $(glxinfo | grep "OpenGL vendor" | grep NVIDIA | cut -d " " -f 4) = "NVIDIA" ]
then 
	nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
	./.scripts/screenlayout_riehen_right.sh
else
	./.scripts/screenlayout_no_ext.sh
fi
pacwall -ug &
EOF
	sudo tee /etc/optimus-manager/xsetup-nvidia.sh > /dev/null << 'EOF'
#!/bin/sh

# Everything you write here will be executed by the display manager when setting up the login screen in Nvidia mode.
# (but before optimus-manager sets up PRIME with xrandr commands).
/home/diego/.scripts/screenlayout_riehen_right.sh
EOF
	sudo tee /etc/optimus-manager/xsetup-hybrid.sh > /dev/null << 'EOF'
#!/bin/sh

# Everything you write here will be executed by the display manager when setting up the login screen in "hybrid" mode.
/home/diego/.scripts/screenlayout_no_ext.sh
EOF

else 
	echo "No valid argument recognized. Pass either zurich or riehen as first arguement."
fi
