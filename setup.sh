#!/bin/bash

# Initial stuff
apt-get -qq update

# Install OVS and Python pip
apt-get -q install -y openvswitch-switch

# Run OVS
# /local/repository/run-ovs.sh || exit 1

# Done!
exit 0
