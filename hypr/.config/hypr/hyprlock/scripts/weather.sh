#!/usr/bin/bash
# File: ~/.config/hypr/scripts/Weather.sh
# Make executable: chmod +x ~/.config/hypr/scripts/Weather.sh

# Absolute path for safety
CURL=$(which curl)
CITY="Dhaka"

# Fallback if curl not found
if [ -z "$CURL" ]; then
    echo "Curl not found"
    exit 1
fi

# Fetch weather
WEATHER=$($CURL -s "https://wttr.in/$CITY?format=1")

# Fallback if empty
if [ -z "$WEATHER" ]; then
    echo "Weather: N/A"
else
    echo " $WEATHER"
fi

