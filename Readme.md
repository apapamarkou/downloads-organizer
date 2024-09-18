
# Downloads Organizer

**Downloads Organizer** is a background utility designed to keep your Downloads folder tidy and your home directory well-organized. It monitors incoming files in your Downloads directory and helps you manage them based on their types—such as documents, videos, pictures, packages, disk images and archives.

When new files are detected, Downloads Organizer prompts you to optionally rename and move them to appropriate folders according to your preferences. For applications and packages, it will ask if you want to install them. For archives and compressed files, it offers to extract them and select the extraction location.

The tool features an intuitive GUI for configuring default folders for various file types and for enabling or disabling specific actions based on the type of downloaded files.

## Features
- Automatically takes action for new downloaded files.
- Configurable with a simple PyQt5-based GUI.
- Supported file types :
    - Documents: txt|pdf|docx|odf|xls|xlsx
    - Videos: mp4|mkv|avi|flv|mov|wmv
    - Pictures: jpg|jpeg|png|gif|bmp|tiff|svg|webp
    - Disk Images: iso|img
    - Linux packages: rpm|deb|AppImage
    - Archives: tar|gz|zip|7z|bz2|xz

## Before installation

To use the Downloads Organizer, ensure the following dependencies are installed:

- `zenity`
- `inotify-tools` (for monitoring file changes)
- Python 3.x
- PyQt5: `python3-pyqt5`
- `wget`, `git` (for installation)

### How to install dependencies

- Debian based distributions (Ubuntu, Mint, Zorin, MX-Linux etc):

   ```bash
   sudo apt install zenity inotify-tools python3-pyqt5 git wget

   ```

- RedHat based distributions (Fedora, OpenSuSE, Alma-Linux etc):

   ```bash
   sudo dnf install zenity inotify-tools python3-pyqt5 git wget

   ```

- Ach based distributions (Manjaro, Garuda, Archcraft etc):

   ```bash
   sudo pacman -S --needed zenity inotify-tools python-pyqt5 git wget
   ```

- Solus

   ```bash
   sudo pacman -S zenity inotify-tools python-pyqt5 git wget
   ```

## Installation

Simply copy the line, paste it in a terminal and hit [Enter]. Thats it!

```bash
wget -qO- https://raw.githubusercontent.com/apapamarkou/downloads-organizer/main/src/direct-install | bash
```

#### For Uninstallation:

Simply copy the line, paste it in a terminal and hit [Enter].

```bash
wget -qO- https://raw.githubusercontent.com/apapamarkou/downloads-organizer/main/src/direct-uninstall | bash```

## Usage

Once installed, `Downloads Organizer` will automatically monitor your Downloads folder running in the background. It automatically starts on login. The configuration window can be launched by searching for `Downloads Organizer Config` in your applications menu.

## License

This project is licensed under the GNU General Public License v3.0.
See the `LICENSE` file for more details.

## Contributing

Feel free to fork this repository and submit pull requests. If you encounter any issues, please report them on the GitHub issues page.

## Contact

For any queries, you can reach out at: apapamarkou@yahoo.com
