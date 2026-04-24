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
- Underlay: IS-IS with jumbo frames
- Overlay: VXLAN / EVPN (the service layer)
- VRFs (Inside/Outside) for traffic isolation
- Core-Router is a VTEP for the Subnet A



NOTE: This repo can be used as a playground for Terraform. 




Now please generate the play to implement MAC-VRF over my P2P underlay this should include the edge(s) and the core router. I will tackle it by steps: 

1) IS-IS Level 1 between the 3 routers. Example NET_ADDRESS for Edge-A and Edge-B:

49.0001.0000.0000.00ea.00
49.0001.0000.0000.00eb.00



