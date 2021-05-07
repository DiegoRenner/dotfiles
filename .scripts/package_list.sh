pacstrap /mnt 

########## Base Install ##########
base linux linux-firmware 

########## Development ##########
base-devel 
git 
cmake 

########## Networking ##########
dhcpcd networkmanager openssh 

########## Text Editor  ##########
vim 

########## Utilities ##########
wget 
man-db
neofetch
htop 
 

########## Drivers ##########
##### CPU #####
intel-ucode 
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

########## Sensors ##########
lm_sensors 

########## Desktop Environment ##########
i3 
i3status 
lightdm
xcompmgr 
dunst 
