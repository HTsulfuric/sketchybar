#!/bin/bash

# Multi-app media update script for SketchyBar (Spotify + Apple Music)

get_spotify_info() {
    local info=""
    local state=""
    
    # Only check Spotify if process exists and is actually running
    if pgrep -xq "Spotify"; then
        local artist=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
        local title=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
        state=$(osascript -e 'tell application "Spotify" to player state' 2>/dev/null)
        
        if [[ -n "$artist" && -n "$title" && "$artist" != "missing value" && "$title" != "missing value" && "$artist" != "" && "$title" != "" ]]; then
            if [[ "$state" == "playing" || "$state" == "paused" ]]; then
                info="$artist - $title"
            fi
        fi
    fi
    
    echo "$info|$state"
}

get_music_info() {
    local info=""
    local state=""
    
    # Only check Music if process exists and is actually running
    if pgrep -xq "Music"; then
        local artist=$(osascript -e 'tell application "Music" to artist of current track' 2>/dev/null)
        local title=$(osascript -e 'tell application "Music" to name of current track' 2>/dev/null)
        state=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
        
        if [[ -n "$artist" && -n "$title" && "$artist" != "missing value" && "$title" != "missing value" && "$artist" != "" && "$title" != "" ]]; then
            if [[ "$state" == "playing" || "$state" == "paused" ]]; then
                info="$artist - $title"
            fi
        fi
    fi
    
    echo "$info|$state"
}

update_media_info() {
    local combined="No Media"
    local icon="🎵"
    
    # Get info from both apps
    local spotify_result=$(get_spotify_info)
    local music_result=$(get_music_info)
    
    local spotify_info=$(echo "$spotify_result" | cut -d'|' -f1)
    local spotify_state=$(echo "$spotify_result" | cut -d'|' -f2)
    local music_info=$(echo "$music_result" | cut -d'|' -f1)
    local music_state=$(echo "$music_result" | cut -d'|' -f2)
    
    # Priority: playing > paused > stopped
    # If both are playing, prefer Spotify
    if [[ "$spotify_state" == "playing" && -n "$spotify_info" ]]; then
        combined="$spotify_info"
        icon="􀊆"  # pause icon (since music is playing)
    elif [[ "$music_state" == "playing" && -n "$music_info" ]]; then
        combined="$music_info"
        icon="􀊆"  # pause icon (since music is playing)
    elif [[ "$spotify_state" == "paused" && -n "$spotify_info" ]]; then
        combined="$spotify_info"
        icon="􀊄"  # play icon (since music is paused)
    elif [[ "$music_state" == "paused" && -n "$music_info" ]]; then
        combined="$music_info"
        icon="􀊄"  # play icon (since music is paused)
    fi
    
    # Update SketchyBar
    sketchybar --set media_item label="$combined" icon="$icon"
}

# Execute update
update_media_info