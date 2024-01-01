# User configuration

test -s $ZDOTDIR/alias && . $ZDOTDIR/alias || true

#-----------------------------
# Options
#-----------------------------
unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

#-----------------------------
# Aliases
#-----------------------------
source $ZDOTDIR/config.d/keybindings.zsh

#-----------------------------
# GPG & SSH
#-----------------------------
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

#-----------------------------
# DotNET
#-----------------------------
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

#-----------------------------
# Shell Completion
#-----------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':git:*' script ~/.config/zsh/git-completion.bash
fpath=(~/.config/zsh $fpath)

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -U +X bashcompinit && bashcompinit
compctl -K _dotnet_zsh_complete dotnet

source <(kubectl completion zsh)
source $ZDOTDIR/az.completion
source $ZDOTDIR/_docker
source $ZDOTDIR/zsh-better-npm-completion.plugin.zsh

#-----------------------------
# Autosuggestion
#-----------------------------
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

#-----------------------------
# Vi Mode
#-----------------------------
if [ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]; then
    source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

#-----------------------------
# FZF
#-----------------------------
#if [ -f /etc/profile.d/fzf.zsh ]; then
#    source /etc/profile.d/fzf.zsh
#fi

#-----------------------------
# Syntax Highlighting
#-----------------------------
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


### Starship ###
eval "$(starship init zsh)"

### Zoxide ###
eval "$(zoxide init zsh)"
