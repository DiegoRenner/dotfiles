#!/bin/sh
# Profile file. Runs on login. Environmental variables are set here.

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH="$PATH:/home/diego/.scripts"
export PATH="$PATH:/opt/depot_tools"
export PATH="$PATH:/home/diego/.gem/ruby/2.7.0/bin"

#export LARBSWM="i3"
# Default programs:
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="brave"
export READER="zathura"
export FILE="ranger"
export PAGER="less"

# Clean-up:
export NOTMUCH_CONFIG="$HOME/.config/notmuch-config"
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="$HOME/.config/wget/wgetrc"
export ZDOTDIR="$HOME/.config/zsh"
#export PASSWORD_STORE_DIR="$HOME/.local/share/password-store"

