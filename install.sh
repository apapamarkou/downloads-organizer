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
# This script installs the Download Organizer application on a Linux system.
# It checks for dependencies, displays a terms and conditions dialog, and copies
# the necessary files to the appropriate locations.



# Variables
INSTALL_DIR="$HOME/.local/bin/downloads-organizer"
ICON_DIR="$HOME/.local/share/icons"
DESKTOP_DIR="$HOME/.local/share/applications"
AUTOSTART_DIR="$HOME/.config/autostart"
SRC_DIR="src"
DEPENDENCIES=("zenity" "inotifywait")

# Function to check dependencies
check_dependencies() {
    for dep in "${DEPENDENCIES[@]}"; do
        if ! command -v "$dep" > /dev/null 2>&1; then
            zenity --error --text="$dep is not installed. Please install it and try again." --width=300
            exit 1
        fi
    done
}

# Function to display terms and conditions
show_terms_and_conditions() {
    zenity --text-info --title="Terms and Conditions" --filename="$SRC_DIR/terms.txt" --checkbox="I agree to the terms and conditions" --width=650 --height=300
    if [ $? -ne 0 ]; then
        zenity --error --text="You must agree to the terms and conditions to proceed with installation." --width=300
        exit 1
    fi
}

# Function to copy files and set permissions
install_files() {
    # Create the target directories
    echo "Create the target directories"
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$ICON_DIR"
    mkdir -p "$DESKTOP_DIR"
    mkdir -p "$AUTOSTART_DIR"

    # Copy scripts to the installation directory
    echo "Copy scripts to the installation directory"
    cp "$SRC_DIR/downloads-organizer-archives.sh" "$INSTALL_DIR"
    cp "$SRC_DIR/downloads-organizer-documents.sh" "$INSTALL_DIR"
    cp "$SRC_DIR/downloads-organizer-packages.sh" "$INSTALL_DIR"
    cp "$SRC_DIR/downloads-organizer-config.py" "$INSTALL_DIR"
    cp "$SRC_DIR/downloads-observer.sh" "$INSTALL_DIR"

    # Set the scripts as executable
    echo "Set the scripts as executable"
    chmod +x "$INSTALL_DIR/downloads-organizer-archives.sh"
    chmod +x "$INSTALL_DIR/downloads-organizer-documents.sh"
    chmod +x "$INSTALL_DIR/downloads-organizer-packages.sh"
    chmod +x "$INSTALL_DIR/downloads-organizer-config.py"
    chmod +x "$INSTALL_DIR/downloads-observer.sh"

    # Copy the icon to the icons directory
    echo "Copy the icon to the icons directory"
    cp "$SRC_DIR/downloads-organizer.png" "$ICON_DIR"

    # Create the .desktop file
    echo "Create the .desktop file"
    DESKTOP_FILE="$DESKTOP_DIR/downloads-observer.desktop"
    echo "[Desktop Entry]
Name=Downloads Organizer
Exec=$INSTALL_DIR/downloads-observer.sh
Icon=$ICON_DIR/downloads-organizer.png
Type=Application
Categories=Utility;
" > "$DESKTOP_FILE"

    # Add to autostart
    echo "Add to autostart"
    cp "$DESKTOP_FILE" "$AUTOSTART_DIR"

# Create the downloads-organizer-config.desktop file
    DESKTOP_FILE="$DESKTOP_DIR/downloads-organizer-config.desktop"
    echo "[Desktop Entry]
Name=Downloads Organizer
Exec=$INSTALL_DIR/downloads-organizer-config.py
Icon=$ICON_DIR/download-organizer.png
Type=Application
Categories=Utility;
" > "$DESKTOP_FILE"

    echo "[organize]
organizeActive=true
documents=true
documentsFolder=$HOME/Documents
pictures=true
picturesFolder=$HOME/Pictures
videos=true
videosFolder=$HOME/Videos
packages=true
archives=true
imagesFolder=$HOME/Downloads
" > "$INSTALL_DIR/downloads-organizer.conf"


    # Run the observer script
    echo "Run the observer script"
    "$INSTALL_DIR/downloads-observer.sh" &
}

# Function to thank the user
thank_user() {
    zenity --info --text="Downloads Organizer has been installed. Thank you for using Desktop Organizer" --width=300
}

# Main function
main() {
    # Check dependencies
    echo "Check dependencies"
    check_dependencies

    # Show terms and conditions
    echo "Show terms and conditions"
    show_terms_and_conditions

    # Run installation
    echo "Run installation"
    install_files

    # Thank the user
    echo "Thank the user"
    thank_user
}

# Run the main function
main
