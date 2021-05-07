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
lapack
arpack
arpack++
eigen
doxygen

########## Networking ##########
dhcpcd 
networkmanager 
openssh 
vpnc

########## Text Editor  ##########
vim 
emacs

########## Utilities ##########
cronie
wget 
man-db
 

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
dmidecode
lm_sensors 
htop
s-tui
pytop
gotop
nvtop
vnstat
net-tools 

########## Input ##########
light
ddcutil

########## Desktop Environment ##########
i3 
i3status 
lightdm
xcompmgr 
compton
rofi
dunst 
pacwall
conky

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
tor

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
nginx
php
mysql
mariadb
certbot

########## Password Manager  ##########
pass

########## Package Management  ##########
yay
pacman-contrib

########## Backups and Storage  ##########
duplicity
nextcloud-client
hdparam
mdadm

########## Office ##########
libre-office
open-office

########## Torrenting ##########
transmission

########## Eye Candy ##########
cmatrix
figlet 
fetch
neofetch
cowsay

