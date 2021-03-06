#
# ~/.bashrc
#

set -o vi


# PROMPT
export PROMPT_COMMAND=set_prompt

RESET="$(tput sgr0)"
GREEN="$(tput setaf 2)"
RED="$(tput setaf 9)"

set_prompt() {
	if [ $? == 0 ]; then
		PS1="\[\e[0;32m\]\W -> \[\e[m\]"
	else	
		PS1="\[\e[0;31m\]\W -> \[\e[m\]"
	fi
}


# ALIASES

alias ls='ls --color=auto'
alias ll='ls -lhav --ignore=..' 

alias update-mirrors="sudo reflector --save /etc/pacman.d/mirrorlist -c Germany,Belgium \
	--latest 10 --sort rate --ipv4 --verbose --protocol https --download-timeout 20"


# PATH
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.yarn/bin


# Some stuff, I don't know what they do.
[[ "$(whoami)" = "root" ]] && return
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
