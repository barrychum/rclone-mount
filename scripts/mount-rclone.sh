#!/bin/bash

function select_rclone_remote {
    # Run rclone listremotes to get the list of remotes
    remotes=$(rclone listremotes)

    # Use fzf for interactive selection
    selected_remote=$(echo "$remotes" | fzf --height 50% --reverse --prompt="Select a remote: ")

    # Return the selected remote name without the colon and newline
    printf "%s" "${selected_remote//[$'\r'$'\n']/}"
}

# Main script
selected_remote=$(select_rclone_remote)

if [ -n "$selected_remote" ]; then
    # Construct the mount path
    mount_path="$HOME/mnt/${selected_remote//:/}"

    echo "Mounting $selected_remote at $mount_path ..."

    mkdir -p $mount_path
    # Build the rclone mount command
    rclone_mount_command="rclone mount $selected_remote $mount_path"

    echo $rclone_mount_command

    # Start the mount command in the background
    $rclone_mount_command &

    # Check if the process is running
    if pgrep -f "$rclone_mount_command" > /dev/null; then
        echo "Mount successful."
    else
        echo "Mount failed."
    fi
else
    echo "No remote selected."
fi
