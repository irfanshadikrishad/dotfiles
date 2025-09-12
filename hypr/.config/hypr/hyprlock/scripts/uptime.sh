#!/usr/bin/bash
# Get uptime in seconds
UP=$(cat /proc/uptime | awk '{print int($1)}')

# Calculate days, hours, minutes
D=$((UP/86400))
H=$(( (UP%86400)/3600 ))
M=$(( (UP%3600)/60 ))

# Build string dynamically
STR=""
[ $D -gt 0 ] && STR+="${D}d "
[ $H -gt 0 ] && STR+="${H}h "
STR+="${M}m"

# Output
echo "  $STR"
