#!/bin/bash
# This is a quick bash script to perform standard setup on a Debian LXC
# container. Must be run as root.

PACKAGES='sudo vim'

blank_lines() {
        echo
        echo
        echo $1
        echo '------------------------'
        sleep 1
}

echo "Joe's setup script"

blank_lines 'Updating system packages'
# Update packages
apt-get update
apt-get upgrade
apt-get dist-upgrade

# Set locale and timezone
blank_lines "Setting locale and timezone"
dpkg-reconfigure locales
dpkg-reconfigure tzdata

# Install packages
blank_lines "Instlling user specified packages: $PACKAGES"
apt-get install $PACKAGES

# Create user if it does not exist
blank_lines 'Creating user account'
read -p "Enter the new username " USER
id -u $USER > /dev/null 2>&1
if [[ $? == 1 ]]; then
        echo "$USER does not exist... creating"
        # Create users
        adduser $USER
        # Add to sudo group
        usermod -aG sudo $USER
else
        echo "User $USER already exists"
fi
echo 'export EDITOR=vim' >> /home/$USER/.bashrc

blank_lines 'Finished'