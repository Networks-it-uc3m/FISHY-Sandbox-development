ip link add vxlan2 type vxlan id 1970 dev ens3 dstport 4789
ip link set vxlan2 up
bridge fdb append to 00:00:00:00:00:00 dst 10.4.48.79 dev vxlan2
ip link add vxlan3 type vxlan id 1971 dev ens3 dstport 4789
ip link set vxlan3 up
bridge fdb append to 00:00:00:00:00:00 dst 10.4.48.195 dev vxlan3
