#!/bin/bash

# Create the Jetson Logging service file
echo "Creating Jetson Logging service file..."
sudo tee /etc/systemd/system/jetson_logging.service > /dev/null <<EOF
[Unit]
Description=Jetson Logging Service
After=multi-user.target

[Service]
ExecStartPre=/bin/sleep 12
WorkingDirectory=/home/lalit/Desktop/efkon-ees/resources_logs
ExecStart=/usr/bin/python /home/lalit/Desktop/efkon-ees/resources_logs/log_resources.py
Restart=Always
User=lalit

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the Jetson Logging service
echo "Enabling Jetson Logging service..."
sudo systemctl enable jetson_logging.service

# Start the Jetson Logging service
echo "Starting Jetson Logging service..."
sudo systemctl start jetson_logging.service

echo "Jetson Logging service created and started successfully!"