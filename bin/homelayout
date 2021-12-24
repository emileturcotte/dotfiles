#!/bin/sh

export QT_AUTO_SCREEN_SCALE_FACTOR=1

_dpi=96
_laptop="eDP-1"
_primary="DP-1-1-8"
_secondary="DP-1-1-1"

xrandr --output $_primary --set "PRIME Synchronization" 1
xrandr --output $_secondary --set "PRIME Synchronization" 1

xrandr --dpi $_dpi \
       --output $_laptop --mode 1920x1080 --pos 0x0 --scale 1x1 \
       --output DP-1 --off \
       --output DP-2 --off \
       --output DP-3 --off \
       --output DP-1-1 --off \
       --output $_primary --primary --mode 1920x1080 --right-of $_laptop --rate 60 --rotate normal \
       --output $_secondary --mode 1920x1080 --right-of $_primary --rate 60 --rotate normal

echo "Xft.dpi: ${_dpi}" | xrdb -merge
echo 'awesome.restart()' | awesome-client
