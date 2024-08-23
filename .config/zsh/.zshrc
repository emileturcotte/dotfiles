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
# Shell Completion
#-----------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':git:*' script ~/.config/zsh/git-completion.bash
fpath=(~/.config/zsh $fpath)

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -U +X bashcompinit && bashcompinit

source <(kubectl completion zsh)
source $ZDOTDIR/az.completion
source $ZDOTDIR/_docker
source $ZDOTDIR/zsh-better-npm-completion.plugin.zsh

#-----------------------------
# Python
#-----------------------------
export PYENV_ROOT="$XDG_CONFIG_HOME/.config/pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

#-----------------------------
# Autosuggestion
#-----------------------------
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    export ZSH_AUTOSUGGEST_STRATEGY=completion
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
if [ -f /etc/profile.d/fzf.zsh ]; then
    source /etc/profile.d/fzf.zsh
fi

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
