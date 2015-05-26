#!/bin/sh

# Update apt-get packages list
sudo apt-get update

# Upgrade installed apt-get packages
sudo apt-get upgrade

# Install packages using apt-get
sudo apt-get install build-essential ruby-full rubygems-update git npm mongodb imagemagick graphicsmagick

# Update gem via gem
sudo update_rubygems
