# RamDev

RamDev is a collection of simple bash scripts designed to load a directory into a RAM disk on Linux (or WSL) and periodically sync it back to its original location. This can improve performance for HHDs and extend the lifespan for SSDs.

## Features

- Creates a RAM disk and copies a folder to it.
- Uses `rsync` to periodically sync the RAM disk back to persistent storage.
- Supports multiple simultaneous projects, each with its own source directory and RAM disk location.
- Gracefully stops by syncing the RAM disk back to persistent storage before unmounting.

## Use Cases
- **HDD Users**: Achieve the speed of a RAM disk while using HDDs for persistent storage. `rsync` reduces IOPS even further.
- **SSD Users**: Save a significant number of writes to an SSD for write intensive operations.


## Installation

*Note: You need to have sudo privileges for this script to work because of the mount command.*

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/ramdev.git
   cd ramdev
   ```

2. Make the main script executable
   ```bash
   chmod +x ramdev.sh
   ```

3. Make the folder to store the project files:
Update `PROJECTS_DIR` at the top of each script if you want to use a different directory for the project files.
   ```bash
   mkdir ~/ramdev.d
   ```

4. Copy the sample project configuration and customize it:
   ```bash
   cp project.example ~/ramdev.d/YOUR_PROJECT.conf
   cd ~/ramdev.d
   nano YOUR_PROJECT.conf
   ```

### Copy & Paste
Change YOUR_PROJECT to the name you want for your project
```bash
PROJECT_NAME=YOUR_PROJECT
git clone https://github.com/yourusername/ramdev.git
cd ramdev
chmod +x ramdev.sh
mkdir ~/ramdev.d
cp project.example ~/ramdev.d/$PROJECT_NAME.conf
cd ~/ramdev.d 
nano $PROJECT_NAME.conf
```

## Auto Sync (Optional)

The sync script can be run via cron. If no projects are loaded, it won't do anything. If projects are loaded, it will sync them back to their persistent location.

*This is a one-way sync from the RAM disk to the persistent storage.*

1. Make the sync script executable:
   ```bash
   chmod +x ramdev-sync.sh
   ```

2. Edit your cron jobs:
   ```bash
   crontab -e
   ```

3. Add the following line to run the sync script every 5 minutes (adjust the interval as needed):
   ```cron
   */5 * * * * /path/to/ramdev-sync.sh
   ```

## Usage

Start a project - Your RAM disk will be mounted at the location you specified in your project file.
```bash
ramdev.sh start YOUR_PROJECT

source ./ramdev.sh start YOUR_PROJECT -go  # If you want to have it cd you to your project when its complete.
```

Stop a project - Syncs the RAM disk back to persistent storage and unmounts it
```bash
ramdev.sh stop YOUR_PROJECT
```

List all available projects:
```bash
ramdev.sh list
```

# Project Files
*PROJECT_NAME* - Not actually used.
*RAM_DISK_MOUNT* - The path where you want the ramdisk mounted. */mnt/ramdev/YOUR_PROJECT* in the example is a suggestion.
*SOURCE_DIR* - The path to the persistant data. This is where ramdev will sync.
*RAM_DISK_SIZE* - The size of the ramdisk you want to create. e.g 1G, 250M



## License
This project is licensed under the MIT License. See the LICENSE file for details.
