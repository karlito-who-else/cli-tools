#!/bin/sh

cd `dirname $0`

# Set GITHUB_TOKEN value in .bash_rc file
if grep -Fq "GITHUB_TOKEN" ~/.bash_rc
then
	echo -n "GITHUB_TOKEN already present in ${HOME}/.bashrc, skipping."
else
	# Request user for their GitHub token so that various tools may access their GitHub account.
	echo -n "It is recommended that you configure a GitHub token for command line usage.  See https://help.github.com/articles/creating-an-access-token-for-command-line-use/ for information help with gnerating a token."
	echo -n "Please enter your GitHub token followed by [ENTER]:"
	read GITHUB_TOKEN

	echo -n "export GITHUB_TOKEN='$GITHUB_TOKEN'" >> ~/.bash_rc
fi

echo

if [ "$(uname)" == "Darwin" ]; then
	# Do something under Mac OS X platform
	#source ./environment/osx.sh

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
		echo -n "rbenv path already present in ${HOME}/.bashrc, skipping."
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
	brew install awscli
	brew install boot2docker
	brew install git
	brew install gh
	brew install graphicsmagick
	brew install imagemagick
	brew install mackup
	brew install mongodb
	brew install node
	brew install openssl
	brew install php
	brew install mysql
	brew install redis
	brew install ruby
	brew install shellcheck
	brew install wget

	# Install Homebrew cask formulae for GUI-based applications
	brew cask install atom
	brew cask install cakebrew
	brew cask install deltawalker
	brew cask install dropbox
	brew cask install firefox
	brew cask install github
	brew cask install google-chrome
	brew cask install tower
	brew cask install transmit
	brew cask install sequel-pro
	brew cask install skype

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	# Do something under Linux platform
	LSB_RELEASE=/etc/lsb-release

	if [ -f LSB_RELEASE ]; then
		DISTRIB_ID=`cat LSB_RELEASE | sed -n 's/^DISTRIB_ID=//p'`
	fi

	echo -n "DISTRIB_ID: $DISTRIB_ID"

	if [[ $DISTRIB_ID = 'Ubuntu' ]]; then
		#bash ./environment/ubuntu.sh

		# Update apt-get packages list
		sudo apt-get update

		# Upgrade installed apt-get packages
		sudo apt-get upgrade

		# Install packages using apt-get
		sudo apt-get install build-essential ruby-full rubygems-update git npm mongodb imagemagick graphicsmagick

		# Update gem via gem
		sudo update_rubygems

	else
		echo -n "Please update this file to work with the package manager for this distribution"
	fi

elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
	# Do something under Windows NT platform
	echo -n "LOL Windows"
	exit
fi

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

# Install cli utilities from gem
gem install bundler
#gem install scss_lint

# Install cli utilities from pip
#sudo pip install awscli --upgrade

# Clear npm cache
npm cache clean -f

# Update npm via npm
sudo npm update -g npm

# Install cli utilities globally from npm
npm install -g bower
npm install -g browser-sync
#npm install -g cordova
#npm install -g grunt-cli
npm install -g gulp
#npm install -g harp
#npm install -g ionic
#npm install -g imagemin
#npm install -g istanbul
npm install -g jscs
npm install -g jshint
npm install -g jsonlint
#npm install -g mocha
npm install -g n
#npm install -g node-inspector
npm install -g npm-check-updates
#npm install -g npm-update-all
#npm install -g npmedge
#npm install -g pm2
npm install -g scss-lint
#npm install -g strongloop
npm install -g tslint
npm install -g unused-deps
npm install -g yo

# Install Yeoman generators from npm
npm install -g generator-generator
#npm install -g generator-webapp

# Install latest development version of node using n
n latest

# Check environment node is using the latest version installed by n
node -v

# List globally installed npm packages
npm list -g --depth=0

# Install Composer globally
mkdir -p /usr/local/bin
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Set git to ignore case sensitivity (particularly relevant for OS-X)
git config core.ignorecase false
