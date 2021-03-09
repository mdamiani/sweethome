# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats 'on branch %b'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%n in ${PWD/#$HOME/~} ${vcs_info_msg_0_} > '

# Word splitting
#WORDCHARS=

########
# ALIAS
########
alias ls="ls --color"
alias ll="ls -l"


########################
# History Configuration
########################
HISTFILE=~/.zsh_history     # Where to save history to disk
HISTSIZE=100000             # How many lines of history to keep in memory
SAVEHIST=100000             # Number of history entries to save to disk
#HISTDUP=erase               # Erase duplicates in the history file

#setopt BANG_HIST                 # Treat the '!' character specially during expansion.
#setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
#setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
#setopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt INTERACTIVE_COMMENTS      # Allow bash style comments in shell.

#############
# COMPLETION
#############
#setopt AUTO_LIST                 # Automatically list choices on an ambiguous completion.
#setopt LIST_AMBIGUOUS            # Lists nothing if there if unambiguous.
#setopt MENU_COMPLETE             # Cycle through completitions
# use case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Bash style completion
setopt noautomenu
setopt nomenucomplete

###############
# KEY BINDINGS
###############

# PgUp e PgDn per l'autocompletamento
# in base alla history
bindkey "\e[5~": history-search-backward
bindkey "\e[6~": history-search-forward

# Pseudo vim mappings
bindkey "\el" forward-word
bindkey "\eh" backward-word
bindkey "\ej" history-beginning-search-forward   # vs history-search-forward
bindkey "\ek" history-beginning-search-backward  # vs history-search-backward
bindkey "\ed" kill-word
bindkey "\eD" backward-kill-word

# Load local settings
[[ ! -f ~/.zshrc_local ]] || source ~/.zshrc_local
