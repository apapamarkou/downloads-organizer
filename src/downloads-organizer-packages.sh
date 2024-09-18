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
# Description: This script handles the installation of various package types
#              (AppImage, RPM, DEB) based on the user's system and choice.
#              It uses Zenity for GUI and supports cross-platform compatibility.

FILEPATH="$1"
FILENAME=$(basename "$FILEPATH")
FILEEXT="${FILENAME##*.}"

# Define paths
APP_DIR="$HOME/Applications"
[ ! -d "$APP_DIR" ] && mkdir -p "$APP_DIR" # Create Applications folder if it doesn't exist

# Function to detect RPM-based system
is_rpm_system() {
    command -v rpm >/dev/null 2>&1
}

# Function to detect DEB-based system
is_deb_system() {
    command -v dpkg >/dev/null 2>&1
}

# Function to open terminal and install package
install_package() {
    TERMINAL=$(command -v x-terminal-emulator || command -v gnome-terminal || command -v konsole || command -v xfce4-terminal || command -v xterm)
    if [ -n "$TERMINAL" ]; then
        $TERMINAL -e "$1"
    else
        zenity --error --text="No terminal emulator found!"
    fi
}

case "$FILEEXT" in
    # Handle AppImage
    AppImage)
        zenity --question --text="Move $FILENAME to your Applications folder?" --width=300
        if [ $? -eq 0 ]; then
            mv "$FILEPATH" "$APP_DIR/"
            zenity --info --text="$FILENAME moved to $APP_DIR." --width=300
        else
            zenity --info --text="No action taken for $FILENAME." --width=300
        fi
        ;;

    # Handle RPM
    rpm)
        if is_rpm_system; then
            zenity --question --text="Install $FILENAME using your package manager?" --width=300
            if [ $? -eq 0 ]; then
                install_package "sudo rpm -i \"$FILEPATH\""
            else
                zenity --info --text="No action taken for $FILENAME." --width=300
            fi
        else
            zenity --error --text="This system is not RPM-compatible." --width=300
        fi
        ;;

    # Handle DEB
    deb)
        if is_deb_system; then
            zenity --question --text="Install $FILENAME using your package manager?" --width=300
            if [ $? -eq 0 ]; then
                install_package "sudo dpkg -i \"$FILEPATH\""
            else
                zenity --info --text="No action taken for $FILENAME." --width=300
            fi
        else
            zenity --error --text="This system is not DEB-compatible." --width=300
        fi
        ;;

    *)
        zenity --error --text="Unsupported package type: $FILENAME" --width=300
        ;;
esac
