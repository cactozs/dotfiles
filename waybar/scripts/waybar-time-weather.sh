#!/usr/bin/env bash

TIME=$(date '+%H:%M')

LOCATION_FILE="$HOME/.config/waybar/location"
LOCATION=""
if [ -f "$LOCATION_FILE" ]; then
    LOCATION=$(head -1 "$LOCATION_FILE" | tr -d '\n')
fi

# Build URL: prefer explicit location; fall back to IP-based lookup if empty.
if [ -n "$LOCATION" ]; then
    URL="https://wttr.in/${LOCATION}?m&format=%c+%t"
else
    URL="https://wttr.in/?m&format=%c+%t"
fi

WEATHER=$(curl -s --max-time 5 "$URL" 2>/dev/null || echo "N/A")

# JSON-escape special chars.
WEATHER_ESC=$(printf '%s' "$WEATHER" | sed 's/\\/\\\\/g; s/"/\\"/g')

printf '{"text": "󰥔 %s", "tooltip": "%s"}\n' "$TIME" "$WEATHER_ESC"
