#!/bin/bash

STATE_FILE="/tmp/sketchybar_pomodoro_state.json"

# Check if state file exists
if [[ ! -f "$STATE_FILE" ]]; then
    echo "State file not found. Please wait for initialization."
    exit 1
fi

# Read current state
read_state() {
    cat "$STATE_FILE" | jq -r ".$1"
}

# Update state
update_state() {
    local key="$1"
    local value="$2"
    local temp_file=$(mktemp)
    if [[ "$value" =~ ^[0-9]+$ ]]; then
        # Numeric value
        cat "$STATE_FILE" | jq ".$key = $value" > "$temp_file"
    else
        # String value
        cat "$STATE_FILE" | jq ".$key = \"$value\"" > "$temp_file"
    fi
    mv "$temp_file" "$STATE_FILE"
}

# Handle commands
case "$1" in
    "toggle")
        state=$(read_state "state")
        is_running=$(read_state "is_running")
        
        if [[ "$is_running" == "true" ]]; then
            # Pause - update time_left to current remaining time
            current_time=$(date +%s)
            start_time=$(read_state "start_time")
            elapsed=$((current_time - start_time))
            
            case "$state" in
                "work")
                    initial_duration=1500  # 25 minutes
                    ;;
                "break")
                    initial_duration=300   # 5 minutes
                    ;;
                "long_break")
                    initial_duration=900   # 15 minutes
                    ;;
                *)
                    initial_duration=1500
                    ;;
            esac
            
            new_time_left=$((initial_duration - elapsed))
            if [[ $new_time_left -lt 0 ]]; then
                new_time_left=0
            fi
            
            update_state "time_left" "$new_time_left"
            update_state "is_running" "false"
        else
            # Resume/Start
            if [[ "$state" == "idle" ]]; then
                update_state "state" "work"
                update_state "time_left" 1500  # 25 minutes
            fi
            update_state "is_running" "true"
            update_state "start_time" "$(date +%s)"
            update_state "last_update" "$(date +%s)"
        fi
        ;;
    
    "reset")
        # Reset to idle state
        cat > "$STATE_FILE" << EOF
{
  "state": "idle",
  "time_left": 1500,
  "session_count": 0,
  "is_running": false,
  "start_time": 0
}
EOF
        ;;
    
    *)
        echo "Usage: $0 {toggle|reset}"
        exit 1
        ;;
esac

# Trigger immediate update
~/.config/sketchybar/helpers/update_pomodoro.sh