#!/usr/bin/python

"""
This profile creates an Open vSwitch LAN with a single/central OVS
"switch" node and a configurable number of attached nodes.  The OVS
node also runs an instance of the RYU OpenFlow controller, which is
setup to control the OVS instance.

Instructions:

TODO.

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
    ovsscmd = "/local/repository/ovs-setup.sh"

# Top-level request object.
request = portal.context.makeRequestRSpec()

# Parameter definitions
portal.context.defineParameter(
    "NUMNODES",
    "Number of nodes in LAN",
    portal.ParameterType.INTEGER, 2,
    [1,2,3,4,5,6],
    "Number of nodes connected to central OVS switch node.  Cannot be more than 6 as this is the limit on the number of physical Ethernet ports available on any testbed node type."
)

# Bind and verify parameters
params = portal.context.bindParameters()

# Allocate OVS "switch" node
ovs = request.RawPC("ovs")
ovs.disk_mage = GLOBALS.ovsimg
ovs.addService(rspec.Execute(shell="bash", command="sudo %d" % GLOBALS.ovsscmd))

# Allocate the requested number of nodes and link them to the central
# swich node.
for i in range(params.NUMNODES):
    node = request.RawPC("node%d" % i)
    node.disk_image = GLOBALS.nodeimg
    nifc = node.addInterface()
    nifc.addAddress(rspec.IPv4Address("192.168.0.%d" % i, "255.255.255.0"))
    link = request.Link("%s-link" % node.name, members=[nifc, ovs])

# Emit!
portal.context.printRequestRSpec()
