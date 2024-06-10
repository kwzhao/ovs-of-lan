#!/bin/bash

# Create a bridge for forwarding traffic between nodes.
ovs-vsctl add-br br0

# Add all experimental network link interfaces to the OVS bridge.
IFS=$'\n'
for lanstr in `cat /var/emulab/boot/ifmap`; do
    IFS=" " read ifname ipaddr mac <<< "$lanstr"
    ovs-vsctl add-port br0 $ifname
    ip link set up dev $ifname
done

exit 0
