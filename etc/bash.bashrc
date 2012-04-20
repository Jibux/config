#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
PS2='> '
PS3='> '
PS4='+ '

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
                                                        
    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
esac

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export EDITOR="vim"
export BROWSER=/usr/bin/chromium

# Autocompletion <TAB><TAB> for sudo
complete -cf sudo


###########
# ALIASES #
###########

# Keep bashrc settings SECURE ???
#alias sudo='A=`alias` sudo '

alias vi=vim

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias open='xdg-open'

# Do not freeze/unfreeze when tipping ctrl+S and ctrl+Q in vim
vim()
{
	local STTYOPTS="$(stty --save)"
	# ctrl+S freeze
	stty stop '' -ixoff
	# ctrl+Q unfreeze
	stty stop '' -ixon
	command vim "$@"
	stty "$STTYOPTS"
}

