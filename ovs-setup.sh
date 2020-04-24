#!/bin/bash

# Initial stuff
apt-get -qq update

# Install OVS
apt-get -q install -y openvswitch-switch

# Install Floodlight controller prerequisites
apt-get -q install -y build-essential default-jdk ant python-dev

# Download, build, and install Floodlight
git clone git://github.com/floodlight/floodlight.git /local
cd /local/floodlight
ant
mkdir /var/lib/floodlight
chmod 777 /var/lib/floodlight

# Done!
exit 0
