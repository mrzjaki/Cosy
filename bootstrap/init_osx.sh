#!/bin/bash

# A simple script for setting up OSX environment. Abort if not OSX.
if [ $(uname) != "Darwin" ];
then
	exit 1
fi

# Xcode Command-line Tools is required. Abort if not installed.
XCODE_COMMANDLINETOOLS='/Library/Developer/CommandLineTools'
XCODE_FULL='/Applications/Xcode.app/Contents/Developer'
XCODE_STATUS=$(xcode-select -p)

if [ $XCODE_STATUS != $XCODE_COMMANDLINETOOLS ] || [ $XCODE_STATUS != $XCODE_FULL ]; then
	echo "Xcode Command-Line Tools is required."
	exit 1
fi
unset XCODE_COMMANDLINETOOLS
unset XCODE_FULL
unset XCODE_STATUS

# Ask for password only at the beginning
sudo -v 

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ------
# Setup Hostname and etc
# ------
echo Hostname: $(scutil --get HostName)
echo Local Hostname: $(scutil --get LocalHostName)
echo Computer name: $(scutil --get ComputerName)
echo 'Change settings? (y/n)'
read REPLY
if [ $REPLY = y ]; then
	echo 'Enter new hostname of the machine (e.g. mbp-eden)'
	read hostname
	echo 'Setting new hostname to $hostname...'
	scutil --set HostName "$hostname"
	echo 'Setting new local hostname to $hostname'
	scutil --set LocalHostName "$hostname"
	defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
	compname=$(sudo scutil --get HostName | tr '-' '.')
	echo 'Setting computer name to $compname'
	scutil --set ComputerName "$compname"
fi
unset REPLY

# ------
# Install Homebrew
# ------
hash brew 2> /dev/null
if [ $? = 1  ];
then
	echo 'Installing: homebrew...'
	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
else
	echo 'Found: homebrew is already installed.'
fi

# ------
# Install brew packages
# ------
echo 'Preparing to install homebrew packages...'
#brew bundle
echo 'Brew packages and casks installed.'

# ------
# Setup bash 4.2
# ------
read -p 'Default to latest bash version from homebrew packages (y/n)' REPLY
if [ $REPLY = "y" ];
then
	if [ -f '/usr/local/bin/bash' ]; then
		echo "Latest BASH installed via homebrew"
	else
		echo "Latest BASH not installed from homebrew. Please install via brew command."
		exit 1
	fi

	grep -q '/usr/local/bin/bash' /etc/shells
	if [ $? -ne 0 ]; then
		echo "Latest BASH is not configured."
		# Add the new shell to the list of legit shells
		sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
	fi

	if [ $BASH != "/usr/local/bin/bash" ]; then
		# Change the shell for the user
		chsh -s /usr/local/bin/bash
	fi
	echo $BASH && echo $BASH_VERSION
fi
unset REPLY

# ------
# Setup sane OSX ML defaults
# ------
echo 'Set sane OSX Mavericks defaults? (y/n)'
read REPLY
if [ $REPLY = "y" ];
then
	source setup_osxdefaults.sh
fi
unset REPLY

echo 'Completed setup for OSX Mavericks. Do you wish to restart the system? (y/n)'
read REPLY
if [ $REPLY = "y" ];
then
	sudo reboot
fi
unset REPLY

echo 'Awesomeness is completed.'