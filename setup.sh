#!/bin/bash

# Initial stuff
apt-get -qq update

# Install OVS and Python pip
apt-get -q install -y openvswitch-switch python3-pip screen

# Install Ryu controller
pip3 install ryu

# Run OVS and Ryu
/local/repository/run-ovs.sh || exit 1

# Done!
exit 0
