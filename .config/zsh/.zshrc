# User configuration

test -s ~/.alias && . ~/.alias || true

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias k='kubectl'
alias d='docker'
alias g='git'
alias blue='bluetoothctl'
alias vpn='protonvpn-cli'
alias lf='lfub'
alias rm='rm -i'

### Doom Emacs ###
export DOOMDIR="$HOME/.config/doom"

alias doomsync="~/.emacs.d/bin/doom sync"
alias doomdoctor="~/.emacs.d/bin/doom doctor"
alias doomupgrade="~/.emacs.d/bin/doom upgrade"
alias doompurge="~/.emacs.d/bin/doom purge"

### GPG & SSH ###
export GNUPGHOME="$HOME/.config/gnupg"
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=`gpgconf --list-dirs agent-ssh-socket`
gpgconf --launch gpg-agent

### dotNET ###
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH="$PATH:~/.dotnet/tools"
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

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

### Starship ###
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
eval "$(starship init zsh)"
