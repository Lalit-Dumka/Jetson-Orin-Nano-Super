#!/bin/bash

# Display current swap status
swapon --show

# Default swap size
default_swap_size="8G"

# Prompt user for swap size with default value
read -p "Enter the desired swap size (default is 8G): " swap_size
swap_size=${swap_size:-$default_swap_size}

# Create a swap file with the specified size
sudo fallocate -l $swap_size /swapfile

# Set the correct permissions for the swap file
sudo chmod 600 /swapfile

# Set up the swap space
sudo mkswap /swapfile

# Enable the swap file with higher priority
sudo swapon --priority 90 /swapfile

# Display updated swap status
sudo swapon --show

# Add the swap file entry to /etc/fstab for persistence
echo '/swapfile none swap sw,pri=90 0 0' | sudo tee -a /etc/fstab

# Optional: Reboot the system (comment out if not needed)
# sudo reboot

echo "Swap file created and enabled successfully with higher priority."
echo "Remember to reboot your system for changes to take full effect."