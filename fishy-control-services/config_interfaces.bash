ip link add dev vpodtm type veth peer name vhosttm
ip link set mtu 1450 dev vpodtm
ip link set mtu 1450 dev vhosttm
ip link add dev vpodscm type veth peer name vhostscm
ip link set mtu 1450 dev vpodscm
ip link set mtu 1450 dev vhostscm
ip link add dev vpodiro type veth peer name vhostiro
ip link set mtu 1450 dev vpodiro
ip link set mtu 1450 dev vhostiro
