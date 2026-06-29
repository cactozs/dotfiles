#!/usr/bin/env bash
CURRENT=$(cat ~/.config/theme-current 2>/dev/null || echo dark)
if [ "$CURRENT" == "light" ]; then
    printf '{"text": "🌙", "alt": "light"}'
else
    printf '{"text": "☀", "alt": "dark"}'
fi
