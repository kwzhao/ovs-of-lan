#!/bin/bash

# Create a bridge for forwarding traffic between nodes.
ovs-vsctl add-br br0

# Add all experimental network link interfaces to the OVS bridge.
IFS=$'\n'
for lanstr in `cat /var/emulab/boot/ifmap`; do
    IFS=" " read ifname ipaddr mac <<< "$lanstr"
    ip addr flush dev $ifname
    ip addr add "{$ipaddr}"/24 dev br0
    ip link set br0 up
done

exit 0
