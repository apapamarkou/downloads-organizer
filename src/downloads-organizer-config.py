#!/usr/bin/env python3

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
# This script creates a graphical user interface (GUI) for configuring the download organizer.
# It allows users to enable or disable organizing files based on their preferences,
# such as documents, pictures, and videos. Users can also specify the folders where
# the files should be organized.
#
# The configuration is stored in a file named 'organizer-config' in the user's home directory.
# The script reads the configuration from this file and updates it when the user makes changes.
#
# Usage:
#   python downloads-organizer-config.py
#
# Dependencies:
#   PyQt5
#
# Note:
#   This script assumes that the 'downloads-organizer' directory exists in the user's home directory (~/.local/bin).
#   If the directory does not exist, it will be created.
#

from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QCheckBox, QPushButton, QFileDialog, QLabel, QHBoxLayout, QSpacerItem, QSizePolicy
import sys
import os
import configparser
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QCheckBox, QPushButton, QFileDialog, QLabel, QHBoxLayout, QSpacerItem, QSizePolicy

CONFIG_FILE = os.path.expanduser('~/.local/bin/downloads-organizer/organizer-config')

class ConfigGUI(QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):

        # Load config
        self.config = configparser.ConfigParser()
        if os.path.exists(CONFIG_FILE):
            self.config.read(CONFIG_FILE)
        else:
            self.create_default_config()

        # Organize Active Checkbox
        self.organize_active_checkbox = QCheckBox('Enable Organizing')
        self.organize_active_checkbox.setChecked(self.config.getboolean('organize', 'organizeActive'))



        # Documents Checkbox and Folder
        self.documents_checkbox = QCheckBox('Enable Documents Organizing')
        self.documents_checkbox.setChecked(self.config.getboolean('organize', 'documents'))

        doc_layout = QVBoxLayout()
        self.documents_folder_button = QPushButton('Select Documents Folder')
        self.documents_folder_button.clicked.connect(self.select_documents_folder)
        doc_layout.addWidget(self.documents_folder_button)
        self.documents_folder_label = QLabel(f"Current: {self.config.get('organize', 'documentsFolder')}")
        doc_layout.addWidget(self.documents_folder_label)

        # Pictures Checkbox and Folder
        self.pictures_checkbox = QCheckBox('Enable Pictures Organizing')
        self.pictures_checkbox.setChecked(self.config.getboolean('organize', 'pictures'))

        pic_layout = QVBoxLayout()
        self.pictures_folder_button = QPushButton('Select Pictures Folder')
        self.pictures_folder_button.clicked.connect(self.select_pictures_folder)
        pic_layout.addWidget(self.pictures_folder_button)
        self.pictures_folder_label = QLabel(f"Current: {self.config.get('organize', 'picturesFolder')}")
        pic_layout.addWidget(self.pictures_folder_label)

        # Videos Checkbox and Folder
        self.videos_checkbox = QCheckBox('Enable Videos Organizing')
        self.videos_checkbox.setChecked(self.config.getboolean('organize', 'videos'))

        vid_layout = QVBoxLayout()
        self.videos_folder_button = QPushButton('Select Videos Folder')
        self.videos_folder_button.clicked.connect(self.select_videos_folder)
        vid_layout.addWidget(self.videos_folder_button)
        self.videos_folder_label = QLabel(f"Current: {self.config.get('organize', 'videosFolder')}")
        vid_layout.addWidget(self.videos_folder_label)

        # Images Checkbox
        self.images_checkbox = QCheckBox('Enable Images Organizing')
        self.images_checkbox.setChecked(self.config.getboolean('organize', 'images'))

        # Archives Checkbox
        self.archives_checkbox = QCheckBox('Enable Archives Organizing')
        self.archives_checkbox.setChecked(self.config.getboolean('organize', 'archives'))

        # Packages Checkbox
        self.packages_checkbox = QCheckBox('Enable Packages Organizing')
        self.packages_checkbox.setChecked(self.config.getboolean('organize', 'packages'))

        # Top-left layout
        top_left_layout = QVBoxLayout()
        top_left_layout.addWidget(self.organize_active_checkbox)
        top_left_layout.addWidget(QLabel("<hr/><h2>Documents</h2>"))
        top_left_layout.addWidget(self.documents_checkbox)
        top_left_layout.addLayout(doc_layout)
        top_left_layout.addWidget(QLabel("<hr/><h2>Pictures</h2>"))
        top_left_layout.addWidget(self.pictures_checkbox)
        top_left_layout.addLayout(pic_layout)
        top_left_layout.addWidget(QLabel("<hr/><h2>Videos</h2>"))
        top_left_layout.addWidget(self.videos_checkbox)
        top_left_layout.addLayout(vid_layout)
        top_left_layout.addWidget(QLabel("<hr/><h2>Disk Images</h2>"))
        top_left_layout.addWidget(self.images_checkbox)
        top_left_layout.addWidget(QLabel("<hr/><h2>Archives and Compressed</h2>"))
        top_left_layout.addWidget(self.archives_checkbox)
        top_left_layout.addWidget(QLabel("<hr/><h2>App Packages</h2>"))
        top_left_layout.addWidget(self.packages_checkbox)

        # Title label
        title = QLabel("<h1>Downloads Organizer Config</h1>")

        # Save and Close buttons
        button_layout = QHBoxLayout()
        button_layout.addItem(QSpacerItem(20, 20, QSizePolicy.Expanding, QSizePolicy.Minimum))

        # Save button
        save_button = QPushButton('OK')
        save_button.clicked.connect(self.save_config)
        button_layout.addWidget(save_button)

        # Close button
        close_button = QPushButton('Cancel')
        close_button.clicked.connect(self.close)
        button_layout.addWidget(close_button)

        # Add layouts to main layout
        main_layout = QVBoxLayout()
        main_layout.addWidget(title)
        main_layout.addLayout(top_left_layout)
        main_layout.addItem(QSpacerItem(20, 20, QSizePolicy.Minimum, QSizePolicy.Expanding))
        main_layout.addLayout(button_layout)
        self.setLayout(main_layout)

        self.setWindowTitle('Downloads Organizer Configuration')
        self.show()

    def select_documents_folder(self):
        folder = QFileDialog.getExistingDirectory(self, 'Select Documents Folder')
        if folder:
            self.documents_folder_label.setText(f"Current: {folder}")
            self.config.set('organize', 'documentsFolder', folder)

    def select_pictures_folder(self):
        folder = QFileDialog.getExistingDirectory(self, 'Select Pictures Folder')
        if folder:
            self.pictures_folder_label.setText(f"Current: {folder}")
            self.config.set('organize', 'picturesFolder', folder)

    def select_videos_folder(self):
        folder = QFileDialog.getExistingDirectory(self, 'Select Videos Folder')
        if folder:
            self.videos_folder_label.setText(f"Current: {folder}")
            self.config.set('organize', 'videosFolder', folder)

    def save_config(self):
        self.config.set('organize', 'organizeActive', str(self.organize_active_checkbox.isChecked()).lower())
        self.config.set('organize', 'documents', str(self.documents_checkbox.isChecked()).lower())
        self.config.set('organize', 'pictures', str(self.pictures_checkbox.isChecked()).lower())
        self.config.set('organize', 'videos', str(self.videos_checkbox.isChecked()).lower())

        with open(CONFIG_FILE, 'w') as configfile:
            self.config.write(configfile)

        self.close()

    def create_default_config(self):
        self.config['organize'] = {
            'organizeActive': 'true',
            'documents': 'true',
            'documentsFolder': os.path.expanduser('~/Documents'),
            'pictures': 'true',
            'picturesFolder': os.path.expanduser('~/Pictures'),
            'videos': 'true',
            'videosFolder': os.path.expanduser('~/Videos'),
            'packages': 'true',
            'archives': 'true',
            'images': 'true',
            'imagesFolder': os.path.expanduser('~/Downloads'),
        }
        with open(CONFIG_FILE, 'w') as configfile:
            self.config.write(configfile)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    gui = ConfigGUI()
    sys.exit(app.exec_())
