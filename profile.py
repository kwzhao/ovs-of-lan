#!/usr/bin/python

"""This profile creates an Open vSwitch based LAN with a single/central
OVS "switch" node and a configurable number of attached
nodes.  The OVS node also runs an instance of the RYU OpenFlow
controller, which is setup to control the OVS instance.

Instructions:

( Make sure the startup script on the `ovs` node is in state
`Finished` before begining to use the experiment. )

The edge nodes in this profile run a stock UBUNTU18-64-STD image, and
have a single link to the `ovs` switch node.  Each node has an address
on the `192.168.0.0/24` subnet (explicitly set inside the profile).

The Ryu controller starts up and listens on the loopback (localhost)
interface on the `ovs` node.  BE SURE you specify `--ofp-listen-host
127.0.0.1` if you restart it!  Otherwise Ryu will listen on the
"control network" and be open to the Internet and probable
exploitation.  The Ryu switch runs a simple L2 switching app included
in the Ryu package.

Open vSwitch also runs on the `ovs` switch, where a single bridge with
all node links is created by the startup scripts in this profile.  OVS
is pointed at the locally-running Ryu instance.

More information on Ryu and Open vSwitch can be found via the
following links:

https://ryu.readthedocs.io/en/latest/
http://docs.openvswitch.org/en/latest/

"""

# Library imports
import geni.portal as portal
import geni.rspec.pg as rspec
import geni.rspec.emulab.pnext as pn
import geni.rspec.emulab.spectrum as spectrum
import geni.rspec.igext as ig


# Global Variables
class GLOBALS:
    nodeimg = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD"
    ovsimg = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD"
    ovsscmd = "/local/repository/setup.sh"


# Top-level request object.
request = portal.context.makeRequestRSpec()

# Parameter definitions
portal.context.defineParameter(
    "NUMNODES",
    "Number of nodes in LAN",
    portal.ParameterType.INTEGER,
    2,
    [1, 2, 3, 4, 5, 6],
    "Number of nodes connected to central OVS switch node.  Cannot be more than 6 as this is the limit on the number of physical Ethernet ports available on any testbed node type.",
)

portal.context.defineParameter(
    "NODETYPE",
    "Node type",
    portal.ParameterType.STRING,
    "",
    ["", "d430", "d710", "pc3000"],
    "Type of node to use in this experiment.  Default is *unbound*, meaning any type with enough available nodes.",
)

# Bind and verify parameters
params = portal.context.bindParameters()

# Allocate OVS "switch" node
ovs = request.RawPC("ovs")
ovs.disk_image = GLOBALS.ovsimg
ovs.hardware_type = params.NODETYPE
ovs.addService(rspec.Execute(shell="bash", command="sudo %s" % GLOBALS.ovsscmd))

# Assign an IP address to the OVS switch
ovs_iface = ovs.addInterface()
ovs_iface.addAddress(rspec.IPv4Address("192.168.0.1", "255.255.255.0"))

# Allocate the requested number of nodes and link them to the central
# swich node.
for i in range(1, params.NUMNODES + 1):
    node = request.RawPC("node%d" % i)
    node.disk_image = GLOBALS.nodeimg
    node.hardware_type = params.NODETYPE
    nifc = node.addInterface()
    nifc.addAddress(rspec.IPv4Address("192.168.0.%d" % (i + 1), "255.255.255.0"))
    link = request.Link("%s-link" % node.name, members=[nifc, ovs_iface])

# Emit!
portal.context.printRequestRSpec()
