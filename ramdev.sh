#!/bin/bash

# Projects directory
PROJECTS_DIR="$HOME/ramdev.d"


process_project() {
    local config_file="$1"
    local action="$2"
    local go_flag="$3" 

    if [ ! -f "$config_file" ]; then
        echo "Error: Config file '$config_file' not found."
        return 1
    fi

    source "$config_file"

    case "$action" in
        start)
            sudo mkdir -p "$RAM_DISK_MOUNT"
            sudo mount -t tmpfs -o size="$RAM_DISK_SIZE" tmpfs "$RAM_DISK_MOUNT"
            rsync -avz "$SOURCE_DIR/" "$RAM_DISK_MOUNT/"
            echo "RAM disk for $PROJECT_NAME started at $RAM_DISK_MOUNT"

            # Check for the -go flag
            if [[ "$go_flag" == "-go" ]]; then
                cd "$RAM_DISK_MOUNT" || { echo "Failed to cd to $RAM_DISK_MOUNT"; return 1; }
            fi
            ;;
        stop)
           if mountpoint -q "$RAM_DISK_MOUNT"; then
        		echo "RAM disk for $PROJECT_NAME is mounted. Synchronizing..."
        		rsync -avz "$RAM_DISK_MOUNT/" "$SOURCE_DIR/"
    		else
        		echo "$PROJECT_NAME is not active. Exiting."
    		fi
            sudo umount "$RAM_DISK_MOUNT"
            echo "RAM disk for $PROJECT_NAME synced and stopped."
            ;;
		list)
			find "$PROJECTS_DIR" -maxdepth 1 -name "*.conf" -printf "%f\n" | sed 's/\.conf$//' | sort
			;;
        *)
            cat << EOF
Usage: $0 {start|stop|list} <project> [-go]
       $0 list
       $0 start <project> [-go]
       $0 stop <project>
EOF
            return 1
            ;;
    esac
}

# Check for command and project arguments
if [ $# -lt 2 ]; then 
cat << EOF
Usage: $0 {start|stop|list} <project> [-go]
       $0 list
       $0 start <project> [-go]
       $0 stop <project>
EOF
    exit 1
fi

action="$1"
project="$2"
config_file="$PROJECTS_DIR/$project.conf"

go_flag=""
if [ $# -eq 3 ] && [[ "$3" == "-go" ]]; then
    go_flag="-go"
fi

process_project "$config_file" "$action" "$go_flag"