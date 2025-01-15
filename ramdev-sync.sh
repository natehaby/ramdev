#!/bin/bash

# Projects directory
PROJECTS_DIR="$HOME/ramdev.d"

# Iterate through all .conf files in the projects directory
find "$PROJECTS_DIR" -maxdepth 1 -name "*.conf" -print0 | while IFS= read -r -d $'\0' config_file; do
    echo "Processing config file: $config_file"

    # Source the config file
    source "$config_file"

    if mountpoint -q "$RAM_DISK_MOUNT"; then
        echo "RAM disk for $PROJECT_NAME is mounted. Synchronizing..."
        rsync -avz "$RAM_DISK_MOUNT/" "$SOURCE_DIR/"
    else
        echo "RAM disk for $PROJECT_NAME is NOT mounted. Skipping synchronization."
    fi
done