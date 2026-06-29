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
if command -v gpgconf >/dev/null; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
fi

#-----------------------------
# Shell Completion
#-----------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
fpath=(~/.config/zsh $fpath)

# compinit: rebuild the dump only if missing or >24h old; otherwise load the
# cached one and skip the slow fpath security scan (-C).
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi
autoload -Uz promptinit && promptinit
autoload -U +X bashcompinit && bashcompinit

# Tool completions: generating them forks the tool on every shell start (the
# main startup cost). Cache the output once, then source the cache thereafter.
_compcache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
for _tool in kubectl helm docker; do
    command -v "$_tool" >/dev/null || continue
    _cf="$_compcache/${_tool}.zsh"
    [[ -s "$_cf" ]] || { mkdir -p "$_compcache"; "$_tool" completion zsh >"$_cf" 2>/dev/null; }
    source "$_cf"
done
unset _tool _cf _compcache

# azure-cli has no native zsh completion; this is its argcomplete bridge.
source $ZDOTDIR/az.completion
source $ZDOTDIR/zsh-better-npm-completion.plugin.zsh

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
command -v starship >/dev/null && eval "$(starship init zsh)"

### Zoxide ###
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
