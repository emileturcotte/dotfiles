if status --is-interactive
    set -x GPG_TTY (tty)
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

    set -x RUSTUP_HOME "/home/emileturcotte/.config/.rustup"
    set -x CARGO_HOME "/home/emileturcotte/.config/.cargo"
    
    gpgconf --launch gpg-agent
end
