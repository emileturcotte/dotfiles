if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx -- -keeptty >~/.local/xorg/xorg.log 2>&1
fi
