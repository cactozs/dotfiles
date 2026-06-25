#!/usr/bin/env bash

TIME=$(date '+%H:%M')

WEATHER=$(curl -s --max-time 5 "https://wttr.in/?format=%c+%t" 2>/dev/null || echo "N/A")

echo "{\"text\": \"󰥔 $TIME\", \"tooltip\": \"$WEATHER\"}"
