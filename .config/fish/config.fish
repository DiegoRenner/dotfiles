function fish_greeting 
end 
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
alias ref="shortcuts >/dev/null; source ~/.config/shortcutrc"
alias weath="less -S ~/.local/share/weatherreport"

# Custom
alias writing="cd /home/diego/Uni/Thesis/writing/ThesisDoc"
alias ls="ls --color=auto"
alias i3exit="/home/diego/.scripts/i3_exit.sh"
alias stremio="/usr/bin/env QT_AUTO_SCREEN_SCALE_FACTOR=1 stremio %u"
alias nextcloud="/usr/bin/env QT_AUTO_SCREEN_SCALE_FACTOR=2 nextcloud"
alias steam="/usr/bin/env GDK_SCALE=2.2 steam %u"
alias xournalpp="/usr/bin/env GDK_SCALE=2 xournalpp"
alias thesis="cd /home/diego/Uni/Thesis"
alias dlsc="cd /home/diego/Uni/DLSC"
alias plots="cd /home/diego/Uni/Thesis/matlab_plots"
alias papers="cd /home/diego/Uni/Thesis/papers"
alias nvidia="optimus-manager --switch nvidia --no-confirm"
alias intel="optimus-manager --switch integrated --no-confirm"
alias btDC="sudo bluetoothctl power off"
alias btUE="sudo bluetoothctl power on; bluetoothctl connect 00:0D:44:DD:8D:A0"
alias btUC="sudo bluetoothctl power on; bluetoothctl connect FC:58:FA:8E:7E:80"
alias btUEJ="bluetoothctl power on; bluetoothctl connect 88:C6:26:00:2A:E8"
alias riehen="screensetup.sh riehen"
alias zurich="screensetup.sh zurich"
alias cgit="git --git-dir=$HOME/.config_git/ --work-tree=$HOME"
