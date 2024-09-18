#!/bin/bash

# Variables
INSTALL_DIR="$HOME/.local/bin/download-organizer"
ICON_DIR="$HOME/.local/share/icons/download-organizer.png"
DESKTOP_FILE="$HOME/.local/share/applications/downloads-observer.desktop"
AUTOSTART_FILE="$HOME/.config/autostart/downloads-observer.desktop"
OBSERVER_SCRIPT="$INSTALL_DIR/downloads-observer.sh"

# Function to confirm uninstallation
confirm_uninstallation() {
    zenity --question --text="Are you sure you want to uninstall Downloads Organizer?" --width=300
    return $?
}

# Function to kill the observer process
kill_observer() {
    local pid=$(pgrep -f "$OBSERVER_SCRIPT")
    if [ -n "$pid" ]; then
        kill "$pid"
        notify-send -i error "Downloads-Organizer" "The observer process has been terminated successfully."
    fi
}

# Function to remove installed files
remove_files() {
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
    fi

    if [ -f "$ICON_DIR" ]; then
        rm -f "$ICON_DIR"
    fi

    if [ -f "$DESKTOP_FILE" ]; then
        rm -f "$DESKTOP_FILE"
    fi

    if [ -f "$AUTOSTART_FILE" ]; then
        rm -f "$AUTOSTART_FILE"
    fi
}

# Function to show farewell message
farewell_message() {
    zenity --info --text="Sorry to see you go. Thank you for trying Downloads Organizer.\n\nIf you have any feedback, please let us know at: \n<a href='mailto:apapamarkou@yahoo.com'>apapamarkou@yahoo.com</a>" --width=300 --no-wrap
}

# Main function
main() {
    # Confirm uninstallation
    confirm_uninstallation
    if [ $? -eq 0 ]; then
        # Stop the observer process
        kill_observer

        # Remove files
        remove_files

        # Show farewell message
        farewell_message
    else
        # If user cancels, exit the script
        zenity --info --text="Uninstallation canceled." --width=300
        exit 0
    fi
}

# Run the main function
main
