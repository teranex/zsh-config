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


# History
## based on history plugin in prezto
HISTFILE="$HOME/.zhistory"       # The path to the history file.
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
## based on directory plugin in prezto
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


# Keybindings
bindkey -v
export KEYTIMEOUT=1
## edit a command in vi
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd V edit-command-line

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

cdUndoKey() {
  popd      > /dev/null
  zle       reset-prompt
  # reset-prompt doesn't work in Powerlevel10k, see
  # https://github.com/romkatv/powerlevel10k/issues/72#issuecomment-1008262525
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

# make ctrl-q work to push current line
unsetopt flow_control
bindkey '^Q' push-line


# Aliases
alias cdr='cd $(git rev-parse --show-toplevel)'
alias gti=git # How often have I made this typo??
alias :q=exit
alias ls='ls --group-directories-first --color=auto'
alias ll='ls -lh'


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

# http://alias.sh/make-and-cd-directory
function mkcd() {
    mkdir -p "$1" && cd "$1";
}


# Completion
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
autoload -Uz compinit && compinit -i
# Case insensitive completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'


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


# Enable and configure FZF and fzf-tab
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_COMPLETION_TRIGGER='~~'
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="fd"
export FZF_DEFAULT_OPTS='
  --color fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81
  --color info:144,prompt:161,spinner:135,pointer:135,marker:118'

source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'


# enchancd
source $ZDOTDIR/plugins/enhancd/init.sh


# Auto notify
source $ZDOTDIR/plugins/zsh-auto-notify/auto-notify.plugin.zsh
AUTO_NOTIFY_IGNORE+=("docker" "vi" "git l" "git co" "git ca" "git vimdiff")


# Auto suggestions
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# Syntax highlighting
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# History substring search
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh


# Powerlevel10k prompt
source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
