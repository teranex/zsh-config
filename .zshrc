# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Environment variables
export LANGUAGE=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
# export LC_TIME=en_DK.UTF-8
export KEYID=610DB834
export PGPKEY=610DB834
export EDITOR=vi
export VISUAL=vi
export PATH=$PATH:~/scripts:~/.local/bin #:/opt/path/bin/
export EMAIL=jeroen@$HOST # git commit e-mail


# Options
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
#     backward-char
# )

## History
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"       # The path to the history file.
HISTSIZE=100000
SAVEHIST=100000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

## Directory
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.

# Autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# Keybindings
bindkey -v
# export KEYTIMEOUT=1

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

cdUndoKey() {
  popd      > /dev/null
  zle       reset-prompt
  zle push-line
  zle accept-line
}

cdParentKey() {
  pushd .. > /dev/null
  zle      reset-prompt
  zle push-line
  zle accept-line
}

zle -N                 cdParentKey
zle -N                 cdUndoKey
bindkey '^[[1;3D'      cdParentKey
bindkey '^[[1;3C'      cdUndoKey
# autosuggestions
bindkey '^[[1;2C' forward-word
# substring search
# https://www.reddit.com/r/zsh/comments/kae8yg/comment/gfa129q/
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# Aliases
alias cdr='cd $(git rev-parse --show-toplevel)'
alias gti=git # How often have I made this typo??
alias :q=exit
alias ls='ls --group-directories-first --color=auto'
alias ll='ls -lh'

# export NPM_STORE="${HOME}/.npm-packages"
# export PATH="$PATH:$NPM_STORE/bin"

# export TEXAS_CONFIG_SIZE=90
# export TEXAS_CONFIG_TMUX_CONFIG=~/scripts/tmux/texas.config

# export VIMPAGER=~/scripts/vimpager
# if [ -f /opt/vimpager/vimpager ]; then
#     export VIMPAGER=/opt/vimpager/vimpager
# fi

# # unalias some stuff from prezto
# unalias o
# unalias rm
# setopt noextendedglob

# alias man="PAGER=$VIMPAGER man"
# alias tmux="if tmux has; then tmux -2 attach; else tmux -2 new; fi"
# alias irssi="TERM=screen irssi" # because i want working scrolling in irssi...
# alias rg='/opt/ripgrep/rg -S'
# alias r=ranger
# alias fd=fdfind # fd is named fdfind in ubuntu repos
# alias p2r="PATH=$PATH:/home/jeroen/.local/bin p2r -v --rmapi /home/jeroen/go/bin/rmapi --css /home/jeroen/scripts/remarkable/paper2remarkable.css"

# Functions
function o() {
    if [ $# -eq 0 ]; then
        thunar > /dev/null 2>&1 &
    else
        if [[ $1 =~ "^thunderlink.*" ]]; then
            echo opening as thunderlink
            thunderbird -thunderlink "$1"
        elif [[ $1 =~ "^.*@.*$" ]] ; then
            # looks like an email address, try to open it in thunderbird as a thunderlink
            echo opening as thunderlink
            thunderbird -thunderlink "thunderlink://messageid=$1"
        else
            xdg-open $1
        fi
    fi
}

# function j() {
#     # local TARGET=`(cat ~/bashmarks && find /home/jeroen/Projecten/ -maxdepth 3 -type d -not -path '*/\.*' && find /home/jeroen/Customers/ -maxdepth 3 -type d -not -path '*/\.*') | fzf --extended --query="$1" --select-1`
#     local TARGET=`~/scripts/list-my-dirs.sh | fzf --extended --query="$1" --select-1`
#     if [ $? -eq 0 ]; then
#         cd $TARGET
#     fi
# }


#This is based on: https://github.com/ranger/ranger/blob/master/examples/bash_automatic_cd.sh
# function ranger-cd {
#     tempfile="$(mktemp -t tmp.XXXXXX)"
#     ranger --choosedir="$tempfile" "${@:-$(pwd)}"
#     test -f "$tempfile" &&
#     if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
#       cd -- "$(cat "$tempfile")"
#     fi
#     rm -f -- "$tempfile"
# }

# bindkey -s '^O' 'ranger-cd\n'
#ranger-cd will fire for Ctrl+O


# http://alias.sh/make-and-cd-directory
function mkcd() {
    mkdir -p "$1" && cd "$1";
}


# Enable and configure FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_COMPLETION_TRIGGER='~~'
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="fd"
export FZF_DEFAULT_OPTS='
  --color fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81
  --color info:144,prompt:161,spinner:135,pointer:135,marker:118'

# Load command-not-found on Debian-based distributions.
if [[ -s '/etc/zsh_command_not_found' ]]; then
  source '/etc/zsh_command_not_found'
# Load command-not-found on Arch Linux-based distributions.
elif [[ -s '/usr/share/doc/pkgfile/command-not-found.zsh' ]]; then
  source '/usr/share/doc/pkgfile/command-not-found.zsh'
# Return if requirements are not found.
else
  return 1
fi

# The following lines were added by compinstall
zstyle :compinstall filename "$ZDOTDIR/.zshrc"

autoload -Uz compinit && compinit -i

# Case insensitive completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'

# End of lines added by compinstall
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

source $ZDOTDIR/plugins/zsh-auto-notify/auto-notify.plugin.zsh
# Auto notify
AUTO_NOTIFY_IGNORE+=("docker" "vi" "git l" "git co")

source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh


source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
