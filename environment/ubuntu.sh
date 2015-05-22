#!/bin/sh

#cd `dirname $0`

sudo apt-get update && sudo apt-get upgrade

sudo apt-get install build-essential ruby-full rubygems-update git npm mongodb imagemagick graphicsmagick

# Update gem via gem
sudo update_rubygems

#exit
