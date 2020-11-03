#!/bin/bash


#DEBIAN="no"
BACKPORTS_OPT=""

if hostnamectl | grep -iq debian; then
	#DEBIAN="yes"
	BACKPORTS_OPT="-tbuster-backports"
fi

sudo apt install -y vim vim-common vim-gtk3 vim-gui-common vim-nox vim-runtime vim-tiny
sudo apt install -y rxvt-unicode-256color
sudo apt install -y "$BACKPORTS_OPT" tmux
sudo apt install -y tmux-plugin-manager

command -v npm &>/dev/null && sudo npm -g install instant-markdown-d

wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update
sudo apt-get install typora

