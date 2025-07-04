#!/bin/bash

# Fetch metadata from playerctl
ART=$(playerctl metadata mpris:artUrl | sed 's/^file:\/\///')
TITLE=$(playerctl metadata title)
ARTIST=$(playerctl metadata artist)

# Duration and position (in microseconds)
DURATION_MICRO=$(playerctl metadata mpris:length)
DURATION=$((DURATION_MICRO / 1000000))
POSITION=$(playerctl position | awk '{print int($1)}')

# Convert time format
format_time() {
  local s=$1
  printf "%02d:%02d" $((s/60)) $((s%60))
}

# JSON output
jq -n \
  --arg art "$ART" \
  --arg title "$TITLE" \
  --arg artist "$ARTIST" \
  --arg duration "$(format_time $DURATION)" \
  --arg position "$(format_time $POSITION)" \
  --argjson progress $((100 * POSITION / DURATION)) \
  '{
    art: $art,
    title: $title,
    artist: $artist,
    duration: $duration,
    position: $position,
    progress: $progress
  }'
