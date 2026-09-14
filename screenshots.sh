#!/usr/bin/bash
lines=""
dir="$(xdg-user-dir PICTURES)/Screenshots"

for file in $dir/*.png; do
	[[ -f "$file" ]] &&
		filename="$(basename $file)" \
		lines="$filename\0icon\x1f$file\n$lines"
done

export PREVIEW=true
selected="$(echo -en "$lines" | rofi -dmenu -theme preview.rasi)"

if [ -n "$selected" ]; then
	satty --filename "$dir/$selected" --output-filename "$dir/selected"
	cat "$dir/$selected" | wl-copy -t image/png
fi
