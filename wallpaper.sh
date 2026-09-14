#!/usr/bin/bash
lines=""

# WALLPAPERS="$(xdg-user-dir PICRURES)/backgrounds"
[ -n "$WALLPAPERS" ] && dir="$WALLPAPERS" || dir="$(xdg-user-dir PICTURES)/backgrounds"

count="$(ls -1 $dir | wc -l)"
if [[ "$count" == "0" ]]; then
	exit 0
fi
for file in $dir/*.jpg; do
	if [ -z "$file" ]; then
		exit 0
	fi
	lines="$(basename $file)\0icon\x1f$file\n$lines"
done

selected="$(echo -en "$lines" | PREVIEW=true rofi -dmenu -theme $HOME/.config/rofi/themes/preview.rasi)"

if [ -z "$selected" ]; then
	exit 0
fi

monitor="$(hyprctl monitors -j | jq -r '.[].name?' | rofi -dmenu)"

if [ -z "$monitor" ]; then
	exit 0
fi

wallpapers="$HOME/Pictures/Wallpapers/"
if [ -n "$selected" ] && [ -n "$monitor" ]; then
	if [ -e "$wallpapers/$monitor.jpg" ]; then
		rm "$wallpapers/$monitor.jpg"
	fi

	cp "$dir/$selected" "$wallpapers/$monitor.jpg"
	swaybg -o "$monitor" -i "$wallpapers/$monitor.jpg" &> /dev/null & 
fi
