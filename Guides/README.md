# FISHY-Sandbox Wiki

Welcome to the Wiki for the FISHY-Sandbox. In this section of the repository, you will find the main guides for the download, installation, operation and troubleshooting of the FISHY-Sandbox used in the H2020 FISHY project. This Section of the Wiki includes the description of the Sandbox, its main components and the respective download links for their components. 

## Table of Contents
[Download FISHY-Sandbox VM](#down)

[FISHY-Sandbox Demo Video](#video)

[FISHY-Sandbox Prerequisites](#prereq)

[FISHY-Sandbox Components](#components)

[How to install & Update the FISHY-Sandbox?](#install)


<a name ="down"/>

## Download FISHY-Sandbox VM

Use the [following link](https://vm-images.netcom.it.uc3m.es/FISHY/images/fishy-VM-baseline-v1_2.qcow) to download the latest version of the Sandbox VM.

<a name ="video"/>

## FISHY-Sandbox Demo video

To see a full demo detailing what is the FISHY-Sandbox, its main components and how to use it, check the [following link](https://vm-images.netcom.it.uc3m.es/FISHY/videos/FISHY-Sandbox-installation.mp4).

<a name ="prereq"/>

## FISHY-Sandbox Prerequisites

+ Three Virtual Machines (VM) using the “fishy-sandbox-baseline.qcow” image. Each VM must have at least 2CPUs and 2GBs of RAM for its execution.
+ All machines must be interconnected through a virtual network that provides Internet connectivity. Each VM must have one network interface connected to this virtual network
+ The deployment of each VM with a single network interface is recommended. If more interfaces are aggregated to the VM, the script will attach the NED to the interface used to reach the internet (i.e., the default route). Therefore, the VM must be able to reach the rest using this interface. 

<!--
## Kubernetes Cluster components

* Kubeadm: version 1.22
* Kubectl: version 1.22.2
* Docker: version 20.10.3
-->

<a name ="components"/>

## FISHY-Sandbox Components

Component | Fishy-Control-Services | Domain-1 | Domain-2 | IP Address(es) | Comments 
:-------------: | :-------------: | :-------------: | :-------------: | :-------------: |:-------------
K8s cluster | X | X | X |  | Kubeadm: version 1.22; Kubectl: version 1.22.2; Docker: version 20.10.3 
NED (v1)  | X | X | X | 192.168.5.251 (NED in FCS Domain); 192.168.5.252 (NED in Domain 1); 192.168.5.253 (NED in Domain 2) | Automatically deployed on each domain once the sandbox has been installed (see *installation process* below). This version supports two VLANs: one for management communication and a second one for inter-domain data-plane communications. 
IRO (v1)  | X |  |  | 192.168.5.1 | Automatically deployed on the Fishy-Control-Services domain once the sandbox has been installed. The current version supports one VLAN for management communication. Additional interfaces (e.g data) might follow in the future if needed.


<a name ="install"/>

## How to install & update the FISHY-Sandbox?

If you are interested in knowing how to install the Sandbox, or you want to update your current FISHY-Sandbox Domain, you can check the [FISHY-Sandbox Installation guide](https://github.com/Networks-it-uc3m/FISHY-Sandbox-development/tree/main/Guides/installation) in this repository. 
