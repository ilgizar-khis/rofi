#!/usr/bin/bash
lines=""

# WALLPAPERS="$(xdg-user-dir PICRURES)/backgrounds"
[ -n "$WALLPAPERS" ] &&
	dir="$WALLPAPERS" ||
	dir="$(xdg-user-dir PICTURES)/backgrounds"

for file in $dir/*.jpg $dir/*.png $dir/*.webp; do
	[[ -f "$file" ]] &&
		filename="$(basename $file)" \
		lines="$filename\0icon\x1f$file\n$lines"
done

selected="$(echo -en "$lines" | PREVIEW=true rofi -dmenu -theme preview.rasi)"

[ -z "$selected" ] && exit 0

monitor="$(hyprctl monitors -j | jq -r '.[].name?' | rofi -dmenu)"

[ -z "$monitor" ] && exit 0

[ -e "$dir/$monitor.jpg" ] &&
	rm "$dir/$monitor.jpg"

cp "$dir/$selected" "$dir/$monitor.jpg" &&
	swaybg -o "$monitor" -i "$dir/$monitor.jpg" &>/dev/null &
