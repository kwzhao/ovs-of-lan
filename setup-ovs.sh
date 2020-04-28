#!/bin/bash

# Start Ryu OpenFlow controller listening on localhost
screen -d -m -S "ryu-manager" ryu-manager --verbose --ofp-listen-host 127.0.0.1 ryu.app.simple_switch

# Create a bridge for forwarding traffic between nodes.
ovs-vsctl add-br br0

# Add all experimental network link interfaces to the OVS bridge.
IFS=$'\n'
for lanstr in `cat /var/emulab/boot/ifmap`; do
    IFS=" " read ifname ipaddr mac <<< "$lanstr"
    ip addr flush dev $ifname
    ip link set up dev $ifname
    ovs-vsctl add-port br0 $ifname
done

# Configure OVS to connect to the Ryu controller
ovs-vsctl set-fail-mode br0 secure
ovs-vsctl set-controller br0 tcp:127.0.0.1

exit 0
