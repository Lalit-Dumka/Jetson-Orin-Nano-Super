#!/bin/bash

# Create the Efkon EES service file
echo "Creating Efkon EES service file..."
sudo tee /etc/systemd/system/efkon_ees.service > /dev/null <<EOF
[Unit]
Description=Efkon EES Service
After=multi-user.target

[Service]
ExecStartPre=/bin/sleep 15
WorkingDirectory=/home/lalit/Desktop/efkon-ees/src
ExecStart=/usr/bin/python run_all.py
Restart=Always
User=lalit

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd daemon
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable the Efkon EES service
echo "Enabling Efkon EES service..."
sudo systemctl enable efkon_ees.service

# Start the Efkon EES service
echo "Starting Efkon EES service..."
sudo systemctl start efkon_ees.service

echo "Efkon EES service created and started successfully!"