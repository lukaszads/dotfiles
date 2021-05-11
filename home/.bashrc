test -s ~/.alias && . ~/.alias || true

# luckrk

# add user bin to PATH
export PATH=/home/luckrk/.local/bin:$PATH

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# No double entries in the shell history.
export HISTCONTROL="$HISTCONTROL erasedups:ignoreboth"

# Wrap the following commands for interactive use to avoid accidental file overwrites.
rm() { command rm -i "${@}"; }
cp() { command cp -i "${@}"; }
mv() { command mv -i "${@}"; }

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colour codes are cumbersome, so let's name them
txtcyn='\[\e[0;96m\]' # Cyan
txtpur='\[\e[0;35m\]' # Purple
txtwht='\[\e[0;37m\]' # White
txtrst='\[\e[0m\]'    # Text Reset

# Which (C)olour for what part of the prompt?
pathC="${txtcyn}"
gitC="${txtpur}"
pointerC="${txtwht}"
normalC="${txtrst}"

# Get the name of our branch and put parenthesis around it
gitBranch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Build the prompt
export PS1="${pathC}\w ${gitC}\$(gitBranch)${pointerC}\$${normalC} "

# ls
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias z='zypper'

if [ -s /usr/share/autojump/autojump.bash ]; then
    source /usr/share/autojump/autojump.bash
fi

# autokomplete
# If there are multiple matches for completion, Tab should cycle through them

bind 'TAB':menu-complete

# Display a list of the matching files

bind "set show-all-if-ambiguous on"

# Perform partial completion on the first Tab press,
# only start cycling full results on the second Tab press

bind "set menu-complete-display-prefix on"

source "$HOME/.homesick/repos/homeshick/homeshick.sh"