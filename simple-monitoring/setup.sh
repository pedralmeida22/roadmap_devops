#!/bin/bash

echo "Updating system..."
sudo apt update -y

echo "Installing dependencies..."
sudo apt install -y curl bash

echo "Downloading netdata installer"
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh

echo "Installing netdata"
bash /tmp/netdata-kickstart.sh -y

echo "Starting Netdata service..."
sudo systemctl start netdata
sudo systemctl enable netdata

echo "Checking Netdata service status..."
sudo systemctl status netdata
echo "Netdata installation complete!"

