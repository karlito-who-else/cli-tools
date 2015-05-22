#!/bin/sh

# Set git to ignore case sensitivity (particularly relevant fror OS-X)
git config core.ignorecase false

# Clear npm cache
npm cache clean -f

# Update npm via npm
sudo npm update -g npm

# Install cli utilities from gem
gem install bundler
#gem install scss_lint

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

# List globally installed cli utilities from npm
npm list -g --depth=0

# Install Yeoman generators from npm
npm install -g generator-generator
#npm install -g generator-webapp

# Install latest development version of node using n
n latest

# Check environment node is using the latest version installed by n
node -v

exit
