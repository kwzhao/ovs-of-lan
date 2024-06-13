#!/bin/bash

sudo apt-get -qq update
sudo apt-get -q install -y openvswitch-switch iperf3
sudo /local/repository/run-ovs.sh || exit 1
/local/repository/configure-shell.sh || exit 1
exit 0
