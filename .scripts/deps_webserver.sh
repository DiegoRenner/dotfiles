#!/bin/bash 
if cat /proc/version | grep -q arch; then
	yay -S php-apache certbot-apache certbot apache php
elif cat /proc/version | grep -q debian; then
	sudo apt install php-mysql libapache-mod-php python-certbot-apache certbot apache2 mariadb-server php
elif cat /proc/version | grep -q buildbot; then
	sudo apt install php-mysql libapache-mod-php python-certbot-apache certbot apache2 mariadb-server php
fi


