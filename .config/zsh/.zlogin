# Start the Display server 
if systemctl -q is-active graphical.target && [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    /usr/bin/prime-switch
    exec startx -- -keeptty >~/.local/xorg/xorg.log 2>&1
fi
