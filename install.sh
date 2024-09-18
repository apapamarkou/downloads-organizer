#!/bin/bash

# Variables
INSTALL_DIR="$HOME/.local/bin/download-organizer"
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
    zenity --text-info --title="Terms and Conditions" --filename="$SRC_DIR/terms.txt" --checkbox="I agree to the terms and conditions" --width=500 --height=300
    if [ $? -ne 0 ]; then
        zenity --error --text="You must agree to the terms and conditions to proceed with installation." --width=300
        exit 1
    fi
}

# Function to copy files and set permissions
install_files() {
    # Create the target directories
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$ICON_DIR"
    mkdir -p "$DESKTOP_DIR"
    mkdir -p "$AUTOSTART_DIR"

    # Copy scripts to the installation directory
    cp "$SRC_DIR/download-organize-archives.sh" "$INSTALL_DIR"
    cp "$SRC_DIR/download-organize-documents.sh" "$INSTALL_DIR"
    cp "$SRC_DIR/download-organize-packages.sh" "$INSTALL_DIR"
    cp "$SRC_DIR/download-organizer-config.py" "$INSTALL_DIR"
    cp "$SRC_DIR/downloads-observer.sh" "$INSTALL_DIR"

    # Set the scripts as executable
    chmod +x "$INSTALL_DIR/download-organize-archives.sh"
    chmod +x "$INSTALL_DIR/download-organize-documents.sh"
    chmod +x "$INSTALL_DIR/download-organize-packages.sh"
    chmod +x "$INSTALL_DIR/download-organizer-config.py"
    chmod +x "$INSTALL_DIR/downloads-observer.sh"

    # Copy the icon to the icons directory
    cp "$SRC_DIR/download-organizer.png" "$ICON_DIR"

    # Create the .desktop file
    DESKTOP_FILE="$DESKTOP_DIR/downloads-observer.desktop"
    echo "[Desktop Entry]
Name=Downloads Organizer
Exec=$INSTALL_DIR/downloads-observer.sh
Icon=$ICON_DIR/download-organizer.png
Type=Application
Categories=Utility;
" > "$DESKTOP_FILE"

    # Add to autostart
    cp "$DESKTOP_FILE" "$AUTOSTART_DIR"

    # Run the observer script
    nohup "$INSTALL_DIR/downloads-observer.sh" > /dev/null 2>&1 &
}

# Function to thank the user
thank_user() {
    zenity --info --text="Downloads Organizer has been successfully installed and is now running!" --width=300
}

# Main function
main() {
    # Check dependencies
    check_dependencies

    # Show terms and conditions
    show_terms_and_conditions

    # Run installation
    install_files

    # Thank the user
    thank_user
}

# Run the main function
main
