
  
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/snap/bin:$HOME/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:$PATH:$HOME/.emacs.d/bin
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

export EDITOR="emacsclient -c -a 'emacs'"

export ZSH="$HOME/.config/.oh-my-zsh"
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
plugins=(git
	 archlinux
         emacs
         kubectl
         zsh-autosuggestions
         zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
         
source $ZSH/oh-my-zsh.sh
         
# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# User configuration

test -s ~/.alias && . ~/.alias || true

export CODE="$HOME/Documents/Code"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias k='kubectl'
alias d='docker'
alias blue='bluetoothctl'

# Doom Emacs
export DOOMDIR="$HOME/.config/doom"

# Rust
source "$HOME/.config/.cargo/env"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export CARGO_HOME="$HOME/.config/.cargo"

# GPG & SSH setup
export GNUPGHOME="$HOME/.config/.gnupg"
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=`gpgconf --list-dirs agent-ssh-socket`
gpgconf --launch gpg-agent

# dotNET
export DOTNET_CLI_TELEMETRY_OPTOUT=1
# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"
eval "$(starship init zsh)"
