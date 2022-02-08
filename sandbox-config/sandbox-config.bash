
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
	kubectl delete deployments --all
	sleep 10
	kubectl delete pods --all
	sudo kubeadm reset
	sudo rm -rf /etc/cni /etc/kubernetes /var/lib/dockershim /var/lib/etcd /var/lib/kubelet /var/run/kubernetes ~/.kube/*
	sudo iptables -F && sudo iptables -X
	sudo iptables -t nat -F && sudo iptables -t nat -X
	sudo iptables -t raw -F && sudo iptables -t raw -X
	sudo iptables -t mangle -F && sudo iptables -t mangle -X
	sudo systemctl restart docker
fi

if [[ $(ip link show | grep -E vxlan) ]]; then
	echo "Network interfaces are already configured: proceeding to install the Kubernetes Cluster:"
	domain_config=$(hostname -s)
	git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
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
			sudo ip link add vxlan1 type vxlan id 1969 dev $mainInterface dstport 4789
			sudo ip link set vxlan1 up
			sudo bridge fdb append to 00:00:00:00:00:00 dst $domain1 dev vxlan1
			sudo ip link add vxlan3 type vxlan id 1971 dev $mainInterface dstport 4789
			sudo ip link set vxlan3 up
			sudo bridge fdb append to 00:00:00:00:00:00 dst $domain2 dev vxlan3
			git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
			sudo $HOME/FISHY-Sandbox-development/$domain_config/config_interfaces.bash
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
				sudo ip link add vxlan1 type vxlan id 1969 dev $mainInterface dstport 4789
				sudo ip link set vxlan1 up
				sudo bridge fdb append to 00:00:00:00:00:00 dst $cont dev vxlan1
				sudo ip link add vxlan2 type vxlan id 1970 dev $mainInterface dstport 4789
				sudo ip link set vxlan2 up
				sudo bridge fdb append to 00:00:00:00:00:00 dst $domain2 dev vxlan2
				git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
				sudo $HOME/FISHY-Sandbox-development/$domain_config/config_interfaces.bash

	        	elif [[ "$domain_selector" == "domain-2" ]]; then
					echo Please, enter Control-services IP:
					read cont
					echo Please, enter Domain 1 IP:
					read domain1
					domain_config="fishy-domain-2"
					while_var=1
					sudo ip link add vxlan2 type vxlan id 1970 dev $mainInterface dstport 4789
					sudo ip link set vxlan2 up
					sudo bridge fdb append to 00:00:00:00:00:00 dst $domain1 dev vxlan2
					sudo ip link add vxlan3 type vxlan id 1971 dev $mainInterface dstport 4789
					sudo ip link set vxlan3 up
					sudo bridge fdb append to 00:00:00:00:00:00 dst $cont dev vxlan3
					git clone https://github.com/Networks-it-uc3m/FISHY-Sandbox-development.git &> /dev/null
					sudo $HOME/FISHY-Sandbox-development/$domain_config/config_interfaces.bash

			else
				echo "Invalid Domain: please select an appropiate domain name"
			fi
		fi
	done
	sudo hostnamectl set-hostname $domain_config
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

kubectl create -f $HOME/FISHY-Sandbox-development/$domain_config/network_definitions/hosts/mgmt_interfaces &> /dev/null
kubectl create -f $HOME/FISHY-Sandbox-development/$domain_config/network_definitions/pods/mgmt_interfaces &> /dev/null
kubectl create -f $HOME/FISHY-Sandbox-development/$domain_config/network_definitions/hosts/data_interfaces &> /dev/null
kubectl create -f $HOME/FISHY-Sandbox-development/$domain_config/network_definitions/pods/data_interfaces &> /dev/null
kubectl create -f $HOME/FISHY-Sandbox-development/$domain_config/network_definitions/vxlans &> /dev/null

sleep 5

kubectl create -f $HOME/FISHY-Sandbox-development/$domain_config/NED/

sudo rm -r $HOME/FISHY-Sandbox-development

sleep 20

if [[ "$domain_config" == "fishy-control-services" ]]; then
	git clone https://github.com/H2020-FISHY/IRO.git &> /dev/null
	kubectl apply -f $HOME/IRO/deployment/iro_kubernetes.yml
	sudo rm -r $HOME/IRO
fi


echo "Node $domain_config ready!"
