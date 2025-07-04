#!/bin/sh

# Selects player based on if they're playing or if they provide a cover image
# Note: Being played takes priority
select_player () {
	playingplayer=""
	coverplayer=""
	totalplayer=""
	playerctl -l 2> /dev/null | while read -r player;
	do
		art=`playerctl --player="$player" metadata mpris:artUrl 2> /dev/null`
		status=`playerctl --player="$player" status 2> /dev/null`
		[[ $status == "Playing" ]] && playingplayer="$player"
		[[ $art != "" ]] && coverplayer="$player"
		[[ $status == "Playing" && $art != "" ]] && totalplayer="$player"
		[[ ! -z $coverplayer ]] && player="$coverplayer"
		[[ ! -z $playingplayer ]] && player="$playingplayer"
		[[ ! -z $totalplayer ]] && player="$totalplayer"
		echo "$player"
	done;
}
	

# Get general info 
eww="eww -c $HOME/.config/eww"
player=`select_player | tail -1`
status=`playerctl --player="$player" status 2> /dev/null`
[[ $status == "" ]] && exit

# Toggle play pause and update status accordingly
toggle () {
    [[ $status == "Playing" ]] && $eww update media_status=""|| $eww update media_status=""
    playerctl --player="$player" play-pause 2> /dev/null
}

# Seek to an specific time 
seek () {
    seekt="$1"    
    position=`playerctl --player=$player position 2> /dev/null`
    if [[ $? -eq 0 ]]
    then
        playerctl --player=$player position $seekt 2> /dev/null
    fi;
}

# Rewind or fast forward 5 seconds
move () {
	move="$1"             
    startpos=`playerctl --player=$player position 2> /dev/null`	
	length=`playerctl --player="$player" metadata mpris:length 2> /dev/null`
	length=`python -c "print($length/1000000)"`
	if [[ $? -eq 0 ]]
	then
		endpos=`python -c "print(min($length, max(0, $startpos $move)))"`
		playerctl --player=$player position $endpos 2> /dev/null
	fi;
}
	

case $1 in
    --toggle )
        toggle
        ;;
	--seek )
		[[ $3 == "true" ]] && seek $2
		;;
	--move )
		move $2
		;;
	--next )
		playerctl --player=$player next 2> /dev/null
		;;
	--prev )
		playerctl --player=$player previous 2> /dev/null
		;;
esac
