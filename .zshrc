export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="emacsclient -t -a ''"
export VISUAL="emacsclient -c -a 'emacs'"

export PATH=$HOME/bin:/usr/local/bin:/snap/bin:$HOME/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:$PATH:$HOME/.emacs.d/bin

### ZSH
export ZSH="$HOME/.config/.oh-my-zsh"
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git
         kubectl
         zsh-autosuggestions
         zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
         
source $ZSH/oh-my-zsh.sh
         
# User configuration

test -s ~/.alias && . ~/.alias || true

export CODE="$HOME/Documents/Code"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias k='kubectl'
alias d='docker'
alias blue='bluetoothctl'
alias vpn='protonvpn-cli'

### Doom Emacs ###
export DOOMDIR="$HOME/.config/doom"

alias doomsync="~/.emacs.d/bin/doom sync"
alias doomdoctor="~/.emacs.d/bin/doom doctor"
alias doomupgrade="~/.emacs.d/bin/doom upgrade"
alias doompurge="~/.emacs.d/bin/doom purge"

### Rust ###
source "$HOME/.config/.cargo/env"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export CARGO_HOME="$HOME/.config/.cargo"

### GPG & SSH ###
export GNUPGHOME="$HOME/.config/.gnupg"
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=`gpgconf --list-dirs agent-ssh-socket`
gpgconf --launch gpg-agent

### dotNET ###
export DOTNET_CLI_TELEMETRY_OPTOUT=1

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

### Starship ###
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
eval "$(starship init zsh)"
