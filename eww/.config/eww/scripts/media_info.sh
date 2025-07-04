#!/bin/bash

eww="eww -c $HOME/.config/eww"
imgdir="$HOME/.config/eww/images"
mkdir -p "$imgdir"

player="spotify"

# Status icon
status=$(playerctl --player="$player" status 2>/dev/null)
if [[ $status == "Playing" ]]; then
  $eww update media_status=""
else
  $eww update media_status=""
fi

# Title
title=$(playerctl --player="$player" metadata title 2>/dev/null)
[[ -z $title ]] && title="No title"
$eww update title="$title"
$eww update title_parsed="$title" # (replace with scroll logic if needed)

# Artist
artist=$(playerctl --player="$player" metadata artist 2>/dev/null)
[[ -z $artist ]] && artist="No artist"
$eww update artist="$artist"
$eww update artist_parsed="$artist"

# Position and Duration
pos=$(playerctl --player="$player" position 2>/dev/null | awk '{print int($1)}')
len=$(playerctl --player="$player" metadata mpris:length 2>/dev/null)
len=$((len / 1000000))
[[ $len -eq 0 ]] && len=100
$eww update position="$pos"
$eww update length="$len"

# Cover art handling
newimg=$(playerctl --player="$player" metadata mpris:artUrl 2>/dev/null)
cover_path="$imgdir/currmedia.png"

if [[ "$newimg" == file://* ]]; then
  cp "${newimg#file://}" "$imgdir/currmedia_fullsize.png"
  convert "$imgdir/currmedia_fullsize.png" -resize 130x130 "$cover_path"
elif [[ "$newimg" == http* ]]; then
  curl -s --max-time 5 "$newimg" -o "$imgdir/currmedia_fullsize.png"
  convert "$imgdir/currmedia_fullsize.png" -resize 130x130 "$cover_path"
else
  cp "$imgdir/music.png" "$cover_path"
fi

$eww update cover="$cover_path"
