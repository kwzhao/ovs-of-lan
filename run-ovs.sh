#!/bin/bash

# Create a bridge for forwarding traffic between nodes.
ovs-vsctl add-br br0

# Add all experimental network link interfaces to the OVS bridge.
IFS=$'\n'
for lanstr in `cat /var/emulab/boot/ifmap`; do
    IFS=" " read ifname ipaddr mac <<< "$lanstr"
    ovs-vsctl add-port br0 $ifname
    ip addr flush dev $ifname
    ip addr add "${ipaddr}"/24 dev br0
done

ip link set br0 up

# Set a top-level HTB to make sure the switch is the bottleneck.
sudo tc qdisc add dev br0 root handle 1: htb default 10
sudo tc class add dev br0 parent 1: classid 1:1 htb rate 500mbit ceil 500mbit
sudo tc filter add dev br0 parent 1: protocol all prio 1 u32 match u32 0 0 flowid 1:1

# DRR is a child of HTB. Three classes, top two tagged with DSCP.
sudo tc qdisc add dev br0 parent 1:1 handle 10: drr
sudo tc class add dev br0 parent 10: classid 10:1 drr quantum 2000
sudo tc class add dev br0 parent 10: classid 10:2 drr quantum 2000
sudo tc class add dev br0 parent 10: classid 10:3 drr quantum 2000
sudo tc filter add dev br0 parent 10: protocol ip prio 1 u32 match ip dsfield 0x48 0xfc flowid 10:1
sudo tc filter add dev br0 parent 10: protocol ip prio 1 u32 match ip dsfield 0x28 0xfc flowid 10:2
sudo tc filter add dev br0 parent 10: protocol all prio 2 u32 match u32 0 0 flowid 10:3
