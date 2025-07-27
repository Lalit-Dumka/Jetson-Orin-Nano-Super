#!/bin/bash

# Create the Hotspot service file

# Default password
default_password="passwrd@123"

# Prompt user for password with default value
read -p "Enter password of the hotspot (Enter to use default; passwrd@123): " password
password=${password:-$default_password}

echo "Creating Hotspot service file..."
sudo tee /etc/systemd/system/jetson_hotspot.service > /dev/null <<EOF
[Unit]
Description=Auto Start Wi-Fi Hotspot on Jetson Nano
After=NetworkManager-wait-online.target
Wants=NetworkManager-wait-online.target

[Service]
Type=oneshot
ExecStartPre=/bin/sleep 10
ExecStart=/usr/bin/nmcli dev wifi hotspot ifname wlP1p1s0 ssid NanoHotspot password $password
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the Hotspot service
echo "Enabling Hotspot service..."
sudo systemctl enable jetson_hotspot.service

# Start the Hotspot service
echo "Starting Hotspot service..."
sudo systemctl start jetson_hotspot.service

echo "Hotspot service created and started successfully!"