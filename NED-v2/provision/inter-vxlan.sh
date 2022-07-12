#!/bin/sh

filename=$2
n=1
id=1991

while read line; do
# Get IP values from file
ip=$(echo $line| cut -d'"' -f 2)
#If empty, no tunnel. Otherwise, add the IP to remote
if [ -z "$ip" ];then
  ip link add vxlan-inf-$n type vxlan id $id dev $1 dstport 4789
else
  ip link add vxlan-inf-$n type vxlan id $id dev $1 dstport 4789 remote $ip
fi
n=$((n+1))
id=$((id+1))
done < $filename

