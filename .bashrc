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

#export PS1="${YELLOW}\u${CYAN}@${PURPLE}\h${CYAN}:${GREEN}\w${CYAN}\$${NONE} "
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
	if [ -n "$(locale -a | grep -P ^$lngstr\.$encstr\$)" ]; then
		export LANG=$lngstr.$encstr
	fi
	;;

Linux)
	export LS_COLORS="no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:do=00;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=00;32:*.tar=00;31:*.bz2=00;31:*.tgz=00;31:*.svgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.dz=00;31:*.gz=00;31:*.bz2=00;31:*.tbz2=00;31:*.bz=00;31:*.tz=00;31:*.deb=00;31:*.rpm=00;31:*.jar=00;31:*.rar=00;31:*.ace=00;31:*.zoo=00;31:*.cpio=00;31:*.7z=00;31:*.rz=00;31:*.jpg=00;35:*.jpeg=00;35:*.gif=00;35:*.bmp=00;35:*.pbm=00;35:*.pgm=00;35:*.ppm=00;35:*.tga=00;35:*.xbm=00;35:*.xpm=00;35:*.tif=00;35:*.tiff=00;35:*.png=00;35:*.mng=00;35:*.pcx=00;35:*.mov=00;35:*.mpg=00;35:*.mpeg=00;35:*.m2v=00;35:*.mkv=00;35:*.ogm=00;35:*.mp4=00;35:*.m4v=00;35:*.mp4v=00;35:*.vob=00;35:*.qt=00;35:*.nuv=00;35:*.wmv=00;35:*.asf=00;35:*.rm=00;35:*.rmvb=00;35:*.flc=00;35:*.avi=00;35:*.fli=00;35:*.gl=00;35:*.dl=00;35:*.xcf=00;35:*.xwd=00;35:*.yuv=00;35:*.svg=00;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:"
	alias ls='ls --color'
	;;
esac

# History configuration
export HISTSIZE=10000           # number of lines in history file
export HISTCONTROL=ignoreboth   # don't save already present commands
shopt -s histappend             # append commands to the history file, rather than overwrite it

# Save each command right after it has been executed
#export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# Set current directory for tmux enviroment
export PROMPT_COMMAND="[ -n \"\$TMUX\" ] && tmux setenv TMUXPWD_\$(tmux display -p \"#I#P\" 2>/dev/null) \$PWD 2>/dev/null" #; $PROMPT_COMMAND"

# Load local environment
if [ -f .bashrc_local ]; then
	. .bashrc_local
fi

# if locale was not set, use a standard one
#if [ -z "$(locale | grep -P "LANG=.+")" ]; then
#	export LANG=en_US.UTF-8
#fi
