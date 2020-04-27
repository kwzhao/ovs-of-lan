#!/bin/bash

# Get the list of experiment links into the OVS node.
LANS=`cat /var/emulab/boot/tblans.list`

# Create a bridge for forwarding traffic between nodes.
ovs-vsctl add-br br0

for lanstr in $LANS; do
    read foo bar mac <<< "$lanstr"
    ifname=`/usr/local/etc/testbed/findif -m $mac`
    ip addr flush dev $ifname
    ovs-vsctl add-port br0 $ifname
done

exit 0
