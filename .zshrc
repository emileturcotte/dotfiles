
  
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/snap/bin:$HOME/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:$PATH
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

export EDITOR="vim"

export ZSH="$HOME/.config/.oh-my-zsh"
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
plugins=(git
         emacs
         kubectl
         zsh-autosuggestions
         zsh-syntax-highlighting)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
         
source $ZSH/oh-my-zsh.sh
         
# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# User configuration

test -s ~/.alias && . ~/.alias || true

export CODE="$HOME/Documents/Code"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias k='kubectl'
alias d='docker'

# Rust
source "$HOME/.config/.cargo/env"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export CARGO_HOME="$HOME/.config/.cargo"

# GPG & SSH setup
export GNUPGHOME="$HOME/.config/.gnupg"
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=`gpgconf --list-dirs agent-ssh-socket`
gpgconf --launch gpg-agent


