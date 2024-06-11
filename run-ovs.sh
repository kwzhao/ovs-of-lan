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

# Set up queueing disciplines for the OVS bridge.
# DRR queueing.
tc qdisc add \
	dev br0 \
	root \
	handle 1: \
	drr
# Three classes, 1:1, 1:2, 1:3 with equal quanta.
tc class add \
	dev br0 \
	parent 1: \
	classid 1:1 \
	drr quantum 2000
tc class add \
	dev br0 \
	parent 1: \
	classid 1:2 \
	drr quantum 2000
tc class add \
	dev br0 \
	parent 1: \
	classid 1:3 \
	drr quantum 2000
# Set up filters.
# AF21 to class 1:1.
tc filter add \
	dev br0 \
	parent 1: \
	protocol ip \
	prio 1 \
	u32 \
	match ip dsfield 0x48 0xfc \
	flowid 1:1
# AF11 to class 1:2.
tc filter add \
	dev br0 \
	parent 1: \
	protocol ip \
	prio 1 \
	u32 \
	match ip dsfield 0x28 0xfc \
	flowid 1:2
# Everything else to class 1:3.
tc filter add \
	dev br0 \
	parent 1: \
	protocol all \
	prio 100 \
	u32 \
	match u32 0 0 \
	flowid 1:3

exit 0
