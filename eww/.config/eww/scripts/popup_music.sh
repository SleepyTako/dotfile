#!/bin/sh
eww="eww -c $HOME/.config/eww"

#$eww close music || (\
#    $eww open music ) 
# If already open, close it
if $eww get music_reveal | grep true >/dev/null; then
  $eww update music_reveal=false
  $eww close music
else
  $eww update music_reveal=true
  $eww open music
  # Start media updater if not running
  if ! pgrep -f media_info.sh >/dev/null; then
    $HOME/.config/eww/scripts/media_info.sh &
  fi
fi
