#!/bin/bash

# Default save directory
SAVE_DIR="$HOME/Pictures/Screenshots"

# Ensure the save directory exists
mkdir -p "$SAVE_DIR"

# Dependencies: grim, slurp, wl-copy, wofi
check_dependencies() {
    for cmd in grim slurp wl-copy wofi; do
        if ! command -v $cmd &> /dev/null; then
            echo "Error: $cmd is not installed. Please install it."
            exit 1
        fi
    done
}

# Show Wofi menu for selection
show_menu() {
    local prompt="$1"
    shift
    local options=("$@")
    printf "%s\n" "${options[@]}" | wofi --show dmenu --prompt="$prompt"
}

# Take a screenshot based on mode
take_screenshot() {
    local mode="$1"
    local timestamp
    timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
    local filepath="$SAVE_DIR/screenshot_$timestamp.png"

    case $mode in
        region)
            grim -g "$(slurp)" - | wl-copy
            ;;
        full)
            sleep 0.5
            grim "$filepath" | wl-copy
            ;;
        window)
            sleep 0.5
            grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$filepath" | wl-copy
            ;;
    esac

    # Notify user
    notify-send "Grim : " "Screenshot copied to clipboard."
}

# Main function
main() {
    check_dependencies

    # Step 1: Ask for mode
    local mode
    mode=$(show_menu "Select mode" "region" "full" "window")
    [[ -z "$mode" ]] && exit 0 # Exit if no selection

    # Step 2: Take screenshot
    take_screenshot "$mode"
}

main
