#!/usr/bin/env bash

# CPU usage
read -r cpu user nice system idle iowait irq softirq steal rest < /proc/stat

total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle1=$((idle + iowait))

sleep 0.1

read -r cpu user nice system idle iowait irq softirq steal rest < /proc/stat

total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle2=$((idle + iowait))

total_diff=$((total2 - total1))
idle_diff=$((idle2 - idle1))

if (( total_diff > 0 )); then
    cpu_usage=$((100 * (total_diff - idle_diff) / total_diff))
else
    cpu_usage=0
fi

# CPU temperature
cpu_temp="N/A"

for zone in /sys/class/thermal/thermal_zone*/temp; do
    if [[ -r "$zone" ]]; then
        temp=$(cat "$zone")
        if (( temp > 20000 && temp < 110000 )); then
            cpu_temp="$((temp / 1000))°C"
            break
        fi
    fi
done

# GPU
gpu_temp="N/A"
gpu_usage="N/A"

if command -v nvidia-smi >/dev/null 2>&1; then
    gpu_data=$(nvidia-smi \
        --query-gpu=temperature.gpu,utilization.gpu \
        --format=csv,noheader,nounits 2>/dev/null)

    if [[ -n "$gpu_data" ]]; then
        gpu_temp=$(echo "$gpu_data" | awk -F', ' '{print $1 "°C"}')
        gpu_usage=$(echo "$gpu_data" | awk -F', ' '{print $2 "%"}')
    fi
fi

# RAM
read -r _ total used free shared buff_cache available _ < <(free -b)

ram_usage=$((100 * (total - available) / total))

ram_used=$(numfmt --format="%.1f GiB" "$((total - available))")
ram_total=$(numfmt --format="%.1f GiB" "$total")

# Network
rx1=$(awk 'NR>2 {sum += $2} END {print sum+0}' /proc/net/dev)
tx1=$(awk 'NR>2 {sum += $10} END {print sum+0}' /proc/net/dev)

sleep 0.1

rx2=$(awk 'NR>2 {sum += $2} END {print sum+0}' /proc/net/dev)
tx2=$(awk 'NR>2 {sum += $10} END {print sum+0}' /proc/net/dev)

rx_rate=$(( (rx2 - rx1) * 10 ))
tx_rate=$(( (tx2 - tx1) * 10 ))

format_speed() {
    local bytes="$1"

    if (( bytes >= 1048576 )); then
        awk "BEGIN {printf \"%.1f MiB/s\", $bytes / 1048576}"
    elif (( bytes >= 1024 )); then
        awk "BEGIN {printf \"%.1f KiB/s\", $bytes / 1024}"
    else
        echo "${bytes} B/s"
    fi
}

rx_speed=$(format_speed "$rx_rate")
tx_speed=$(format_speed "$tx_rate")

# Waybar output
tooltip="\
CPU
Temperature: $cpu_temp
Usage:       $cpu_usage%

GPU
Temperature: $gpu_temp
Usage:       $gpu_usage

Memory
Used:        $ram_used / $ram_total
Usage:       $ram_usage%

Network
↓ $rx_speed
↑ $tx_speed"

jq -cn \
    --arg text "󰍛" \
    --arg tooltip "$tooltip" \
    '{text: $text, tooltip: $tooltip}'
