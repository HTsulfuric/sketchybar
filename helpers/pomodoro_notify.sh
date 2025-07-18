#!/bin/bash

# Notification sounds and messages
case "$1" in
    "work")
        # Work session ended
        terminal-notifier -title "Pomodoro Timer" -message "Work session completed! Take a break." -sound Glass -execute "~/.config/sketchybar/helpers/pomodoro_control.sh toggle"
        ;;
    
    "break")
        # Break ended
        terminal-notifier -title "Pomodoro Timer" -message "Break time is over! Ready for work?" -sound Ping -execute "~/.config/sketchybar/helpers/pomodoro_control.sh toggle"
        ;;
    
    "long_break")
        # Long break ended
        terminal-notifier -title "Pomodoro Timer" -message "Long break is over! Ready for a new cycle?" -sound Ping -execute "~/.config/sketchybar/helpers/pomodoro_control.sh toggle"
        ;;
    
    *)
        echo "Usage: $0 {work|break|long_break}"
        exit 1
        ;;
esac