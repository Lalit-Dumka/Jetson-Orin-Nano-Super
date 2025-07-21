#!/bin/bash

# Create the Jetson Clocks service file
echo "Creating Jetson Clocks service file..."
sudo bash -c 'cat > /etc/systemd/system/jetson_clocks.service <<EOF
[Unit]
Description=Jetson Clocks Service
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/jetson_clocks --fan
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the Jetson Clocks service
echo "Enabling Jetson Clocks service..."
sudo systemctl enable jetson_clocks.service

# Start the Jetson Clocks service
echo "Starting Jetson Clocks service..."
sudo systemctl start jetson_clocks.service

echo "Jetson Clocks service created and started successfully!"