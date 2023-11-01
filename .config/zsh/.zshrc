# User configuration

test -s $ZDOTDIR/alias && . $ZDOTDIR/alias || true

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

### GPG & SSH ###
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

### dotNET ###
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

### Shell Completion ###
zstyle ':completion:*:*:git:*' script ~/.config/zsh/git-completion.bash
fpath=(~/.config/zsh $fpath)

autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

source <(kubectl completion zsh)
source ~/.config/zsh/az.completion
source ~/.config/zsh/_docker

### ZSH Autosuggestion ###
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

### ZSH Syntax Highlighting ###
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

### ZSH VI Mode ###
if [ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]; then
    source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

### FZF ###
if [ -f /etc/profile.d/fzf.zsh ]; then
    source /etc/profile.d/fzf.zsh
fi

### Starship ###
eval "$(starship init zsh)"
