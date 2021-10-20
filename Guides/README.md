# FISHY-Sandbox Installation guide

Welcome to the installation guide for the FISHY-Sandbox. In this section of the repository, you will find the guide for the installation of the latest version of the Sandbox used in the H2020 FISHY project, as well as the respective download links.

## Download Fishy VM

Use the [following link](http://www.it.uc3m.es/fvalera/fishy-sandbox-baseline-v0.qcow) to download the latest version of the Sandbox VM.

## Fishy-Sandbox Prerequisites

+ Three Virtual Machines (VM) using the “fishy-sandbox-baseline.qcow” image. Each VM must have at least 2CPUs and 2GBs of RAM for its execution.
+ All machines must be interconnected through a virtual network that provides Internet connectivity. Each VM must have one network interface connected to this virtual network
+ The deployment of each VM with a single network interface is recommended. If more interfaces are aggregated to the VM, the script will attach the NED to the interface used to reach the internet (i.e., the default route). Therefore, the VM must be able to reach the rest using this interface. 
