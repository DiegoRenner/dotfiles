function fish_greeting
end

fish_vi_key_bindings
alias mv="mv -iv"
alias rm="rm -v"
alias mkd="mkdir -pv"
alias yt="youtube-dl --add-metadata -i"
alias yta="yt -x -f bestaudio/best"
alias ffmpeg="ffmpeg -hide_banner" # Colorize commands when possible.
alias ls="ls -hN --color=auto --group-directories-first"
alias grep="grep --color=auto"
alias diff="diff --color=auto"

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

# Custom
alias ls="ls --color=auto"
alias i3exit="/home/diego/.scripts/i3_exit.sh"
alias stremio="/usr/bin/env QT_AUTO_SCREEN_SCALE_FACTOR=1 stremio %u"
alias nextcloud="/usr/bin/env QT_AUTO_SCREEN_SCALE_FACTOR=2 nextcloud"
alias xournalpp="/usr/bin/env GDK_SCALE=2 xournalpp"
alias thesis="cd /home/diego/studies/uni/thesis_maths"
alias writing="cd /home/diego/studies/uni/thesis_maths/writing/On-fast-simulations-of-cardiac-function"
alias presentation="cd /home/diego/studies/uni/thesis_maths/writing/On-fast-simulations-of-cardiac-function/presentation"
alias webs="cd /home/diego/code/PhpstormProjects/portfolio_michael/"
alias coding="cd /home/diego/studies/uni/thesis_maths/jaxFlowSim"
alias btDC="sudo bluetoothctl power off"
alias btBH="sudo bluetoothctl power on; bluetoothctl connect 00:58:50:4C:39:EA"
alias btUE="sudo bluetoothctl power on; bluetoothctl connect 00:0D:44:DD:8D:A0"
alias btUC="sudo bluetoothctl power on; bluetoothctl connect FC:58:FA:8E:72:E5"
alias btHT="sudo bluetoothctl power on; bluetoothctl connect 10:63:C8:0A:5D:BE"
alias btJ="sudo bluetoothctl power on; bluetoothctl connect 50:C2:75:E8:D0:60"
alias btR="sudo bluetoothctl power on; bluetoothctl connect F4:4E:FC:35:28:13"
alias dashboard="python /home/diego/Programming/dashboard/dashboard_threaded.py /home/diego/Programming/dashboard/config.json"
alias hackintosh="cd /home/diego/Programming/macOS-Simple-KVM; sudo /home/diego/Programming/macOS-Simple-KVM/basic.sh"
alias fmoto="xmoto -res 1920x1080 -win"
alias sfmoto="xmoto -res 1680x1050 -win"
alias wmoto="xmoto -res 960x540 -win"
alias swmoto="xmoto -res 840x525 -win"
alias bckp="backup_duplicity.sh"
alias dls="youtube-dl -x --audio-quality 0 --audio-format m4a"
alias assume="source /usr/bin/assume.fish"
alias remote="cd /home/diego/studies/uni/phd/remote/"
alias phd="cd /home/diego/studies/uni/phd"
alias gpu="cd /home/diego/studies/uni/phd/gpu_build/"
alias web="cd /home/diego/code/webapp/"
alias plan="cd /home/diego/code/planner-matrix/"
alias jax="cd /home/diego/studies/uni/thesis_maths/jaxFlowSim/"

# fzf recent dirs
zoxide init fish | source
