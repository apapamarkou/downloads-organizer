#!/bin/bash

BIN_DIR="$HOME/.local/bin/download-organizer"
CONFIG_FILE="$BIN_DIR/downloads-organizer.conf"
WATCH_DIR="$HOME/Downloads"

# Read config file
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Configuration file not found. Exiting."
    exit 1
fi

# Check if organizing is active
if [ "$organizeActive" != "true" ]; then
    echo "Organizing is not active. Exiting."
    exit 0
fi

# Monitor the Downloads directory for new files
inotifywait -m -e create "$WATCH_DIR" --format '%w%f' | while read FILEPATH
do
    EXT="${FILEPATH##*.}"
    # Check if organizing is active
    if [ "$organizeActive" == "true" ]; then
        case "$EXT" in
            # Documents
            txt|pdf|docx|odf|xls|xlsx)
                if [ "$documents" == "true" ]; then
                    $BIN_DIR/download-organize-documents.sh "$FILEPATH" "document" "$documentsFolder"
                fi
                ;;
            # Videos
            mp4|mkv|avi|flv|mov|wmv)
                if [ "$videos" == "true" ]; then
                    $BIN_DIR/download-organize-documents.sh "$FILEPATH" "video" "$videosFolder"
                fi
                ;;
            # Pictures
            jpg|jpeg|png|gif|bmp|tiff|svg|webp)
                if [ "$pictures" == "true" ]; then
                    $BIN_DIR/download-organize-documents.sh "$FILEPATH" "picture" "$picturesFolder"
                fi
                ;;
            # Images (ISO, IMG)
            iso|img)
                if [ "$images" == "true" ]; then
                    $BIN_DIR/download-organize-documents.sh "$FILEPATH" "image" "$imagesFolder"
                fi
                ;;
            # Linux packages
            rpm|deb|AppImage)
                if [ "$packages" == "true" ]; then
                    $BIN_DIR/download-organize-packages.sh "$FILEPATH"
                fi
                ;;
            # Archive files
            tar|gz|zip|7z|bz2|xz)
                if [ "$archives" == "true" ]; then
                    $BIN_DIR/download-organize-archives.sh "$FILEPATH"
                fi
                ;;
            *)
                echo "File type not supported: $FILEPATH" | tee -a "$LOG_FILE"
                ;;
        esac
    fi

done
