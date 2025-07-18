#!/bin/bash

# Notification with osascript buttons
case "$1" in
    "work")
        # Work session ended
        result=$(osascript -e 'display alert "Pomodoro Timer" message "Work session completed! Take a break." buttons {"Start Break", "Later"} default button "Start Break"')
        if [[ "$result" == "button returned:Start Break" ]]; then
            ~/.config/sketchybar/helpers/pomodoro_control.sh toggle
        fi
        afplay /System/Library/Sounds/Glass.aiff
        ;;
    
    "break")
        # Break ended
        result=$(osascript -e 'display alert "Pomodoro Timer" message "Break time is over! Ready for work?" buttons {"Start Work", "Later"} default button "Start Work"')
        if [[ "$result" == "button returned:Start Work" ]]; then
            ~/.config/sketchybar/helpers/pomodoro_control.sh toggle
        fi
        afplay /System/Library/Sounds/Ping.aiff
        ;;
    
    "long_break")
        # Long break ended
        result=$(osascript -e 'display alert "Pomodoro Timer" message "Long break is over! Ready for a new cycle?" buttons {"Start New Cycle", "Later"} default button "Start New Cycle"')
        if [[ "$result" == "button returned:Start New Cycle" ]]; then
            ~/.config/sketchybar/helpers/pomodoro_control.sh toggle
        fi
        afplay /System/Library/Sounds/Ping.aiff
        ;;
    
    *)
        echo "Usage: $0 {work|break|long_break}"
        exit 1
        ;;
esac