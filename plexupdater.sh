#!/bin/bash

# Fetch the latest version of Plex Media Server for Debian
FINISHED_DIR="/home/plexupdates/finished/"
LATEST_DEB=$(curl -s https://plex.tv/api/downloads/5.json | grep -oP 'https://downloads\.plex\.tv/plex-media-server-new/\K[^"]*(?=/debian/plexmediaserver_.*_amd64.deb)' | head -n 1)
LATEST_DEB_URL="https://downloads.plex.tv/plex-media-server-new/${LATEST_DEB}/debian/plexmediaserver_${LATEST_DEB}_amd64.deb"
PLEXUPDATE_PATH="/home/plexupdates/"
OUTPUT_FILE="plexmediaserver_${LATEST_DEB}_amd64.deb"

# Check if the version is already installed
if [ -f "${FINISHED_DIR}${OUTPUT_FILE}" ]; then
  echo "Plex Media Server version ${LATEST_DEB} is already installed."
  exit 0
fi

# Clear finished directory if a new version is available
rm -rf ${FINISHED_DIR}

# Download the latest Plex Media Server
wget -O "${PLEXUPDATE_PATH}${OUTPUT_FILE}" ${LATEST_DEB_URL}

# Verify download
if [ $? -eq 0 ]; then
  echo "Plex Media Server downloaded successfully."
else
  echo "Failed to download Plex Media Server."
  exit 1
fi

# Install Plex Media Server
 sudo dpkg -i "${PLEXUPDATE_PATH}${OUTPUT_FILE}"

# Check installation
if [ $? -eq 0 ]; then
  echo "Plex Media Server installed successfully."
else
  echo "Failed to install Plex Media Server."
  exit 1
fi

# Clean up
# rm -f "${PLEXUPDATE_PATH}${OUTPUT_FILE}"
 mv "${PLEXUPDATE_PATH}${OUTPUT_FILE}" ${FINISHED_DIR}

echo "Plex Media Server setup complete."
