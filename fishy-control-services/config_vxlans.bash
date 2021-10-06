ip link add vxlan1 type vxlan id 1969 dev ens3 dstport 4789
ip link set vxlan1 up
bridge fdb append to 00:00:00:00:00:00 dst 10.4.48.79 dev vxlan1
ip link add vxlan3 type vxlan id 1971 dev ens3 dstport 4789
ip link set vxlan3 up
bridge fdb append to 00:00:00:00:00:00 dst 10.4.48.68 dev vxlan3
