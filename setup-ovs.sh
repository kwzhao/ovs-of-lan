#!/bin/bash

apt-get -qq update
apt-get -q install -y openvswitch-switch iperf3
/local/repository/run-ovs.sh || exit 1
/local/repository/configure-shell.sh || exit 1
exit 0
