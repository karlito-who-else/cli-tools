#!/bin/sh

RUBY_VERSION=2.2.2
NODE_VERSION=5.0.0

MACKUP_CONFIG_CORE="[storage]
engine = icloud"

MACKUP_CONFIG_SSH="[application]
name = SSH

[configuration_files]
.ssh"

cd `dirname $0`

echo -e "\033[31m
       .__  .__            __                .__
  ____ |  | |__|         _/  |_  ____   ____ |  |   ______
_/ ___\|  | |  |  ______ \   __\/  _ \ /  _ \|  |  /  ___/
\  \___|  |_|  | /_____/  |  | (  <_> |  <_> )  |__\___ \
 \___  >____/__|          |__|  \____/ \____/|____/____  >
     \/                                                \/
\033[0m\n"

#--- Permissions
echo -e "\033[1;4;34mChecking User Permissions...\033[0m\n"

if [ "$(whoami)" == "root" ]; then
	echo -n "You should not run this script as the root user!"
	exit 2
fi
echo -e "\033[32mOK\033[0m\n"

# Set GITHUB_TOKEN value in .bash_profile file
if grep -Fq "GITHUB_TOKEN" ~/.bash_profile
then
	echo -n "GITHUB_TOKEN already present in ${HOME}/.bash_profile, skipping."
else
	# Request user for their GitHub token so that various tools may access their GitHub account.
	echo -n "It is recommended that you configure a GitHub token for command line usage.  See https://help.github.com/articles/creating-an-access-token-for-command-line-use/ for information help with gnerating a token."
	echo -n "Please enter your GitHub token followed by [ENTER]:"
	read GITHUB_TOKEN

	echo -n "export GITHUB_TOKEN='$GITHUB_TOKEN'" >> ~/.bash_profile
fi

echo # Insert blank line for legibility

if [ "$(uname)" == "Darwin" ]; then
	# Do something under Mac OS X platform
	#source ./environment/osx.sh

	# Show hidden files in Finder
	defaults write com.apple.finder AppleShowAllFiles YES

	# Install X-Code Command Line Tools
	xcode-select --install

	# Uninstall MacPorts
	echo -e "\033[1;4;34mChecking MacPorts installation status...\033[0m\n"

	hash port &> /dev/null
	if [ $? -eq 1 ]; then
		echo -e "\033[32mMacPorts not found.  Proceeding...\033[0m\n"
	else
		echo -e "\033[1;4;31mWARNING.\033[0m  This script will attempt to uninstall MacPorts and everything that has been installed via MacPorts.  Would you like to continue anyway?\n"
		#echo $'WARNING.  This script will attempt to uninstall MacPorts and everything that has been installed via MacPorts.  Would you like to continue anyway?\n'
		read CONTINUE
		if [ $CONTINUE = 'yes' ] || [ $CONTINUE = 'y' ]; then
			echo $'You have been warned!  MacPorts will now be uninstalled.\n'
			sudo port -f uninstall installed
			sudo rm -rf /opt/local
			sudo rm -rf /Applications/DarwinPorts
			sudo rm -rf /Applications/MacPorts
			sudo rm -rf /Library/LaunchDaemons/org.macports.*
			sudo rm -rf /Library/Receipts/DarwinPorts*.pkg
			sudo rm -rf /Library/Receipts/MacPorts*.pkg
			sudo rm -rf /Library/StartupItems/DarwinPortsStartup
			sudo rm -rf /Library/Tcl/darwinports1.0
			sudo rm -rf /Library/Tcl/macports1.0
			sudo rm -rf ~/.macports
		else
			echo $'Aborting configuration process.\n'
			exit
		fi
	fi

	# Configure Homebrew
	hash brew &> /dev/null
	if [ $? -eq 1 ]; then
		echo $'Homebrew not found.  Installing...\n'
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew doctor
	else
		HOMEBREW_PATH=$(which brew)
		HOMEBREW_PATH_MATCH=$(awk 'BEGIN { print index("${PATH}", "${HOMEBREW_PATH}") }')
		HOMEBREW_CELLAR_PATH=$(brew --cellar)
		HOMEBREW_UTILITY_PATH='/usr/local/bin'
		HOMEBREW_UTILITY_PATH_MATCH=$(awk -v PATH=$PATH -v HOMEBREW_UTILITY_PATH=$HOMEBREW_UTILITY_PATH 'BEGIN { print index(PATH, HOMEBREW_UTILITY_PATH) }')

		 if [ ${HOMEBREW_UTILITY_PATH_MATCH} -eq 0 ] ; then
			 echo $'Homebrew is installed at the following path:'
			 echo $HOMEBREW_UTILITY_PATH$'\n'

			 echo $'Your Homebrew utility directory is not available on the system path:\n'
			 echo $PATH$'\n'
			 echo $'Would you like to add the Homebrew utility directory to your system path?'

			 read CONTINUE
			 if [ $CONTINUE = 'yes' ] || [ $CONTINUE = 'y' ]; then
				 export PATH=$HOMEBREW_UTILITY_PATH":"$PATH
				 echo -n "export PATH=\"${HOMEBREW_UTILITY_PATH}:$PATH\"" >> .bash_profile
				 echo $'Your PATH environment variable is now set to.'$PATH$'\n'
			 else
				 echo $'Aborting build process.\n'
				 exit
			 fi
		 fi

		#HOMEBREW_STATUS=$(brew doctor)
		#echo $HOMEBREW_STATUS$'\n'

		brew doctor

		echo $'Pruning broken symlinks.\n'
		brew prune

		echo $'Removing old versions of installed packages.\n'
		brew cleanup

		echo $'Updating Homebrew.\n'
		brew update

		echo $'Installing missing dependancies.\n'
		brew install $(brew missing | cut -d' ' -f2- )

		echo $'Listing outdated Homebrew formulae.\n'
		brew outdated

		echo $'Upgrading outdated Homebrew formulae.\n'
		brew upgrade --all

		echo $'Unlinking and re-linking all formulas and kegs.\n'
		ls -1 /usr/local/Library/LinkedKegs | while read line; do echo $line; brew unlink $line; brew link --force $line; done
		brew list -1 | while read line; do brew unlink $line; brew link $line; done

		HOMEBREW_STATUS=$(brew doctor)

		echo $HOMEBREW_STATUS$'\n'

		if [ "$HOMEBREW_STATUS" != 'Your system is ready to brew.' ]; then
			echo $'You have an error or warning with your Homebrew installation that must be resolved before this build process can continue.'
			echo $'Please ensure that your system is ready to brew.\n'
			exit
		else
			echo $'System is ready to brew.\n'
		fi
	fi
	echo -e "\033[32mOK\033[0m\n"

	# Install Brew Cask via Homebrew
	#brew install caskroom/cask/brew-cask
	brew tap caskroom/cask

	# Update and cleanup Homebrew Cask
	#brew upgrade brew-cask && brew cask cleanup

	# Install XQuartz
	#brew cask install xquartz
	brew install Caskroom/cask/xquartz

	# source updated .bash_profile file
	source ~/.bash_profile

	# Install defined Ruby version via rbenv
	#rbenv install $RUBY_VERSION

	# Set defined Ruby version as the default version
	#rbenv global $RUBY_VERSION

	# Check environment ruby is using the latest version installed by rbenv
	#ruby -v

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
	brew install autoconf
	brew install awscli
	brew install batik
	#brew install boot2docker
	brew install bradp/vv/vv
	brew install dnsmasq
	#brew install docker
	#brew install docker-compose
	brew install faac
	brew install ffmpeg --with-faac --with-fdk-aac --with-ffplay --with-freetype --with-libass --with-libquvi --with-libvorbis --with-libvpx --with-opus --with-x265
	brew install fontforge
	brew install git
	brew install git-extras
	brew install git-flow-avh
	brew install git-lfs
	brew install gh
	brew install gmp # ruby needs this, not sure why
	#brew install gnu-getopt
	brew install gpg
	brew install graphicsmagick
	brew install imagemagick
	brew install mackup
	brew install mariadb
	#brew install mongodb
	#brew install mysql
	brew install node
	brew install openssl
	brew install pkg-config
	brew install readline
	#brew install redis
	brew install shellcheck
	brew install ssh-copy-id
	brew install terraform
	brew install ttf2eot
	brew install wget

	# Configure PHP
	brew install php56
	brew unlink php56
	brew install php71
	brew unlink php71
	brew install brew-php-switcher
	#brew install php56 --homebrew-apxs --with-apache --with-homebrew-curl --with-homebrew-openssl --with-phpdbg --with-tidy --without-snmp
	#chmod -R ug+w /usr/local/Cellar/php56/5.6.9/lib/php
	#pear config-set php_ini /usr/local/etc/php/5.6/php.ini
	#printf '\nAddHandler php5-script .php\nAddType text/html .php' >> /usr/local/etc/apache2/2.4/httpd.conf
	#perl -p -i -e 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' /usr/local/etc/apache2/2.4/httpd.conf
	#printf '\nexport PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"' >> ~/.profile
	#echo 'export PATH="$(brew --prefix php56)/bin:$PATH"' >> ~/.bash_profile
	#ln -sfv /usr/local/opt/php56/*.plist ~/Library/LaunchAgents
	#brew install php-version
	brew install homebrew/php/composer # install here to avoid unsatisfied requirement failure
	brew install wp-cli

	# Quick Look plugins, see https://github.com/sindresorhus/quick-look-plugins
	brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package

	# Install Homebrew cask formulae for GUI-based applications
	brew cask install atom
	brew cask install cakebrew
	brew cask install deltawalker
	#brew cask install dockertoolbox
	brew cask install docker-toolbox
	#brew cask install dropbox
	brew cask install firefox
	brew cask install flux
	brew cask install github
	brew cask install google-chrome
	brew cask install iexplorer
	brew cask install openemu
	brew cask install sequel-pro
	brew cask install skype
	brew cask install steam
	brew cask install tower
	brew cask install transmit
	#brew cask install virtualbox #ordering!
	brew cask install vagrant
	brew cask install vagrant-manager
	brew cask install vlc

	#echo "$MACKUP_CONFIG_CORE" > ~/.mackup.cfg
  	#echo "$MACKUP_CONFIG_SSH" > ~/.mackup/ssh.cfg

	# create boot2docker vm
	#boot2docker init

	# vm needs to be powered off in order to change these settings without VirtualBox blowing up
	#boot2docker stop > /dev/null 2>&1

	# Downloading latest boot2docker ISO image
	#boot2docker upgrade

	# forward default docker ports on vm in order to be able to interact with running containers
	#echo -n 'eval "$(boot2docker shellinit)"' >> ~/.bash_profile

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

		# Install cli utilities via pip
		sudo pip install awscli --upgrade
		sudo pip install docker-compose --upgrade
	else
		echo -n "Please update this file to work with the package manager for this distribution"
	fi

elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
	# Do something under Windows NT platform
	echo -n "LOL Windows"
	exit
fi

# Set NODE_ENV value in .bash_profile file
if grep -Fxq "NODE_ENV" ~/.bash_profile
then
	# code if found
	echo -n "NODE_ENV already present in ${HOME}/.bash_profile, skipping."
else
	# code if not found
	echo -n "export NODE_ENV=development" >> ~/.bash_profile
fi

# Install Composer globally # install via brew
#mkdir -p /usr/local/bin
#curl -sS https://getcomposer.org/installer | php
#mv composer.phar /usr/local/bin/composer

# Update gem via gem
gem update --system

# Install cli utilities via gem
#gem install bundler
#gem install sass
#gem install scss_lint
gem install travis -v 1.8.2 --no-rdoc --no-ri

# Install php-cs-fixer via Composer
#composer global require fabpot/php-cs-fixer
composer global require friendsofphp/php-cs-fixer
echo -n "export PATH=\"$PATH:$HOME/.composer/vendor/bin\"" >> .bash_profile

# Clear npm cache
npm cache clean -f

# Update npm via npm
sudo npm update -g npm

# Install n node version manager via npm
#npm install -g n

# Install latest development version of node using n
#sudo n latest

# Check environment node is using the latest version installed by n
node -v

# Install cli utilities globally via npm
npm install -g babel-cli
npm install -g babel-eslint
npm install -g bower
#npm install -g bower-check-updates
#npm install -g browser-sync
#npm install -g cordova
npm install -g eslint
npm install -g grunt-cli
npm install -g gulp
#npm install -g harp
#npm install -g ionic
#npm install -g imagemin
#npm install -g istanbul
npm install -g jscs
npm install -g jshint
npm install -g jsonlint
npm install -g manifoldjs
#npm install -g mocha
#npm install -g node-inspector
npm install -g npm-check-updates
#npm install -g npm-update-all
#npm install -g npmedge
#npm install -g pm2
#npm install -g polylint
npm install -g polymer-cli
#npm install -g scss-lint
#npm install -g strongloop
npm install -g tslint
npm install -g unused-deps
npm install -g yo

# Install Yeoman generators via npm
npm install -g generator-generator
#npm install -g generator-webapp

# Set git to respect case sensitivity (particularly relevant for OS-X)
git config core.ignorecase false

# Install Atom packages via apm
apm install atom-change-case
apm install angularjs
apm install atom-beautify
apm install atom-typescript
apm install autocomplete-php
apm install autocomplete-sass
apm install autoprefixer
apm install caniuse
apm install clipboard-history
#apm install code-links
apm install color-picker
apm install css-snippets
apm install csscomb
apm install emmet
apm install file-icons
apm install gulp-helper
apm install ionic-atom
apm install js-hyperclick
apm install jscs-fixer
#apm install jsformat
apm install language-docker
apm install language-ejs
apm install linter
apm install linter-csslint
apm install linter-htmlhint
apm install linter-jscs
apm install linter-jshint
apm install linter-jsonlint
apm install linter-less
apm install linter-php
apm install linter-puppet-lint
apm install linter-sass-lint
#apm install linter-scss-lint
apm install linter-shellcheck
apm install linter-tidy
apm install linter-tslint
apm install local-history
apm install merge-conflicts
apm install minimap
apm install minimap-bookmarks
apm install minimap-codeglance
apm install minimap-find-and-replace
apm install minimap-git-diff
apm install minimap-highlight-selected
apm install minimap-linter
apm install minimap-pigments
apm install minimap-selection
apm install npm-install
apm install php-cs-fixer
apm install pigments
apm install polymer-snippets
apm install project-manager
apm install tabs-to-spaces
apm install travis-ci-status
apm install symbols-tree-view
apm install Sublime-Style-Column-Selection
apm install atom-wallaby

# Update Atom packages via apm
apm update

# Install Vagrant plugins via vagrant
#vagrant plugin install vagrant-hostsupdater
#vagrant plugin install vagrant-triggers

curl https://sdk.cloud.google.com | bash

# source updated .bash_profile file
source ~/.bash_profile

# Check if rbenv was set up
type rbenv

# List globally installed npm packages
npm list -g --depth=0

# List installed apm packages
apm list --installed --bare

open https://itunes.apple.com/en/app/xcode/id497799835?mt=12

echo -n "Further (manual) configuration:"

echo -n "https://itunes.apple.com/en/app/xcode/id497799835?mt=12"
echo -n "https://github.com/leogopal/VVV-Dashboard"

# Restart shell, see https://cloud.google.com/sdk/#Quick_Start
exec -l $SHELL

exit
