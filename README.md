# FISHY-Sandbox

Repository with details and files regarding the sandbox of the **H2020 FISHY** project (Grant agreement ID: 952644)


# Sandbox Architecture

![alt text](https://github.com/lewisfelix/FISHY-Sandbox/blob/main/Sandbox-v1.pdf?raw=true)

This picture presents a first proposal for the design of the FISHY sandbox. The purpose of this sandbox is to provide a virtual environment capable of supporting the execution of FISHY components and other relevant functions, such as VNFs developed during the project lifetime.

The sandbox may be downlodaded and installed locally by interested partners, and will support development, testing  and integration activities of FISHY components into a common test platform.

As it can be seen in the picture, the first version of the sandbox will be provided as a set of different domains. One of the domains will host the FISHY control services (e.g., the Trust & Incident manager, the Security and Certification Management, and the Intent-based Resilience Orchestrator & Dashboard). Two additional domains will provide the abstraction of an NFVI (i.e., the sandox includes a representation of two ICT infrastructures).

This way, the sandbox design is flexible to support different testing requirements, involving a single organization domain, or even several organization domains if needed.

To support inter-domain communications, the sandbox will include a functional Network Edge Device (NED) at every domain. NEDs will support all the management communications between fishy control services and other FISHY components, such as VNFs (management communications are shown in red color in the figure). They will also enable inter-domain data-plane communications between VNFs and other FISHY components (data-plane communications are are shown in blue color). 

In the first version of the sandbox (IT-1), the NED will offer a set of pre-created management and data-plane interfaces, which could be used to attach VNFs and other FISHY components. The sandbox will also document the specific mechanisms to attach the deployed FISHY components to NED interfaces.

IT-1 will provide a reference implementation of the sandbox using K8s: each domain will be provided as a k8s cluster that will support the deploynment of FISHY components and VNFs. And each k8s cluster will be packaged into a a VM (the sandox will be provided as a set of three interconnected virtual machines). Still, the sandbox design is flexible to accommodate different virtual infrastructure management solutions, e.g., OpenStack. A NED implementatio will be also made available for OpenStack deployments.
