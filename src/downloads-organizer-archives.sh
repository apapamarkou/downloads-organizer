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
# This script is called from the main script to handle the extraction of archives.

FILEPATH="$1"
FILENAME=$(basename "$FILEPATH")
FILEEXT="${FILENAME##*.}"

# Function to extract archive to the destination folder
extract_archive() {
    local archive="$1"
    local dest="$2"

    case "$FILEEXT" in
        # Tar archives
        tar)
            tar -xf "$archive" -C "$dest"
            ;;
        tar.gz|tgz)
            tar -xzf "$archive" -C "$dest"
            ;;
        tar.bz2|tbz)
            tar -xjf "$archive" -C "$dest"
            ;;
        tar.xz)
            tar -xJf "$archive" -C "$dest"
            ;;
        # Zip archives
        zip)
            unzip "$archive" -d "$dest"
            ;;
        # 7z archives
        7z)
            7z x "$archive" -o"$dest"
            ;;
        # Other compression formats can be added here
        *)
            zenity --error --text="Unsupported archive format: $FILENAME" --width=300
            return 1
            ;;
    esac
}

# Ask the user if they want to extract the archive
zenity --question --text="Do you want to extract $FILENAME?" --width=300
if [ $? -eq 0 ]; then
    # Ask the user to choose the destination folder
    DEST_DIR=$(zenity --file-selection --directory --title="Select destination folder")

    if [ -n "$DEST_DIR" ]; then
        # Extract the archive
        if extract_archive "$FILEPATH" "$DEST_DIR"; then
            zenity --info --text="Archive $FILENAME successfully extracted to $DEST_DIR" --width=300
        else
            zenity --error --text="Failed to extract $FILENAME" --width=300
        fi
    else
        zenity --error --text="No destination folder selected. Extraction aborted." --width=300
    fi
fi
