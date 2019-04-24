
## Perso (install)

alias ls='ls --color=auto'
alias ll='ls -lhAF --group-directories-first'
alias la='ls -A'
alias l='ls -AlF --group-directories-first'

NO_COLOR="\[\033[00m\]"
LIGHT_WHITE="\[\033[1;37m\]"
WHITE="\[\033[0;37m\]"
GRAY="\[\033[1;30m\]"
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
YELLOW="\[\033[0;33m\]"
LIGHT_YELLOW="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
MAGENTA="\[\033[0;35m\]"
LIGHT_MAGENTA="\[\033[1;35m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"

if [[ $EUID -ne 0 ]]; then
  export PS1="${debian_chroot:+($debian_chroot)}${BLUE}\u${CYAN}@${BLUE}\h${NO_COLOR}:${GREEN}\w${NO_COLOR}\$ "
else
  export PS1="${debian_chroot:+($debian_chroot)}${BLUE}\u${CYAN}@${BLUE}\h${NO_COLOR}:${GREEN}[\w]${NO_COLOR}\$ "
fi

function COLOR_256 () { echo -ne "\[\033[38;5;$1m\]"; }
function COLOR_256_BOLD () { echo -ne "\[\033[1;38;5;$1m\]"; }

#export PS1="${debian_chroot:+($debian_chroot)}`COLOR_256_BOLD 69`\u`COLOR_256 75`@`COLOR_256_BOLD 69`\h${NO_COLOR}:`COLOR_256 172`\w${NO_COLOR}\\$ "

# `dircolors` prints out `LS_COLORS='...'; export LS_COLORS`, so eval'ing
# $(dircolors) effectively sets the LS_COLORS environment variable.

eval "$(dircolors /etc/dircolors)"

HISTTIMEFORMAT="[%d/%m/%y %T] "
