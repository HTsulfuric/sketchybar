#!/bin/bash

# Multi-app Media Control Script for SketchyBar (Spotify + Apple Music)

get_active_app() {
    local spotify_state=""
    local music_state=""
    
    # Check Spotify state (only if process exists and is actually running)
    if pgrep -xq "Spotify"; then
        spotify_state=$(osascript -e 'tell application "Spotify" to player state' 2>/dev/null)
    fi
    
    # Check Apple Music state (only if process exists and is actually running)
    if pgrep -xq "Music"; then
        music_state=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
    fi
    
    # Priority: playing > paused > stopped
    # If both are playing, prefer Spotify
    if [[ "$spotify_state" == "playing" ]]; then
        echo "Spotify"
    elif [[ "$music_state" == "playing" ]]; then
        echo "Music"
    elif [[ "$spotify_state" == "paused" ]]; then
        echo "Spotify"
    elif [[ "$music_state" == "paused" ]]; then
        echo "Music"
    elif [[ -n "$spotify_state" ]]; then
        echo "Spotify"
    elif [[ -n "$music_state" ]]; then
        echo "Music"
    else
        echo "none"
    fi
}

execute_spotify_command() {
    local action=$1
    local max_retries=2
    
    # Execute command with retry
    for attempt in $(seq 1 $max_retries); do
        case $action in
            "previous")
                if osascript -e 'tell application "Spotify" to previous track' 2>/dev/null; then
                    break
                fi
                ;;
            "playpause"|"toggle")
                if osascript -e 'tell application "Spotify" to playpause' 2>/dev/null; then
                    break
                fi
                ;;
            "next")
                if osascript -e 'tell application "Spotify" to next track' 2>/dev/null; then
                    break
                fi
                ;;
            *)
                echo "Usage: $0 [previous|playpause|next]"
                exit 1
                ;;
        esac
        
        # Wait before retry
        if [[ $attempt -lt $max_retries ]]; then
            sleep 0.3
        fi
    done
}

execute_music_command() {
    local action=$1
    local max_retries=2
    
    # Execute command with retry
    for attempt in $(seq 1 $max_retries); do
        case $action in
            "previous")
                if osascript -e 'tell application "Music" to previous track' 2>/dev/null; then
                    break
                fi
                ;;
            "playpause"|"toggle")
                if osascript -e 'tell application "Music" to playpause' 2>/dev/null; then
                    break
                fi
                ;;
            "next")
                if osascript -e 'tell application "Music" to next track' 2>/dev/null; then
                    break
                fi
                ;;
            *)
                echo "Usage: $0 [previous|playpause|next]"
                exit 1
                ;;
        esac
        
        # Wait before retry
        if [[ $attempt -lt $max_retries ]]; then
            sleep 0.3
        fi
    done
}

execute_media_command() {
    local action=$1
    local active_app=$(get_active_app)
    
    if [[ "$active_app" == "none" ]]; then
        echo "No media app is running"
        exit 1
    fi
    
    case $active_app in
        "Spotify")
            execute_spotify_command "$action"
            ;;
        "Music")
            execute_music_command "$action"
            ;;
    esac
    
    # Force immediate update
    ~/.config/sketchybar/helpers/update_media.sh &
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 [previous|playpause|next]"
    exit 1
fi

execute_media_command "$1"