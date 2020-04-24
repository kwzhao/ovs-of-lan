#!/bin/bash

apt-get -q update
apt-get -q install -y openvswitch-switch
#apt-get -q install -y gcc python-pip python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev
apt-get -q install -y python-pip
pip install ryu

# Nothing yet!
exit 0
