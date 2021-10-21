# FISHY-Sandbox Installation guide

Welcome to the installation guide for the FISHY-Sandbox. In this section of the repository, you will find the guide for the installation of the latest version of the Sandbox used in the H2020 FISHY project, as well as the respective download links.

## Download Fishy VM

Use the [following link](http://www.it.uc3m.es/fvalera/fishy-sandbox-baseline-v0.qcow) to download the latest version of the Sandbox VM.

## Fishy-Sandbox Prerequisites

+ Three Virtual Machines (VM) using the “fishy-sandbox-baseline.qcow” image. Each VM must have at least 2CPUs and 2GBs of RAM for its execution.
+ All machines must be interconnected through a virtual network that provides Internet connectivity. Each VM must have one network interface connected to this virtual network
+ The deployment of each VM with a single network interface is recommended. If more interfaces are aggregated to the VM, the script will attach the NED to the interface used to reach the internet (i.e., the default route). Therefore, the VM must be able to reach the rest using this interface. 

## Kubernetes Cluster components

* Kubeadm: version 1.22
* Kubectl: version 1.22.2
* Docker: 20.10.3

## Fishy Sandbox Components

Component | Fishy-Control-Services | Domain-1 | Domain-2 | Comments
:-------------: | :-------------: | :-------------: | :-------------: | :-------------:
NED (v1)  | X | X | X | Automatically deployed once the sandbox VM has been installed


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
