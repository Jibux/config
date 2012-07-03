#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /etc/bash.bashrc

color_prompt="yes"

######### ######## ######
# Color # # Text # # bg #
######### ######## ######
# Black		30		40
# Red		31		41
# Green		32		42
# Orange	33		43
# Blue		34		44
# Magenta	35		45
# Cyan		36		46
# White		37		47

###########
# Effects #
###########
# 01 Bold
# 04 Underline
# 05 Blinking
# 07 Highlight

# \u user
# \h hostname
# \w current directory
# \$ user status ($ or #).


if [ "$color_prompt" = yes ]; then
	# 32: Green
    PS1='\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;33m\]\h\[\033[32m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	# 31: Red
    #PS1='\[\033[01;31m\]\u\[\033[01;34m\]@\[\033[01;33m\]\h\[\033[31m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

PATH="${PATH}:/home/jbh/bin:"

