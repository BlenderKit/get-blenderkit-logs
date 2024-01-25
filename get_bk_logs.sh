#!/bin/bash

final_log="blenderkit_logs.txt"
rm "$final_log"

# Path to the daemon log
daemon_log="$HOME/blenderkit_data/daemon/daemon-62485.log"

# Temporary files for logging
temp_daemon_log="/tmp/daemon.log.tmp"
temp_blender_log="/tmp/blender.log.tmp"

# Start tailing the daemon log in the background
tail -n -0 -f "$daemon_log" > "$temp_daemon_log" &
tail_pid=$!
echo "tailing daemon log: $daemon_log"

# Start Blender and capture its output
echo "starting Blender"
echo "1. PLEASE USE BLENDER UNTIL ISSUE OCCURS"
echo "2. THEN CLOSE BLENDER"
echo "3. AND FOLLOW INSTRUCTIONS HERE"
blender > "$temp_blender_log" 2>&1
echo "blender has closed"

# Blender has closed, now kill the tail process
kill $tail_pid

# Combine the logs
{
  echo "-------------> BLENDER logs: <-------------"
  cat "$temp_blender_log"
  echo -e "\n\n\n-------------> BLENDERKIT DAEMON logs: <-------------\n"
  cat "$temp_daemon_log"
} > "$final_log"

# Clean up temporary files
rm "$temp_daemon_log" "$temp_blender_log"

# ADD SYSTEM INFO
{
    echo -e "\n\n\n-------------> SYSTEM INFO: <-------------"
    uname -a
} >> "$final_log"

echo -e "\n--------------------------------------------"
echo "4. PLEASE SEND US THE FILE BELOW:"
echo "$PWD/$final_log"
echo -e "--------------------------------------------"
echo -e "\nBug tracker: https://www.github.com/blenderkit/blenderkit/issues"
echo "Email contact: admin@blenderkit.com"
echo "Thank you for your report!"
