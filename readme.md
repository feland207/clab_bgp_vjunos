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

