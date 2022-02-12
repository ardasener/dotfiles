# Source this file in the bashrc
# source ~/.config/bash_config.sh

# CMD PROMPT
# Green or red path+arrow depending on the previous commands output
export PROMPT_COMMAND=set_prompt
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

# Only for Arch systems
alias arch-update-mirrors="sudo reflector --save /etc/pacman.d/mirrorlist -c Germany,Belgium \
	--latest 10 --sort rate --ipv4 --verbose --protocol https --download-timeout 20"


# PATH

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.bin
export PATH=$PATH:~/.yarn/bin
export PATH=$PATH:~/.scripts
export PATH=$PATH:~/.cargo/bin

# OTHER ENV. VARIABLES

export CC=clang
export CXX=clang++
export EDITOR=vim

# BETTER COMPLETION 

# Use TAB and Shift-TAB to cycle between options
# Will also print all the options
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

# Use the up and down arrow keys for finding a command in history
# (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
