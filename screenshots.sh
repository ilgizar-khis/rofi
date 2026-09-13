#!/usr/bin/bash
lines=""
dir="$(xdg-user-dir PICTURES)/Screenshots"

count="$(ls -1 $dir | wc -l)"
if [[ "$count" == "0" ]]; then
	exit 0
fi
for file in $dir/*; do
	if [ -z "$file" ]; then
		exit 0
	fi
	lines="$(basename $file)\0icon\x1f$file\n$lines"
done

selected="$(echo -en "$lines" | PREVIEW=true rofi -dmenu -theme $HOME/.config/rofi/themes/preview.rasi)"

if [ -n "$selected" ]; then
	satty --filename "$dir/$selected" --output-filename "$dir/selected"
	cat "$dir/$selected" | wl-copy  -t image/png
fi
