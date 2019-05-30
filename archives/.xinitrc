#!/bin/bash

xbindkeys

DEFAULT_SESSION=startfluxbox
DE=startfluxbox
BROWSER=chromium

case $1 in
	gnome)
		exec gnome-session
		;;
	xfce4)
		exec startxfce4
		;;
	#icewm)
		#               icewmbg &
		#               icewmtray &
		#               exec icewm
		#               ;;
	#wmaker)
		#               exec wmaker
		#               ;;
	fluxbox)
		exec startfluxbox
		;;
	*)
		exec $DEFAULT_SESSION
		;;
esac

