# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/snap/bin:/home/emileturcotte/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:$PATH
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

export EDITOR="emacsclient -t -a ''"
export VISUAL="emacsclient -c -a emacs"

export ZSH="/home/emileturcotte/.config/.oh-my-zsh"
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
plugins=(git
         emacs
         tmux
 	 kubectl)
         
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
source "/home/emileturcotte/.config/.cargo/env"

alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
alias k='kubectl'
alias d='docker'

export CODE_PATH="$HOME/Documents/Code"
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=`gpgconf --list-dirs agent-ssh-socket`
gpgconf --launch gpg-agent
