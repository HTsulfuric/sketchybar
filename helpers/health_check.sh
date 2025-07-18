#!/bin/bash

# SketchyBar Health Check Script
# Ensures media_item and pomodoro_item script settings persist after sleep/wake

check_and_fix_media_script() {
    # Check if media_item script is properly set
    local current_script=$(sketchybar --query media_item | grep '"script":' | cut -d'"' -f4)
    
    if [[ "$current_script" == "" ]] || [[ "$current_script" == "(null)" ]]; then
        echo "$(date): Health check detected missing media script, fixing..." >&2
        
        # Re-apply the script setting
        sketchybar --set media_item script="~/.config/sketchybar/helpers/update_media.sh" update_freq=2
        
        # Force immediate update
        ~/.config/sketchybar/helpers/update_media.sh &
        
        echo "$(date): Media script setting restored" >&2
    fi
}

check_and_fix_pomodoro_script() {
    # Check if pomodoro_item script is properly set
    local current_script=$(sketchybar --query pomodoro_item | grep '"script":' | cut -d'"' -f4)
    
    if [[ "$current_script" == "" ]] || [[ "$current_script" == "(null)" ]]; then
        echo "$(date): Health check detected missing pomodoro script, fixing..." >&2
        
        # Re-apply the script setting
        sketchybar --set pomodoro_item script="~/.config/sketchybar/helpers/update_pomodoro.sh" update_freq=1
        
        # Force immediate update
        ~/.config/sketchybar/helpers/update_pomodoro.sh &
        
        echo "$(date): Pomodoro script setting restored" >&2
    fi
}

# Execute health checks
check_and_fix_media_script
check_and_fix_pomodoro_script