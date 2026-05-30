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
├── run_command.yml				# Run custom command
├── secrets.yml
├── templates
│   └── isis
|       ├── p2p_t0.j2              # Template for loopback0 and p2p interfaces
│       └── base_t0.j2             # Template for IS-IS interfaces, level-capability and iso address
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

##### Capturing a VXLAN Tunnel payload (best to see just routing protocols):
sudo tcpdump -i vx-r2tor4_id240 -w payload_vxid240.pcap

##### Capturing the entire vxlan header for the physical link Wi-Fi interfaces (wlo1 on Debian or wlp4s0 on Pop OS)
Run to find the vxlan dstport:
ip -d link show type vxlan
Run to capture all WiFi VxLAN traffic:
sudo tcpdump -i wlo1 udp port 14789 -w vxlans_underlay.pcap
sudo tcpdump -i wlp4s0 udp port 14789 -w vxlans_underlay.pcap

NOTE:
- This will capture all local laptop vxlan interfaces traffic, (assuming the vx- interfaces use the same dstport). 
Could be difficult to distinguish source/destination.

##### Capturing inter-nodes payload (best to see clab inter-nodes routing protocols)
Run to find the network namespace (usally matches the container name):
ip netns list
Run to capture inter-nodes traffic:
sudo ip netns exec clab-bgp-multi-homed-R2 tcpdump -nni eth2 -w r2_r3_eth2.pcap

Or from remote laptop using docker context
docker context use <your_popos_context>
docker exec -i clab-bgp-multi-homed-R6 tcpdump -U -nni eth1 -w - > r6_r5_eth1.pcap

##### Capturing from inside the node:
admin@R1> monitor traffic interface ge-0/0/0.0
admin@R1> monitor traffic interface ge-0/0/0.0 matching udp
admin@R1> monitor traffic interface ge-0/0/0.0 matching tcp
admin@R1> monitor traffic interface ge-0/0/0.0 matching "port 179"

##### ACIIFlow topology
[link](https://asciiflow.com/#/share/eJzdV7FuwjAQ%2FZXIM4XYTmibP%2BjSIUMnSyiRIoTU0ipEFQghVZk7dMjA0LEjI1%2FEl9QQgqhzvtgRraImQbGPu3dnx%2B%2FJXpJp9JSQgDxG8Sgev4yiLEsn8Yz0pGWRpPKfpSCvSTqbPE8FCVhPkLl8395w2VrsLddD2cqSeSY7gjiaa1e874o39PnQxTqOEFPVNE6u3IG8d0V%2BniU%2F2qkJCFrU194jHJZ%2Bn7bFQ8lyoIl1TICKpsLWrcHh6%2FdAqOv29z9v2HcH3DUBqUL8MqRTw%2BkcSMUMExCFReeVQKTZGjC5FrdFSPQzIUoQ3AcACr1moNA3ALpERXX%2BbrT8dfRxmxrMGkgIaqam%2BMoXqBodN%2BbQKZBKO5hnLTfcV%2BTm4f4ucJhnBHLw5d7%2Fndhj61KLzUo3WoYpCbU7ClBCdeQ%2BaQkrO417COQpNyPcJN1Z57TE%2BWG9GoqSnbq0DKutE2axThhUdX0ONCCKpVMg1RejzFqUKIdEiTJzUaL8D0XJ6kBgCt54KDADwjfVJRdp6YqTWqUJcI6Bx4hNNw5icyBQgcmKrL4BoJDpGA%3D%3D))
