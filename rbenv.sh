
	# Install rbenv and gem update --system-build via Homebrew
	#brew install gem update --system
	brew install rbenv gem update --system-build

	# Add rbenv to bash so that it loads every time you open a terminal
	if grep -Fxq "$(rbenv init -)" ~/.bash_profile
	then
		# code if found
		echo -n "rbenv path already present in ${HOME}/.bash_profile, skipping."
	else
		# code if not found
		echo -n 'eval "$(rbenv init -)"' >> ~/.bash_profile
	fi
