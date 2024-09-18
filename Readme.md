
# Downloads Organizer

Downloads Organizer is a utility that organizes files in your Downloads directory based on file types (documents, videos, pictures, packages, archives, and more). It provides an easy-to-use GUI for configuring folders, and supports automation with inotifywait.

## Features
- Automatically sorts files based on their type.
- Supports organizing documents, videos, images, packages, archives, and disk images.
- Configurable with a simple PyQt5-based GUI.
- Easily extensible for other file types.

## Dependencies

To use the Downloads Organizer, ensure the following dependencies are installed:

### Core Dependencies:
- `zenity`
- `inotify-tools` (for monitoring file changes)

### GUI Dependencies:
- Python 3.x
- PyQt5: `python3-pyqt5`

## Installation

### The Simple and Easy Way (Recommended)

You can install the Downloads Organizer directly by using the following command:

#### For Installation:
```bash
wget -qO- https://your-server.com/install-organizer.sh | bash
```

#### For Uninstallation:
```bash
wget -qO- https://your-server.com/uninstall-organizer.sh | bash
```

These commands will automatically install or uninstall the organizer, depending on your choice.

### Manual Installation

#### For Debian/Ubuntu-based Systems:
1. Install dependencies:
   ```bash
   sudo apt install zenity inotify-tools python3-pyqt5
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/your-username/downloads-organizer.git
   cd downloads-organizer
   ```

3. Run the installer:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

#### For RedHat/Fedora-based Systems:
1. Install dependencies:
   ```bash
   sudo dnf install zenity inotify-tools python3-pyqt5
   ```

2. Follow the same steps for Debian/Ubuntu after dependency installation.

#### For Arch-based Systems:
1. Install dependencies:
   ```bash
   sudo pacman -S zenity inotify-tools python-pyqt5
   ```

2. Follow the same steps for Debian/Ubuntu after dependency installation.

#### For Solus:
1. Install dependencies:
   ```bash
   sudo eopkg install zenity inotify-tools python3-pyqt5
   ```

2. Follow the same steps for Debian/Ubuntu after dependency installation.

## Usage

Once installed, Downloads Organizer will automatically monitor your Downloads folder. The GUI can be launched by searching for "Downloads Organizer Config" in your applications menu.

You can configure the organizing rules and destination folders through the GUI.

## License

This project is licensed under the GNU General Public License v3.0.
See the `LICENSE` file for more details.

## Contributing

Feel free to fork this repository and submit pull requests. If you encounter any issues, please report them on the GitHub issues page.

## Contact

For any queries, you can reach out at: apapamarkou@yahoo.com
