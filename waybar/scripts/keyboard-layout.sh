#!/usr/bin/env bash

# Получаем активную раскладку из Niri
layout=$(niri msg keyboard-layouts | grep '*' | awk '{print $2}')

# Преобразуем код раскладки в флаг
case "$layout" in
    us)      echo "🇺🇸" ;;
    ru)      echo "🇷🇺" ;;
    ua)      echo "🇺🇦" ;;
    de)      echo "🇩🇪" ;;
    fr)      echo "🇫🇷" ;;
    es)      echo "🇪🇸" ;;
    it)      echo "🇮🇹" ;;
    pl)      echo "🇵🇱" ;;
    by)      echo "🇧🇾" ;;
    tr)      echo "🇹🇷" ;;
    *)       echo "$layout" ;;   # если раскладка неизвестна — показываем как есть
esac
