# System-wide .bashrc file for interactive bash(1) shells.

# custom binaries
export PATH="${PATH}:/usr/bin:~/bin"
export LC_ALL=en_US.UTF-8
export PYTHONIOENCODING=UTF-8
export TERM=xterm-256color

ESC="\e["
RESET=$ESC"39m"
RED=$ESC"31m"
GREEN=$ESC"32m"
YELLOW=$ESC"33m"
BLUE=$ESC"34m"
GREY=$ESC"37m"
WHITE=$ESC"97m"
PS1="${GREEN}|${RESET}${GREY}\u${RESET}${GREEN}|${RESET}${GREY}\h${RESET}${GREEN}|${RESET}${GREY}\w${RESET}${GREEN}|${RESET}\n\\$ "
if [[ $UID -eq 0 ]]; then
        PS1="${GREEN}|${RESET}${RED}\u${RESET}${GREEN}|${RESET}${RED}\h${RESET}${GREEN}|${RESET}${GREY}\w${RESET}${GREEN}|${RESET}\n\\$ "
fi

ulimit -c unlimited

#===================[ALIASES START HERE]===================#

#_____[command aliases]__________ #
alias ls='ls -GF'
alias ll='ls -GFlatr'

# You're welcome
function soocat {
    socat tcp-l:${2},reuseaddr,fork EXEC:${1}
}
