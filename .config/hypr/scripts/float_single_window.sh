#!/bin/bash

workspace=$(hyprctl activeworkspace -j | jq -r '.id')

clients=$(hyprctl clients -j)

clients_in_ws=$(echo "$clients" | jq --arg ws "$workspace" '[.[] | select(.workspace.id == ($ws | tonumber))]')

count=$(echo "$clients_in_ws" | jq 'length')

if [ "$count" -eq 1 ]; then
    window_address=$(echo "$clients_in_ws" | jq -r '.[0].address')

    echo "Found single window: $window_address on workspace $workspace"

    monitor=$(hyprctl monitors -j | jq '.[] | select(.focused)')
    mon_x=$(echo "$monitor" | jq '.width')
    mon_y=$(echo "$monitor" | jq '.height')

    width=$(( mon_x * 9 / 10 ))
    height=$(( mon_y * 9 / 10 ))
    offset_x=$(( (mon_x - width) / 2 ))
    offset_y=$(( (mon_y - height) / 2 ))

    # Focus window first
    hyprctl dispatch focuswindow address:$window_address
    sleep 0.1

    # Toggle floating (if already floating, this toggles it off, so safer to ensure it's floating)
    hyprctl dispatch togglefloating address:$window_address
    sleep 0.1

    # Resize and move
    hyprctl dispatch resizewindowpixel exact $width $height
    sleep 0.1
    hyprctl dispatch movewindowpixel exact $offset_x $offset_y
else
    echo "Number of windows in workspace $workspace: $count"
fi
