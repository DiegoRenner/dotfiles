#!/bin/fish

set status1 (rfkill list | awk 'NR==2 {print $3}')
#set status1 (nmcli radio wifi)
#status1=$(nmcli radio wifi)
#notify-send $status1

if test $status1 = "yes";
#if [ $status1 == "no" ]
	# toggling done by key itself, notify only
	#nmcli radio wifi off;
	notify-send "Bluetooth has been: disabled" -h string:x-canonical-private-synchronous:anything
else;
	# toggling done by key itself, notify only
	#nmcli radio wifi on;
	notify-send "Bluetooth has been: enabled" -h string:x-canonical-private-synchronous:anything
end

#status1=$(sudo nmcli radio wifi);

#notify-send "WiFi has been: $status1" 
