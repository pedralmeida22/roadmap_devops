#!/bin/bash

echo "Stopping netdata service"
sudo systemctl stop netdata

echo "Running uninstaller netdata"
bash /tmp/netdata-kickstart.sh --uninstall -y

echo "Apt remove netdata"
sudo apt remove --purge -y netdata

# Clean up configuration files
echo "Cleaning up configuration files..."
sudo rm -rf /etc/netdata

echo "Checking if Netdata is still installed..."
dpkg -l | grep netdata

echo "Cleanup complete!"