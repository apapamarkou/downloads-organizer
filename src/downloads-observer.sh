#!/bin/bash

#  ____                      _                 _
# |  _ \  _____      ___ __ | | ___   __ _  __| |___
# | | | |/ _ \ \ /\ / / '_ \| |/ _ \ / _` |/ _` / __|
# | |_| | (_) \ V  V /| | | | | (_) | (_| | (_| \__ \
# |____/ \___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_|___/
#  / _ \ _ __ __ _  __ _ _ __ (_)_______ _ __
# | | | | '__/ _` |/ _` | '_ \| |_  / _ \ '__|
# | |_| | | | (_| | (_| | | | | |/ /  __/ |
#  \___/|_|  \__, |\__,_|_| |_|_/___\___|_|
#            |___/
#
# Author: Andrianos Papamarkou
#
# Description: This script monitors the Downloads directory for new files and
#              organizes them based on their file extension.
#              It reads the configuration from a file named downloads-organizer.conf
#              located in the user's home directory.
#              The configuration file should contain the following variables:
#              organizeActive (true/false)
#              documents (true/false)
#              videos (true/false)
#              pictures (true/false)
#              images (true/false)
#              packages (true/false)
#              archives (true/false)
#              documentsFolder (path)
#              videosFolder (path)
#              picturesFolder (path)
#              imagesFolder (path)

BIN_DIR="$HOME/.local/bin/downloads-organizer"
CONFIG_FILE="$BIN_DIR/downloads-organizer.conf"
WATCH_DIR="$HOME/Downloads"

# Read config file
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found. Exiting."
    zenity --error --text="Configuration file not found. Exiting." --title="Downloads Organizer" --width=300
    exit 1
fi

# Monitor the Downloads directory for new files
notify-send "Downloads Observer" "Monitoring the Downloads directory for new files." -i "$BIN_DIR/downloads-organizer.png" -t 3000
inotifywait -m -e create "$WATCH_DIR" --format '%w%f' | while read FILEPATH
do
    EXT="${FILEPATH##*.,,}"
    # Check if organizing is active
    if [ "$organizeActive" == "true" ]; then
        case "$EXT" in
            # Documents
            txt|pdf|docx|odf|xls|xlsx)
                if [ "$documents" == "true" ]; then
                    $BIN_DIR/downloads-organizer-documents.sh "$FILEPATH" "document" "$documentsFolder"
                fi
                ;;
            # Videos
            mp4|mkv|avi|flv|mov|wmv)
                if [ "$videos" == "true" ]; then
                    $BIN_DIR/downloads-organizer-documents.sh "$FILEPATH" "video" "$videosFolder"
                fi
                ;;
            # Pictures
            jpg|jpeg|png|gif|bmp|tiff|svg|webp)
                if [ "$pictures" == "true" ]; then
                    $BIN_DIR/downloads-organizer-documents.sh "$FILEPATH" "picture" "$picturesFolder"
                fi
                ;;
            # Images (ISO, IMG)
            iso|img)
                if [ "$images" == "true" ]; then
                    $BIN_DIR/downloads-organizer-documents.sh "$FILEPATH" "image" "$imagesFolder"
                fi
                ;;
            # Linux packages
            rpm|deb|AppImage)
                if [ "$packages" == "true" ]; then
                    $BIN_DIR/downloads-organizer-packages.sh "$FILEPATH"
                fi
                ;;
            # Archive files
            tar|gz|zip|7z|bz2|xz)
                if [ "$archives" == "true" ]; then
                    $BIN_DIR/downloads-organizer-archives.sh "$FILEPATH"
                fi
                ;;
            *)
                echo "File type not supported: $FILEPATH" | tee -a "$LOG_FILE"
                ;;
        esac
    fi
done
notify-send "Downloads Observer" "Monitoring stopped." -i "$BIN_DIR/downloads-organizer.png" -t 3000