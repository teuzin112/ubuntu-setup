#!/bin/bash

set -e  # Exit on any error

# Update and upgrade packages
echo "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

# Install PostgreSQL and PostGIS
echo "Installing PostgreSQL and PostGIS..."
sudo apt install -y postgresql postgresql-contrib postgis

# Enable and start PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Install pgAdmin Desktop
echo "Installing pgAdmin Desktop..."
sudo apt install -y wget curl
gpg_key="https://www.pgadmin.org/static/packages_pgadmin_org.pub"
echo "Adding pgAdmin repository..."
wget -qO- $gpg_key | gpg --dearmor > packages_pgadmin_org.gpg
sudo install -o root -g root -m 644 packages_pgadmin_org.gpg /etc/apt/trusted.gpg.d/
echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/jammy pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin4.list
sudo apt update && sudo apt install -y pgadmin4-desktop

# Install QGIS
echo "Installing QGIS..."
sudo apt install -y software-properties-common
echo "deb [signed-by=/usr/share/keyrings/qgis-archive.gpg] https://qgis.org/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/qgis.list
echo "Adding QGIS repository key..."
wget -qO - https://qgis.org/downloads/qgis-archive.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/qgis-archive.gpg >/dev/null
sudo apt update && sudo apt install -y qgis qgis-plugin-grass

# Install pyenv dependencies
echo "Installing pyenv dependencies..."
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libffi-dev liblzma-dev python3-openssl git

# Install pyenv
echo "Installing pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
else
    echo "pyenv is already installed."
fi

# Add pyenv to shell
if ! grep -q 'pyenv init' ~/.bashrc; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init --path)"\nfi' >> ~/.bashrc
fi

# Cleanup
echo "Cleaning up..."
sudo apt autoremove -y

# Installation complete
echo "Installation complete!"
