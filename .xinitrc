#!/bin/sh

userresources=$HOME/.config/.Xresources
usermodmap=$HOME/.config/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xbindkeys &

# make CapsLock behave like Ctrl:
setxkbmap -option ctrl:nocaps &

# make short-pressed Ctrl behave like Escape:
xcape -e 'Control_L=Escape' -t 100 &

# Launch Window Manager
_logdir='.cache/awesome'

/usr/bin/prime-offload &
autorandr -c
exec /usr/bin/awesome >> $_logdir/stdout 2>> $_logdir/stderr
