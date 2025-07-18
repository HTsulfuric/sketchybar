#!/bin/bash

# Sleep/Wake monitor for SketchyBar Spotify integration
# Detects sleep/wake events and forces media update

LOGFILE="/tmp/sketchybar_sleep_monitor.log"
UPDATE_SCRIPT="$HOME/.config/sketchybar/helpers/update_media.sh"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOGFILE"
}

force_update() {
    log_message "Forcing Spotify update..."
    # Wait a bit for system to stabilize after wake
    sleep 3
    
    # Force immediate update
    "$UPDATE_SCRIPT" &
    
    # Additional updates to ensure it takes
    sleep 2
    "$UPDATE_SCRIPT" &
    
    log_message "Update commands sent"
}

# Monitor system power events
pmset -g log | while read -r line; do
    if echo "$line" | grep -q "Wake from"; then
        log_message "System wake detected"
        force_update
    elif echo "$line" | grep -q "Sleep"; then
        log_message "System sleep detected"
    fi
done