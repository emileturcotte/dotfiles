#!/bin/sh
_dpi=96

export QT_AUTO_SCREEN_SCALE_FACTOR=1

xrandr --output DP-1-2 --set "PRIME Synchronization" 1
xrandr --output DP-2-2 --set "PRIME Synchronization" 1

xrandr --dpi $_dpi \
       --output eDP-1 --off \
       --output DP-1 --off \
       --output DP-2 --off \
       --output DP-3 --off \
       --output DP-1-1 --off \
       --output DP-1-2 --primary --mode 1920x1200 --pos 1920x0 --rate 60 --rotate normal \
       --output DP-1-3 --off \
       --output DP-2-1 --off \
       --output DP-2-2 --mode 1920x1200 --pos 3840x0 --rate 60 --rotate normal \
       --output DP-2-3 --off

echo "Xft.dpi: ${_dpi}" | xrdb -merge
echo 'awesome.restart()' | awesome-client
