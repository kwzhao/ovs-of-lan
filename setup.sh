#!/bin/bash

# Initial stuff
apt-get -qq update

# Install OVS
apt-get -q install -y openvswitch-switch

# Install Floodlight controller prerequisites
#apt-get -q install -y build-essential default-jdk ant python-dev

# Download and build Floodlight
#git clone git://github.com/floodlight/floodlight.git /local/floodlight || exit 1
#cd /local/floodlight || exit 1
#ant || exit 1
#mkdir /var/lib/floodlight && \
#  chmod 777 /var/lib/floodlight || exit 1

# Setup OVS
/local/repository/setup-ovs.sh || exit 1

# Done!
exit 0
