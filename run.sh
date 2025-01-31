#!/bin/bash

set -e  # Exit on any error

# Update and upgrade packages
echo "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y
# Install pgAdmin Desktop
sudo apt install -y wget curl

# Install PostgreSQL and PostGIS
echo "Installing PostgreSQL and PostGIS..."
sudo apt install -y postgresql postgresql-contrib postgis

# Enable and start PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql


echo "Installing pgAdmin Desktop..."
# Install the public key for the repository (if not done previously):
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
# Create the repository configuration file:
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
# Install for desktop mode only:
sudo apt install -y pgadmin4-desktop

# Install QGIS
echo "Installing QGIS..."
sudo apt install -y gnupg software-properties-common
sudo wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
sudo apt install -y qgis qgis-plugin-grass

# Install pyenv dependencies
echo "Installing pyenv dependencies..."
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev python3-openssl git

# Install pyenv
echo "Installing pyenv..."
username=$(logname)
echo 'export PATH="/home/'$username'/.pyenv/bin:$PATH"'>>/home/$username/.bashrc
echo 'eval "$(pyenv init -)"'>>/home/$username/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"'>>/home/$username/.bashrc
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | sudo -u $username bash

su $username -c "./pyenv_install.sh"

# Cleanup
echo "Cleaning up..."
sudo apt autoremove -y

# Installation complete
echo "Installation complete!"
