#!/usr/bin/env bash

# Set wallpaper using symlink at ~/.config/hypr/current_wallpaper
CURRENT_WALLPAPER=~/.config/hypr/current_wallpaper

# Use swww to set the wallpaper
swww img "$CURRENT_WALLPAPER"
