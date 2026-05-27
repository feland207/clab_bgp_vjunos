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

#### Directory structure
.
├── ansible.cfg
├── inventory.ini
├── run_command.yml				# Run custom command play
├── secrets.yml
├── templates
│   └── isis
|       ├── p2p_t0.j2              # Jinja2 template for loopback0 and p2p interfaces
│       └── base_t0.j2             # Jinja2 template for IS-IS interfaces, level-capability and iso address
├── group_vars/
│   └── all.yml                    # Global variables (e.g., IS-IS ISO NET Address, IS-IS area)
├── node_vars/                     # Static YAML files containing per-node data
|   ├── R1.yml
|   ├── R2.yml
|   ├── R3.yml
|   ├── R4.yml
|   ├── R5.yml
|   └── R6.yml
└── underlay
    ├── setup_p2p.yml                # Play for loopback0 and p2p interfaces
    └── setup_isis.yml               # Play for IS-IS interfaces, level-capability and iso address

#### How to capture pcaps

##### Capturing the VXLAN Tunnels
sudo tcpdump -i vx-r2tor4_id240 -w payload_isis.pcap

##### Capturing the encapsulated traffic on the physical link Wi-Fi interfaces (wlo1 on Debian or wlp4s0 on Pop OS)
sudo tcpdump -i wlo1 port 4789 -w vxlan_underlay.pcap
sudo tcpdump -i wlp4s0 port 4789 -w vxlan_underlay.pcap

NOTE: 
- If Wireshark just shows it as generic UDP traffic, right-click any of the packets -> Decode As -> select VXLAN from the Current dropdown.
