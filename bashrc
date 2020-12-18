#
# ~/.bashrc
#


# PROMPT
RESET="\[$(tput sgr0)\]"
GREEN="\[$(tput setaf 2)\]"
PS1="${GREEN}->${RESET} "



# ALIASES
alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..'   # show long listing of all except ".."
alias l='ls -lav --ignore=.?*'   # show long listing but no hidden dotfiles except "."



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
