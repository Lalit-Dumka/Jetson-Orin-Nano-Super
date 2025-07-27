#!/bin/bash

# Create the Jetson Clocks service file
echo "Creating Jetson Clocks service file..."
sudo tee /etc/systemd/system/jetson_clocks.service > /dev/null <<EOF
[Unit]
Description=Jetson Clocks Service
After=multi-user.target

[Service]
Type=oneshot
ExecStartPre=/bin/sleep 10
ExecStart=/bin/bash -c '/usr/bin/jetson_clocks --fan'
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

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