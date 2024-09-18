#!/bin/bash

FILEPATH="$1"
FILENAME=$(basename "$FILEPATH")
EXT="${FILENAME##*.}"
DEFAULT_DIR="$HOME/$2s"

# Zenity save dialog for renaming and choosing the destination
NEW_FILEPATH=$(zenity --file-selection --save --confirm-overwrite --title="Save $2 As" --filename="$DEFAULT_DIR/$FILENAME")

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

# Zenity for asking if the file should be opened
zenity --question --text="Do you want to open the $2?"

if [ $? -eq 0 ]; then
    xdg-open "$NEW_FILEPATH"
fi
