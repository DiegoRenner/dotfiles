pacstrap /mnt 

########## Base Install ##########
base linux linux-firmware 

########## Development ##########
base-devel 
git 
cmake 
clion
python
pip
pycharm

########## Networking ##########
dhcpcd 
networkmanager 
openssh 

########## Text Editor  ##########
vim 

########## Utilities ##########
wget 
man-db
neofetch
 

########## Drivers ##########

##### CPU #####
intel-ucode 
amd-ucode 

##### GPU #####
mesa 
lib32-mesa 
xf86-video-amdgpu
vulkan-radeon
libva-mesa-driver
lib32-libva-mesa-driver
mesa-vdpau
lib32-mesa-vdpau
acpi_call 


########## Monitoring ##########
lm_sensors 
htop
s-tui
pytop
gotop
nvtop

########## Input ##########
light

########## Desktop Environment ##########
i3 
i3status 
lightdm
xcompmgr 
rofi
dunst 
pacwall

########## Entertainment ##########
vlc
steam
stremio 
twitch-curses
youtube-dl

########## Browser ##########
brave
chromium
firefox

########## Image/Document-Viewer ##########
feh
evince

########## Crypto  ##########
monero-gui
xmrig

########## Audio  ##########
pavucontrol

########## Streaming  ##########
obs
ndi
ffmpeg
v4l2loopback
gphoto
natron

########## Web Hosting  ##########
apache
php
mysql
mariadb

########## Password Manager  ##########
pass

