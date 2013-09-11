#!/bin/sh

# A simple script for setting up OSX environment. Abort if not OSX.
if [ $(uname) != "Darwin" ];
then
	exit 1
fi

# Xcode Command-line Tools is required. Abort if not installed.
if [ ! -f /var/db/receipts/com.apple.pkg.DeveloperToolsCLI.bom ]
then
	echo "Xcode Command-Line Tools is required."
	exit 1
fi

# Ask for password only at the beginning
sudo -v 

# ------
# Setup Hostname and etc
# ------
echo Hostname: $(scutil --get HostName)
echo Local Hostname: $(scutil --get LocalHostName)
echo Computer name: $(scutil --get ComputerName)
echo 'Change settings? (y/n)'
read reply
if [ reply = y ]; then
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
unset reply

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

brew tap homebrew/versions
brew tap homebrew/dupes
brew tap phinze/homebrew-cask

echo 'Updating formulae and homebrew...'
brew update
brew upgrade

echo 'Installing brew packages...'

brew install brew-cask
brew install bash
brew install bash-completion
brew install git
brew install hub
brew install trash
brew install tree
brew install webkit2png
brew install wget

brew cleanup
echo 'Homebrew packages installed.'

# ------
# Install brew cask packages
# ------
brew info brew-cask | grep "Not installed" > /dev/null;
if [ $? = 1  ];
then
	echo 'Error: brew-cask not installed.' 
	echo 'Preparing to install brew-cask via homebrew...'
	brew update
	brew upgrade
	echo 'Installing brew-cask via homebrew...'
	brew install brew-cask
	echo 'Success: brew-cask installed.'
fi

function installcask() {  
  brew cask info "${@}" | grep "Not installed" > /dev/null
  if [ $? = 1  ];
  then
  	echo "Installing: ${@}"
    brew cask install "${@}"
  else
    echo "Found: ${@} is already installed."
  fi
}

echo 'Preparing to install favourite OSX applications...'
brew update
brew upgrade

echo 'Your user password may be required by some applications. Please check back occasionally.'
echo 'Installing favourite OSX applications...'

installcask adium
installcask bettertouchtool
installcask cyberduck
installcask dropbox
installcask github
installcask google-chrome
installcask google-chrome-canary
installcask iterm2
installcask sublime-text
installcask the-unarchiver
installcask transmission
installcask vagrant
installcask virtualbox
installcask vlc 

# Relegated Applications
# installcask evernote
# installcask skitch
# installcask hip-chat
# installcask lime-chat
# installcask layervault
# installcask skype
# installcask spotify
# installcask xtra-finder

brew cleanup
echo 'Favourite OSX applications installed.'

# ------
# Setup bash 4.2
# ------
echo 'Set bash version 4.2 as default (y/n)'
read reply
if [ reply = yes ];
then
	grep -q '/usr/local/bin/bash' /etc/shells
	if [ $? -ne 0 ]
		sudo -s $(printf '\n/usr/local/bin/bash' >> /etc/shells)
		chsh -s /usr/local/bin/bash.
fi
unset reply

# ------
# Setup sane OSX ML defaults
# ------
echo 'Set sane OSX Mountain Lion defaults? (y/n)'
read reply
if [ reply = yes ];
then
	source setup_osxdefaults.sh
fi
unset reply

echo 'Completed setup for OSX Mountain Lion. Do you wish to restart the system? (y/n)'
read reply
if [ reply = yes ];
then
	sudo reboot
fi