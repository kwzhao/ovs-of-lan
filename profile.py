#!/usr/bin/python

"""This profile creates an Open vSwitch based LAN with a single/central
OVS "switch" node and a configurable number of attached
nodes.

Instructions:

( Make sure the startup script on the `ovs` node is in state
`Finished` before beginning to use the experiment. )

The edge nodes in this profile run a stock UBUNTU22-64-STD image, and
have a single link to the `ovs` switch node.

Open vSwitch also runs on the `ovs` switch, where a single bridge with
all node links is created by the startup scripts in this profile.

More information Open vSwitch can be found at: http://docs.openvswitch.org/en/latest/

"""

# Library imports
import geni.portal as portal
import geni.rspec.pg as rspec


# Global Variables
class GLOBALS:
    nodeimg = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD"
    ovsimg = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD"
    ovsscmd = "/local/repository/setup-ovs.sh"
    nodescmd = "/local/repository/setup-node.sh"


# Top-level request object.
request = portal.context.makeRequestRSpec()

# Parameter definitions
portal.context.defineParameter(
    "NUMNODES",
    "Number of nodes in LAN",
    portal.ParameterType.INTEGER,
    2,
    [1, 2, 3, 4, 5, 6],
    "Number of nodes connected to central OVS switch node. Cannot be more than 6 as this is the limit on the number of physical Ethernet ports available on any testbed node type.",
)

portal.context.defineParameter(
    "NODETYPE",
    "Node type",
    portal.ParameterType.STRING,
    "",
    ["", "d430", "d710", "pc3000"],
    "Type of node to use in this experiment. Default is *unbound*, meaning any type with enough available nodes.",
)

# Bind and verify parameters
params = portal.context.bindParameters()

# Allocate OVS "switch" node
ovs = request.RawPC("ovs")
ovs.disk_image = GLOBALS.ovsimg
ovs.hardware_type = params.NODETYPE
ovs.addService(rspec.Execute(shell="bash", command=GLOBALS.ovsscmd))

# Allocate the requested number of nodes and link them to the central switch node
for i in range(1, params.NUMNODES + 1):
    node = request.RawPC("node%d" % i)
    node.disk_image = GLOBALS.nodeimg
    node.hardware_type = params.NODETYPE
    node.addService(rspec.Execute(shell="bash", command=GLOBALS.nodescmd))
    link = request.Link("%s-link" % node.name, members=[node, ovs])

# Emit the RSpec
portal.context.printRequestRSpec()
