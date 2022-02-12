#!/bin/bash

# WIP (USE WITH CAUTION)

# This script performs a basic system setup for GNU/Linux systems to my liking
# Should work on most systems using bash
# Currently this is a work in progress so it is not guaranteed to work correctly

# Requirements:
# - git
# - curl
# - wget
# - python3

# Installs packages for all systems
# These should not requires sudo access
# Usually using tools like pip and cargo
# Or just installing prebuilt binaries/appimages with wget/curl
function install_packages {
	echo "Installing packages..."
	
	# Cargo packages
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	cargo install alacritty gitui

	# Pip packages
	python3 -m ensurepip
	python3 -m pip install ranger-fm

	# Install vim appimage
	APPIMAGE_URL=$(curl -s "https://api.github.com/repos/vim/vim-appimage/releases/latest" | jq --raw-output '.assets[0] | .browser_download_url')
	wget $APPIMAGE_URL -O ~/.bin/vim
	chmod +x ~/.bin/vim
}

# Check the requirements
echo "Checking requirements..."
command -v git || exit 1
command -v curl || exit 1
command -v wget || exit 1

# Setup git
# Specifically asks for github credentials for use with chezmoi
echo "Setting git credentials..."
read -p "Github Username: " USERNAME
git config --global user.name $USERNAME
read -p "Github Email: " EMAIL
git config --global user.email $EMAIL

# Generate ssh key
if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
	echo "Generating SSH key..."
	echo "Please use the default location"
	command -v ssh-keygen || exit 1
	ssh-keygen -t rsa -b 4096
fi

echo "Register the following key in github:"
cat ~/.ssh/id_rsa.pub
read -p "Press enter to continue"

# Setup dotfiles using chezmoi
if command -v chezmoi; then
	echo "Skipping chezmoi dotfile setup..."
else
	echo "Setting up dotfiles..."
	sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply --ssh $USERNAME
	mv ~/bin/* ~/.bin/
	echo "# Source the config" >> ~/.bashrc
	echo "source ~/.config/bash_config.sh" >> ~/.bashrc
fi

# Install the extra packages
read -p "Install packages [Y/n]: " INSTALL
if [[ $INSTALL == "Y" || $INSTALL == "y" ]]; then
	install_packages
fi
