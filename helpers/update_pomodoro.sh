#!/bin/bash

STATE_FILE="/tmp/sketchybar_pomodoro_state.json"

# Initialize state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
    cat > "$STATE_FILE" << EOF
{
  "state": "idle",
  "time_left": 1500,
  "session_count": 0,
  "is_running": false,
  "start_time": 0
}
EOF
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

# Format time display
format_time() {
    local seconds="$1"
    local minutes=$((seconds / 60))
    local secs=$((seconds % 60))
    printf "%02d:%02d" "$minutes" "$secs"
}

# Get current state
state=$(read_state "state")
time_left=$(read_state "time_left")
session_count=$(read_state "session_count")
is_running=$(read_state "is_running")
start_time=$(read_state "start_time")

# Calculate elapsed time if running
if [[ "$is_running" == "true" ]]; then
    current_time=$(date +%s)
    last_update=$(read_state "last_update" 2>/dev/null || echo "$current_time")
    elapsed=$((current_time - last_update))
    
    # Only update if at least 1 second has passed
    if [[ $elapsed -ge 1 ]]; then
        new_time_left=$((time_left - elapsed))
        update_state "last_update" "$current_time"
    else
        new_time_left=$time_left
    fi
    
    # Check if time is up
    if [[ "$new_time_left" -le 0 ]]; then
        new_time_left=0
        update_state "is_running" "false"
        
        # Play notification sound
        ~/.config/sketchybar/helpers/pomodoro_notify_osascript.sh "$state"
        
        # Transition to next state
        case "$state" in
            "work")
                session_count=$((session_count + 1))
                update_state "session_count" "$session_count"
                
                if [[ "$session_count" -ge 4 ]]; then
                    # Long break after 4 sessions
                    update_state "state" "long_break"
                    update_state "time_left" 900  # 15 minutes
                    update_state "session_count" 0
                else
                    # Short break
                    update_state "state" "break"
                    update_state "time_left" 300  # 5 minutes
                fi
                ;;
            "break"|"long_break")
                update_state "state" "idle"
                update_state "time_left" 1500  # 25 minutes
                ;;
        esac
    else
        update_state "time_left" "$new_time_left"
    fi
    
    time_left="$new_time_left"
else
    # When paused, use the stored time_left value
    time_left=$(read_state "time_left")
fi

# Set icon and color based on state
case "$state" in
    "idle")
        icon="􀐱"
        color="0xff7f8490"  # grey
        ;;
    "work")
        icon="􀐱"
        color="0xffa3be8c"  # green
        ;;
    "break")
        icon="􀁰"
        color="0xffebcb8b"  # yellow
        ;;
    "long_break")
        icon="􀁰"
        color="0xffd08770"  # orange
        ;;
esac

# Update display
time_display=$(format_time "$time_left")
session_display="$session_count/4"

sketchybar --set pomodoro_item \
    icon="$icon" \
    icon.color="$color" \
    label="$time_display"

sketchybar --set pomodoro_sessions \
    label="$session_display"

# Update start/pause button
if [[ "$is_running" == "true" ]]; then
    sketchybar --set pomodoro_start_pause \
        icon="􀊆" \
        icon.color="0xffd08770"  # orange (pause)
else
    sketchybar --set pomodoro_start_pause \
        icon="􀊄" \
        icon.color="0xffa3be8c"  # green (start)
fi