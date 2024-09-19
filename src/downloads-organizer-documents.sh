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
# This script is used to organize downloaded files in a specific directory.
# It uses the Zenity GUI library for user interaction and the mv command for moving files.
# The script takes two arguments: the file path and the file type (e.g., pdf, docx, jpg).
# The script first prompts the user to save the file with a new name and location.
# If the user cancels the save dialog, the script exits.
# The script then appends the file extension if missing and moves the file to the new location.
# Finally, the script asks the user if they want to open the file and opens it if the user confirms.

FILEPATH="$1"
FILENAME=$(basename "$FILEPATH")
EXT="${FILENAME##*.}"
DEFAULT_DIR="$HOME/$2"

# Zenity save dialog for renaming and choosing the destination
NEW_FILEPATH=$(zenity --file-selection --save --confirm-overwrite --title="Save As" --filename="$DEFAULT_DIR/$FILENAME")

# Check if cancel was pressed
if [ -z "$NEW_FILEPATH" ]; then
    notify-send "Downloads Organizer:" "- Organizing $FILENAME canceled.\n- The file is in your Downloads drectory"
    exit 1
fi

echo "New file path: [$NEW_FILEPATH]"

# Append extension if missing
if [[ "$NEW_FILEPATH" != *.* ]]; then
    NEW_FILEPATH="$NEW_FILEPATH.$EXT"
fi

# Move the file to the new location
mv "$FILEPATH" "$NEW_FILEPATH"

# Zenity for asking if the file should be opened showing the filename only
zenity --question --text="Do you want to open the $FILENAME?"

if [ $? -eq 0 ]; then
    xdg-open "$NEW_FILEPATH"
fi
