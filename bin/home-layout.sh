export QT_AUTO_SCREEN_SCALE_FACTOR=1

_dpi=96
_laptop_output="eDP-1"
_primary_output="DP-1-1-8"
_secondary_output="DP-1-1-1"

xrandr --output $_primary_output --set "PRIME Synchronization" 1
xrandr --output $_secondary_output --set "PRIME Synchronization" 1

xrandr \
 --dpi $_dpi
 --output $_laptop_output --auto --scale 1.25x1.25 \
 --output DP-1 --off \
 --output DP-2 --off \
 --output DP-3 --off \
 --output DP-1-1 --off \
 --output $_primary_output --auto --right-of $_laptop_output --primary \
 --output $_secondary_output --auto --right-of $_secondary_output

echo "Xft.dpi: ${_dpi}" | xrdb -merge
echo 'awesome.restart()' | awesome-client
