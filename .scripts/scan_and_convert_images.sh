# list devices
scanimage -L
# scan image
sudo scanimage --format=jpeg --output-file msc_bestättigung.jpg --progress --device "epson2:libusb:001:014" --mode Gray --resolution 300
# convert to pdf
convert msc_bestättigung.jpg msc_bestättigung.pdf

