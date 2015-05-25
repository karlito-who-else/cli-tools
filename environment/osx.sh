#!/bin/sh

#cd `dirname $0`

# Install X-Code Command Line Tools
xcode-select --install

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update and cleanup Homebrew
brew update && brew cleanup

# Install Brew Cask from Homebrew
brew install caskroom/cask/brew-cask

# Update and cleanup Homebrew Cask
brew upgrade brew-cask && brew cask cleanup

# Install rbenv and ruby-build from Homebrew
brew install rbenv ruby-build

# Add rbenv to bash so that it loads every time you open a terminal
if grep -Fxq "$(rbenv init -)" ~/.bash_rc
then
	# code if found
else
	# code if not found
	echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
fi

# source updated .bash_profile file
source ~/.bash_profile

# Install Ruby 2.1.3 from rbenv
rbenv install 2.1.3

# Set Ruby 2.1.3 as the default version
rbenv global 2.1.3

# Check environment ruby is using the latest version installed by rbenv
ruby -v

# Install pip package management system which is used to install and manage software packages written in Python.
sudo easy_install pip
#easy_install pip

# brew tap allows you to import formula from other repositories into your Homebrew instance.
#brew tap homebrew/apache
brew tap homebrew/dupes
brew tap homebrew/versions

# Set Homebrew options

# Verify
brew update && brew upgrade --all

# Install Homebrew formulae for command line applications
brew install git
brew install mackup
brew install shellcheck
brew install wget

# Set up node (including npm)
brew install node

# Set NODE_ENV value in .bash_rc file
if grep -Fxq "NODE_ENV" ~/.bash_rc
then
	# code if found
else
	# code if not found
	echo 'export NODE_ENV=development' >> ~/.bash_rc
fi

# Update gem via gem
gem update --system

# Install AWS Command Line Interface from pip
sudo pip install awscli --upgrade
#pip install awscli --upgrade

# Install Homebrew cask formulae for GUI-based applications
brew cask install atom
brew cask install cakebrew
brew cask install deltawalker
brew cask install firefox
brew cask install github
brew cask install google-chrome
brew cask install tower
brew cask install transmit
brew cask install sequel-pro
brew cask install skype

#exit
