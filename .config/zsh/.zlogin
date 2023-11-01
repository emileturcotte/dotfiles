# .zlogin is for login shells. It is sourced on the start of a login shell but after .zshrc, if the shell is also interactive. This file is often used to start X using startx. Some systems start X on boot, so this file is not always very useful.

# Start the Display server 
if systemctl -q is-active graphical.target && [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    sudo prime-switch > /dev/null
    exec startx -- -keeptty >~/.local/xorg/xorg.log 2>&1
fi
