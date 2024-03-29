# Attribute codes:
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
#
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
#
# Sequence:
# \e[<attribute code>;<text color code>;<background color code>m

# Prompt color
#   Black       0;30     Dark Gray     1;30
#   Blue        0;34     Light Blue    1;34
#   Green       0;32     Light Green   1;32
#   Cyan        0;36     Light Cyan    1;36
#   Red         0;31     Light Red     1;31
#   Purple      0;35     Light Purple  1;35
#   Brown       0;33     Yellow        1;33
#   Light Gray  0;37     White         1;37

NONE="\[\033[0m\]"

BLACK="\[\033[0;30m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[0;37m\]"

BLACK_REV="\[\033[7;30m\]"
NORMAL_REV="\[\033[7;39m\]"
NORMAL_UND="\[\033[4;39m\]"

# Load system bashrc
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# git branch function
function parse_git_branch
{
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* [(]*\([^)]*\)[)]*/ (\1)/'
}

# Customize shell prompt
export PS1="${NONE}\u@\h${NONE}:${BLUE}\w${GREEN}\$(parse_git_branch)${NONE}\n\$>${NONE} "

# Helper functions
svndiff() { svn diff --diff-cmd=colordiff "$@"; }
sw() { mv $1 $1.$$ && mv $2 $1 && mv $1.$$ $2; }
grep() { `which grep` --color=auto "$@"; }
grepi() { grep -Eri "$@"; }
diff() { `which diff` --show-c-function --ignore-all-space --unified "$@"; }
alias ll="ls -l"

case $(uname -s) in
Darwin)
	export CLICOLOR=1
	export LSCOLORS=exfxcxdxbxegedabagacad

	# read the AppleLocale
	lngstr=$(defaults read .GlobalPreferences AppleLocale 2>/dev/null)
	encstr=UTF-8
	locstr=en_US.UTF-8
	if [ -n "$(locale -a | grep -e ^$lngstr\.$encstr\$)" ]; then
		locstr=$lngstr.$encstr
	fi
	export LC_ALL=$locstr
	export LANG=$locstr

	# Load bash-completion
	# brew install git bash-completion
	[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] \
		&& . "/usr/local/etc/profile.d/bash_completion.sh"

	# Swap Right Alt and Right Control keyboard keys
	# https://developer.apple.com/library/archive/technotes/tn2450/_index.html
	# https://apple.stackexchange.com/questions/283252/how-do-i-remap-a-key-in-macos-sierra-e-g-right-alt-to-right-control
	# hidutil property --set '{"UserKeyMapping":
	# 	[{"HIDKeyboardModifierMappingSrc":0x7000000e4,
	# 	  "HIDKeyboardModifierMappingDst":0x7000000e6},
	# 	 {"HIDKeyboardModifierMappingSrc":0x7000000e6,
	# 	  "HIDKeyboardModifierMappingDst":0x7000000e4}]
	# }' >/dev/null
	# To restore:
	# hidutil property  --set '{"UserKeyMapping":[]}'
	;;

Linux)
	alias ls="ls --color"
	eval `dircolors`
	;;
esac

case $SHELL in
/bin/bash)
	# History configuration
	export HISTSIZE=10000           # number of lines in history file
	export HISTCONTROL=ignoreboth   # don't save already present commands
	shopt -s histappend             # append commands to the history file, rather than overwrite it
	;;

/bin/zsh)
	# History configuration
	export SAVEHIST=10000
	setopt APPEND_HISTORY
	setopt HIST_SAVE_NO_DUPS
	;;
esac

# Save each command right after it has been executed
#export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# Set current directory for tmux enviroment
#export PROMPT_COMMAND="[ -n \"\$TMUX\" ] && tmux setenv TMUXPWD_\$(tmux display -p \"#I#P\" 2>/dev/null) \$PWD 2>/dev/null" #; $PROMPT_COMMAND"

# Load local environment
if [ -f .bashrc_local ]; then
	. .bashrc_local
fi

# if locale was not set, use a standard one
#if [ -z "$(locale | grep -P "LANG=.+")" ]; then
#	export LANG=en_US.UTF-8
#fi

function ssh-reagent
{
	for agent in /tmp/ssh-*/agent.*; do
			export SSH_AUTH_SOCK=$agent
			if ssh-add -l 2>&1 > /dev/null; then
					echo Found working SSH Agent:
					ssh-add -l
					return
			fi
	done
	echo Cannot find ssh agent - maybe you should reconnect and forward it?
}
