Physical Topology
=================

      [ ISP-A ]           [ ISP-B ]
      (AS 200)            (AS 300)
         |                   |
         | (eBGP Peer 1)     | (eBGP Peer 2)
         |                   |
    +---------+         +---------+
    | Edge-A  | ------- | Edge-B  |  <-- iBGP Peering (AS 100)
    +---------+         +---------+
         \                 /
          \               /
           \             /
            \           /
           +-------------+
           | Core-Router |  (AS 100)
           +-------------+
                  |
           [ LAN Subnet A ]
            10.10.10.0/24

Design:
- Using loopback interfaces (lo0) in all vJunos
- Underlay: IS-IS with jumbo frames
- Overlay: VXLAN / EVPN (the service layer)
- VRFs (Inside/Outside) for traffic isolation
- Core-Router is a VTEP for the Subnet A
- Add fake subnets and traffic generator for BGP route advertisements

To-Do List:
- Implement a simple MAC-VRF over our P2P underlay to see the separation of transport (IS-IS) and service (EVPN/VXLAN).


NOTE: This repo can be used as a playground for Terraform / Ansible. Find the clab topology in gdrive.
