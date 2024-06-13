#!/bin/bash

apt-get -qq update
apt-get -q install -y iperf3
/local/repository/configure-shell.sh || exit 1
exit 0
