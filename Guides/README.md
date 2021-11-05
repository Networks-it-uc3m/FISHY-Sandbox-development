# FISHY-Sandbox Installation guide

Welcome to the installation guide for the FISHY-Sandbox. In this section of the repository, you will find the guide for the installation of the latest version of the Sandbox used in the H2020 FISHY project, as well as the respective download links.

## Download Fishy VM

Use the [following link](https://vm-images.netcom.it.uc3m.es/FISHY/images/fishy-VM-baseline-v1_2.qcow) to download the latest version of the Sandbox VM.

## Fishy-Sandbox Prerequisites

+ Three Virtual Machines (VM) using the “fishy-sandbox-baseline.qcow” image. Each VM must have at least 2CPUs and 2GBs of RAM for its execution.
+ All machines must be interconnected through a virtual network that provides Internet connectivity. Each VM must have one network interface connected to this virtual network
+ The deployment of each VM with a single network interface is recommended. If more interfaces are aggregated to the VM, the script will attach the NED to the interface used to reach the internet (i.e., the default route). Therefore, the VM must be able to reach the rest using this interface. 

<!--
## Kubernetes Cluster components

* Kubeadm: version 1.22
* Kubectl: version 1.22.2
* Docker: version 20.10.3
-->

## Fishy Sandbox Components

Component | Fishy-Control-Services | Domain-1 | Domain-2 | Comments 
:-------------: | :-------------: | :-------------: | :-------------: | :-------------
K8s cluster | X | X | X | Kubeadm: version 1.22; Kubectl: version 1.22.2; Docker: version 20.10.3 
NED (v1)  | X | X | X | Automatically deployed on each domain once the sandbox has been installed (see *installation process* below). This versión supports two VLANs: one for management communication and a second one for inter-domain data-plane communications. 


## Installation process

1. Login into the machine, using the following credentials:
  * _User:_ admin-fishy 
  * _Password:_ admin-fishy
  
2. Start the installation process using the following command. If prompted, introduce the password of the VM:
```bash
./sandbox-config.bash
```
3. If the VM to be configured is the host of the fishy control services, introduce in the command line the “y” character:
```bash
Is this machine fishy-control-services?[y/n]
y
```
Otherwise, type “n” and write in the command line the corresponding domain that the VM will represent (“domain-1” or “domain-2”):
```bash
Is this machine fishy-control-services?[y/n]
n
Is this domain-1 or domain-2?[domain-1/domain-2]
domain-1
```
4. Introduce the respective IP addresses of the other VMs when prompted by the console:
```bash
Please, enter Domain 1 IP:
10.0.0.1
Please, enter Domain 2 IP:
10.0.0.2
```
5. Wait for the process to be completed. If asked by the command line through the following message, write the “y” character and press Enter:
```bash
cp: overwrite '/home/ubuntu/.kube/config'? y
```
6. Once the following message, the VM is ready to be used.
```bash
Node [fishy-control-services/domain-1/domain-2] ready!
```
You can also check that it is properly installed by introducing the command _kubectl get pods_ and checking that the _“ned-[DOMAIN-NAME]”_ is up and in the “Running” status


## Hello World
Once the machines have been installed and configured using the sandbox-config.bash script, the Hello-world example allows the users to test how the services deployed in the sandbox can be interconnected between each other using through the NED deployed in the domains. 

This example mimics the deployment of a simple use case in the fishy platform, where an infotainment server in Domain-1 will communicate with a smart car located in Domain-2. All components have a management interface that the fishy-control-services domain will use to communicate with them (for management purposes). 

In this case, the example will deploy the corresponding service in each domain, explaining the steps required to deploy (and configure) them for establishing communication between them through the corresponding network interfaces. The steps to be performed in each domain are the following:

### Fishy-control-module
1.	Execute the command ```kubectl get pods``` and check that the NED is in the “Running” status.
2.	Check the available interfaces to attach pods using the command ```ip a s```.
3.	Go to the directory _hello-world/fishy-control-services/_ .
4.	Open the file using ```nano fishy-module.yaml```.
5.	Once in the file, edit the _annotations_ and add the interfaces you want to use. In the case of the Control Module, only the management ones (since no data plane interfaces will be available in this domain). The format is _interface_name*@name_inside_pod**_. Example:

    ![ann1](https://user-images.githubusercontent.com/36893060/140507904-7bea4e3a-9a26-4815-8598-29e0254269f7.jpg)
    
    *This should be one of the interfaces names listed when executing the command ```ip a s``` (step 2).
    
    **This name can be chosen at will.
    
    Here is important to add a few lines on the containers specs that allows to run the networking functions. These are:
    
    ![ann2](https://user-images.githubusercontent.com/36893060/140508549-d10333a9-9f38-419d-8b94-23e20a3a8002.jpg)



6.	Execute ```kubectl create -f fishy-module.yaml```.
7.	Wait a couple of seconds and check that the _fishy-module_ is running by executing ```kubectl get pods```.
8.	Go inside the module executing ```kubectl exec -it fishy-module -- /bin/sh``` and check that the interface introduced in step 5 is in the UP state (e.g., using the command ```ip a s```).
9.	Add an IP address to this interface executing ```ip addr add [ip-address/mask] dev [interface-name]```.

### Fishy-domain-1 & Fishy-domain-2
1.	Execute the command ```kubectl get pods``` and check that the NED is in the “Running” status.
2.	Check the interfaces available with ```ip a s```.
3.	Go to the directory _hello-world/fishy-domain-1/_ for Fishy-domain-1 or _hello-world/fishy-domain-2/ for Fishy-domain-2_. 
4.	Open the file using: 

    a.	(Domain 1) ```nano infotainment-server.yaml```.

    b.	(Domain 2) ```nano smart-car.yaml```.
5.	Once in the file, edit the annotations and add the interfaces you want to use. In this case, the remaining domains support the use of management and data interfaces.  To edit the file to aggregate more interfaces, introduce the corresponding annotation separated by commas. The format is the same as before: _interface_name@name_inside_pod_.

6. .

    a.  (Domain 1) Execute ```kubectl create -f infotainment-server.yaml```.
    
    b.  (Domain 2) Execute ```kubectl create -f smart-car.yaml```.
7.	Wait for a second and check that the _infotainment server/smart car_ pods are running in the corresponding domain by executing _kubectl get pods_.
8. .

    a.  (Domain 1) Go inside the module executing ```kubectl exec -it infotainment-server -- /bin/sh``` and check that the interfaces introduced in step 5 are UP (management & data) with the command ```ip a s```.
    
    b.  (Domain 2) Go inside the module executing ```kubectl exec -it smart-car -- /bin/sh``` and check that the interfaces introduced in step 5 are UP (management & data) with the command ```ip a s```.
9.	Add an IP address to both interfaces executing ```ip addr add [ip-address/mask] dev [interface-name]```. Check executing ```ip a s```.

To check connectivity between the different domains and the control service, do a ping to the corresponding IPs added to the modules (i.e., execute the command ```ping [IP-to-test]``` in the pods).

Take into account that the interfaces can only communicate with their own peers. In other words, management interfaces can only communicate with management interfaces, and data interfaces can only communicate with data interfaces.
