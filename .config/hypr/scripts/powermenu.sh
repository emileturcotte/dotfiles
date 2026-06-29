#!/usr/bin/env bash
# Power / system menu via wofi — Émile Turcotte
# Bound to SUPER+Escape and the Waybar power button.

# Single-instance: if wofi is already open, close it and exit (toggle behaviour).
if pgrep -x wofi >/dev/null; then
    pkill -x wofi
    exit 0
fi

# Menu entries — icon + label (Nerd Font glyphs).
entries="  Lock
  Logout
  Suspend
  Reboot
  Shutdown"

selected=$(printf '%s\n' "$entries" | wofi \
    --dmenu \
    --prompt "Power" \
    --width 260 --height 280 \
    --cache-file /dev/null \
    | awk '{print tolower($NF)}')

case "$selected" in
    lock)     hyprlock ;;
    logout)
        # start-hyprland is a watchdog, so exiting the compositor alone isn't
        # enough — terminate the whole logind session to drop back to greetd.
        if [ -n "$XDG_SESSION_ID" ]; then
            loginctl terminate-session "$XDG_SESSION_ID"
        else
            loginctl terminate-user "$USER"
        fi
        ;;
    suspend)  systemctl suspend ;;
    reboot)   systemctl reboot ;;
    shutdown) systemctl poweroff ;;
    *)        exit 0 ;;
esac
