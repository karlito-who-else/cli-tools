#!/bin/sh

cd `dirname $0`

echo $""

# Request user for their GitHub token so that various tools may access their GitHub account.
echo "Please enter your GitHub token.  See https://help.github.com/articles/creating-an-access-token-for-command-line-use/ for help."
echo $""
echo "Please enter your GitHub token followed by [ENTER]:"
read GITHUB_TOKEN

# Set GITHUB_TOKEN value in .bash_rc file
if grep -Fxq "GITHUB_TOKEN" ~/.bash_rc
then
	# code if found
	echo "GITHUB_TOKEN already present in ${HOME}/.bashrc, skipping."
else
	# code if not found
	echo "export GITHUB_TOKEN='$GITHUB_TOKEN'" >> ~/.bash_rc
fi

if [ "$(uname)" == "Darwin" ]; then
	# Do something under Mac OS X platform
	#source ./environment/osx.sh
	source <(curl -fsSL https://raw.githubusercontent.com/karl-wednesday/cornerstone/master/environment/osx.sh)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	# Do something under Linux platform
	LSB_RELEASE=/etc/lsb-release

	if [ -f LSB_RELEASE ]; then
		DISTRIB_ID=`cat LSB_RELEASE | sed -n 's/^DISTRIB_ID=//p'`
	fi

	echo "DISTRIB_ID: $DISTRIB_ID"

	if [[ $DISTRIB_ID = 'Ubuntu' ]]; then
		#bash ./environment/ubuntu.sh
		bash <(curl -fsSL https://raw.githubusercontent.com/karl-wednesday/cornerstone/master/environment/ubuntu.sh)
	else
		echo "Please update this file to work with the package manager for this distribution"
	fi

elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
	# Do something under Windows NT platform
	echo "LOL Windows"
	exit
fi

# Run the confguration file specific to this environment
#bash ./environment/posix.sh
bash <(curl -fsSL https://raw.githubusercontent.com/karl-wednesday/cornerstone/master/environment/posix.sh)
