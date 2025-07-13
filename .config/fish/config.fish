function fish_greeting 
end 

source /opt/miniconda3/etc/fish/conf.d/conda.fish
fish_vi_key_bindings 
# Verbosity and settings that you pretty much just always are going to want.  
#alias | awk -F'[ =]' '{print $2}'
 alias bat="cat /sys/class/power_supply/BAT?/capacity" 
#alias cp="cp -iv" 
alias mv="mv -iv" 
alias rm="rm -v" 
alias mkd="mkdir -pv" 
alias yt="youtube-dl --add-metadata -i" 
alias yta="yt -x -f bestaudio/best" 
alias ffmpeg="ffmpeg -hide_banner" # Colorize commands when possible.
alias ls="ls -hN --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ccat="highlight --out-format=ansi"

# These common commands are just too long! Abbreviate them.
alias ka="killall"
alias g="git"
alias trem="transmission-remote"
alias YT="youtube-viewer"
alias sdn="sudo shutdown -h now"
alias f="$FILE"
alias e="$EDITOR"
alias v="$EDITOR"
alias p="sudo pacman"
alias xi="sudo xbps-install"
alias xr="sudo xbps-remove -R"
alias xq="xbps-query"


# Some other stuff
#alias ref="shortcuts >/dev/null; source ~/.config/shortcutrc"
#alias weath="less -S ~/.local/share/weatherreport"

# Custom
alias ls="ls --color=auto"
alias i3exit="/home/diego/.scripts/i3_exit.sh"
alias stremio="/usr/bin/env QT_AUTO_SCREEN_SCALE_FACTOR=1 stremio %u"
alias nextcloud="/usr/bin/env QT_AUTO_SCREEN_SCALE_FACTOR=2 nextcloud"
#alias steam="/usr/bin/env GDK_SCALE=2.2 steam %u"
#alias phpstorm="/usr/bin/env GDK_SCALE=2.5 phpstorm"
alias xournalpp="/usr/bin/env GDK_SCALE=2 xournalpp"
alias thesis="cd /home/diego/studies/uni/thesis_maths"
alias writing="cd /home/diego/studies/uni/thesis_maths/writing/On-fast-simulations-of-cardiac-function"
alias presentation="cd /home/diego/studies/uni/thesis_maths/writing/On-fast-simulations-of-cardiac-function/presentation"
alias webs="cd /home/diego/code/PhpstormProjects/portfolio_michael/"
alias coding="cd /home/diego/studies/uni/thesis_maths/jaxFlowSim"
alias nvidia="optimus-manager --switch nvidia --no-confirm"
alias intel="optimus-manager --switch integrated --no-confirm"
alias hybrid="optimus-manager --switch hybrid --no-confirm"
alias btDC="sudo bluetoothctl power off"
alias btBH="sudo bluetoothctl power on; bluetoothctl connect 00:58:50:4C:39:EA"
alias btUE="sudo bluetoothctl power on; bluetoothctl connect 00:0D:44:DD:8D:A0"
alias btUC="sudo bluetoothctl power on; bluetoothctl connect FC:58:FA:8E:72:E5"
alias btHT="sudo bluetoothctl power on; bluetoothctl connect 10:63:C8:0A:5D:BE"
alias btUEJ="sudo bluetoothctl power on; bluetoothctl connect 88:C6:26:00:2A:E8"
alias btJ="sudo bluetoothctl power on; bluetoothctl connect 50:C2:75:E8:D0:60"
alias btR="sudo bluetoothctl power on; bluetoothctl connect F4:4E:FC:35:28:13"
alias riehen="screensetup.sh riehen"
alias zurich="screensetup.sh zurich"
alias cgit="git --git-dir=$HOME/.config_git/ --work-tree=$HOME"
alias dashboard="python /home/diego/Programming/dashboard/dashboard_threaded.py /home/diego/Programming/dashboard/config.json"
alias hackintosh="cd /home/diego/Programming/macOS-Simple-KVM; sudo /home/diego/Programming/macOS-Simple-KVM/basic.sh"
alias fmoto="xmoto -res 1920x1080 -win"
alias sfmoto="xmoto -res 1680x1050 -win"
alias wmoto="xmoto -res 960x540 -win"
alias swmoto="xmoto -res 840x525 -win"
alias bckp="backup_duplicity.sh"
alias vpn="start_cisco.sh"
alias convpn="echo \"\$(pass uni/Radius)\" | sudo -S openconnect --useragent=AnyConnect --usergroup student-net --token-secret=ETHZ.STUDENT-NET.VPN -u drenner@student-net.ethz.ch sslvpn.ethz.ch"
alias disvpn="sudo pkill openconnect"
alias dls="youtube-dl -x --audio-quality 0 --audio-format m4a"

