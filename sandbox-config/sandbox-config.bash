#!/bin/bash

while_var=0
domain_config=""

ifaces=($(ip link show | grep -E "^.:|^..:" | awk '{ print $2 } ' | cut -d ':' -f1 | grep -Ev 'lo'))

mode=$1

if [ "$mode" != "install" ] && [ "$mode" != "update" ]; then
	echo "Please, select either the install or update options when executing the script"
	exit 1
fi

if [[ "$mode" == "update" ]]; then
        kubectl delete daemonsets --all
	kubectl delete deployments --all
	sleep 30
	#kubectl delete pods --all
        #sleep 15
	sudo kubeadm reset
	sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*
        sudo rm -r /mnt/data
	sudo iptables -F && sudo iptables -X
	sudo iptables -t nat -F && sudo iptables -t nat -X
	sudo iptables -t raw -F && sudo iptables -t raw -X
	sudo iptables -t mangle -F && sudo iptables -t mangle -X
	sudo systemctl restart docker
fi

git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
git clone https://github.com/Networks-it-uc3m/L2S-M.git &> /dev/null

if [[ $(ip link show | grep -E vxlan) ]]; then
	echo "Network interfaces are already configured: proceeding to install the Kubernetes Cluster:"
	domain_config=$(hostname -s)
        if [[ "$domain_config" != "fishy-control-services" ]]; then
                echo "Please introduce fishy-control-services IP address:"
                read cont
        fi
	#git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
else
	for (( c=0; c<${#ifaces[@]}; c++ ));
	do
		if [[ $(/sbin/ip route | awk '/default/ { print $5 }') == ${ifaces[c]} ]]; then
			mainInterface=${ifaces[c]}
			echo "Building the sandbox using interface $mainInterface"
			break
		fi
		if [ $c -eq $((${#ifaces[@]} - 1)) ]; then
			mainInterface=${ifaces[0]}
			echo "WARNING! No default interface configured: Building the sandbox using interface $mainInterface"
		fi
	done

	if [[ $(ip link show | grep -E $mainInterface | awk '{ print $9 }') == "DOWN" ]]; then
		echo "Interface $mainInterface is in DOWN state: the sandbox installation cannot procceed"
		exit 1
	fi


	while [ $while_var -eq 0 ]
	do
	echo "Is this machine fishy-control-services host?[y/n]"
	read control_bool

		if [[ "$control_bool" == "y" ]]; then
			echo Please, enter Domain 1 IP:
			read domain1
			echo Please, enter Domain 2 IP:
			read domain2
			domain_config="fishy-control-services"
			while_var=1
			sudo ip link add vxlan-inf-1 type vxlan id 1969 dev $mainInterface dstport 4789
			sudo ip link set vxlan-inf-1 up
			sudo bridge fdb append to 00:00:00:00:00:00 dst $domain1 dev vxlan-inf-1
			sudo ip link add vxlan-inf-2 type vxlan id 1971 dev $mainInterface dstport 4789
			sudo ip link set vxlan-inf-2 up
			sudo bridge fdb append to 00:00:00:00:00:00 dst $domain2 dev vxlan-inf-2
			#git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
			#sudo $HOME/FISHY-Sandbox-development/$domain_config/config_interfaces.bash
			echo -e "\nvm.max_map_count=524288\n" | sudo tee -a /etc/sysctl.conf && sudo sysctl -w vm.max_map_count=524288

		elif [[ "$control_bool" == "n" ]]; then
			echo "Is this domain-1 or domain-2?[domain-1/domain-2]"
			read domain_selector
			if [[ "$domain_selector" == "domain-1" ]]; then
				echo Please, enter Control-services IP:
				read cont
				echo Please, enter Domain 2 IP:
				read domain2
				domain_config="fishy-domain-1"
				while_var=1
				sudo ip link add vxlan-inf-1 type vxlan id 1969 dev $mainInterface dstport 4789
				sudo ip link set vxlan-inf-1 up
				sudo bridge fdb append to 00:00:00:00:00:00 dst $cont dev vxlan-inf-1
				sudo ip link add vxlan-inf-2 type vxlan id 1970 dev $mainInterface dstport 4789
				sudo ip link set vxlan-inf-2 up
				sudo bridge fdb append to 00:00:00:00:00:00 dst $domain2 dev vxlan-inf-2
				#git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
				#sudo $HOME/FISHY-Sandbox-development/$domain_config/config_interfaces.bash

	        	elif [[ "$domain_selector" == "domain-2" ]]; then
					echo Please, enter Control-services IP:
					read cont
					echo Please, enter Domain 1 IP:
					read domain1
					domain_config="fishy-domain-2"
					while_var=1
					sudo ip link add vxlan-inf-1 type vxlan id 1970 dev $mainInterface dstport 4789
					sudo ip link set vxlan-inf-1 up
					sudo bridge fdb append to 00:00:00:00:00:00 dst $domain1 dev vxlan-inf-1
					sudo ip link add vxlan-inf-2 type vxlan id 1971 dev $mainInterface dstport 4789
					sudo ip link set vxlan-inf-2 up
					sudo bridge fdb append to 00:00:00:00:00:00 dst $cont dev vxlan-inf-2
					#git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
					#sudo $HOME/FISHY-Sandbox-development/$domain_config/config_interfaces.bash

			else
				echo "Invalid Domain: please select an appropiate domain name"
			fi
		fi
	done
	sudo hostnamectl set-hostname $domain_config &> /dev/null
        sudo $HOME/L2S-M/K8s/provision/veth.bash

        sudo ip link add vxlan1 type vxlan id 1972 dev $mainInterface dstport 4789
        sudo ip link add vxlan2 type vxlan id 1973 dev $mainInterface dstport 4789
        sudo ip link add vxlan3 type vxlan id 1974 dev $mainInterface dstport 4789
        sudo ip link add vxlan4 type vxlan id 1975 dev $mainInterface dstport 4789
        sudo ip link add vxlan5 type vxlan id 1976 dev $mainInterface dstport 4789
        sudo ip link add vxlan6 type vxlan id 1977 dev $mainInterface dstport 4789
        sudo ip link add vxlan7 type vxlan id 1978 dev $mainInterface dstport 4789
        sudo ip link add vxlan8 type vxlan id 1979 dev $mainInterface dstport 4789
        sudo ip link add vxlan9 type vxlan id 1980 dev $mainInterface dstport 4789
        sudo ip link add vxlan10 type vxlan id 1981 dev $mainInterface dstport 4789
fi

sudo kubeadm init --config $HOME/FISHY-Sandbox-development/clusterConfig.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

sleep 20

git clone https://github.com/k8snetworkplumbingwg/multus-cni.git &> /dev/null
kubectl apply -f ./multus-cni/deployments/multus-daemonset.yml
sudo rm -r multus-cni

sleep 20

echo "Installing L2S-M in your K8s Cluster"

kubectl create -f $HOME/L2S-M/K8s/interfaces_definitions/ &> /dev/null
kubectl create -f $HOME/L2S-M/operator/deploy/mysql/ &> /dev/null
kubectl create -f $HOME/L2S-M/operator/deploy/config/ &> /dev/null
kubectl label nodes $domain_config dedicated=master
kubectl create -f $HOME/L2S-M/operator/deploy/deployOperator.yaml &> /dev/null

sleep 60

kubectl create -f $HOME/L2S-M/operator/daemonset/l2-ps-amd64.yaml

#sudo rm -r $HOME/FISHY-Sandbox-development
#sudo rm -r $HOME/L2S-M-main

echo "Installing local SDN in your Cluster"

sleep 20

kubectl create -f $HOME/FISHY-Sandbox-development/cluster-sdn

sleep 10

RYUIP=$(kubectl get service/sdn-controller -o jsonpath="{.spec.clusterIP}")
POD=$(kubectl get pod -l l2sm-component=l2-ps -o jsonpath="{.items[0].metadata.name}")
kubectl exec $POD -- ovs-vsctl set-fail-mode brtun secure
kubectl exec $POD -- ovs-vsctl set-controller brtun tcp:$RYUIP:6633

echo "Installing the NED in your Cluster"

kubectl create -f $HOME/FISHY-Sandbox-development/NED-v2/ned-networks
kubectl create -f $HOME/FISHY-Sandbox-development/NED-v2/ned.yaml

sleep 10

if [[ "$domain_config" == "fishy-control-services" ]]; then

        IP=$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }')
        PODNED=$(kubectl get pod -l sia=ned -o jsonpath="{.items[0].metadata.name}")
        kubectl exec $PODNED -- ovs-vsctl set-fail-mode brtun secure
        kubectl exec $PODNED -- ovs-vsctl set-controller brtun tcp:$IP:30050

        kubectl create -f $HOME/FISHY-Sandbox-development/NED-v2/sdn-ned
#	git clone https://github.com/H2020-FISHY/IRO.git &> /dev/null
#	kubectl apply -f $HOME/IRO/deployment/iro_kubernetes.yml
#	sudo rm -r $HOME/IRO
else
        PODNED=$(kubectl get pod -l sia=ned -o jsonpath="{.items[0].metadata.name}")
        kubectl exec $PODNED -- ovs-vsctl set-fail-mode brtun secure
        kubectl exec $PODNED -- ovs-vsctl set-controller brtun tcp:$cont:30050
fi

sudo rm -r $HOME/L2S-M
sudo rm -r $HOME/FISHY-Sandbox-development

echo "Node $domain_config ready!"
