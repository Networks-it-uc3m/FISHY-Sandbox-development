<!---   Copyright 2021 Luis F. González <luisfgon@it.uc3m.es>, I. Vidal <ividal@it.uc3m.es>, F. Valera <fvalera@it.uc3m.es>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->

# FISHY-Sandbox

Repository with details and files regarding the sandbox of the **H2020 FISHY** project (Grant agreement ID: 952644)

# Sandbox Architecture

The picture below presents a first proposal for the design of the FISHY sandbox. The purpose of this sandbox is to provide a virtual environment capable of supporting the execution of FISHY components and other relevant functions, such as VNFs developed during the project lifetime.

The sandbox may be downlodaded and installed locally by interested partners, and will support development, testing  and integration activities of FISHY components into a common test platform.

![alt text](https://github.com/lewisfelix/FISHY-Sandbox/blob/main/Sandbox_v1.png?raw=true)

As it can be seen in the picture, the first version of the sandbox will be provided as a set of different domains. One of the domains will host the FISHY control services (e.g., the Trust & Incident manager, the Security and Certification Management, and the Intent-based Resilience Orchestrator & Dashboard). Two additional domains will provide the abstraction of an NFVI (i.e., the sandox includes a representation of two ICT infrastructures).

This way, the sandbox design is flexible to support different testing requirements, involving a single organization domain, or even several organization domains if needed.

To support inter-domain communications, the sandbox will include a functional Network Edge Device (NED) at every domain. NEDs will support all the management communications between fishy control services and other FISHY components, such as VNFs (management communications are shown in red color in the figure). They will also enable inter-domain data-plane communications between VNFs and/or FISHY components (data-plane communications are are shown in blue color). 

In the first version of the sandbox (IT-1), the NED will offer a set of pre-created management and data-plane interfaces, which will provide secure network connectivity to VNFs and other FISHY software components. The sandbox will also document the specific mechanisms that can be followed by interested partners to attach FISHY components and VNFs to NED interfaces.

IT-1 will provide a reference implementation of the sandbox using K8s: each domain will be provided as a k8s cluster that will support the deploynment of FISHY components and VNFs. And each k8s cluster will be packaged into a virtual machine (the sandox will be provided as a set of three interconnected virtual machines). Still, the sandbox design is flexible to accommodate different virtual infrastructure management solutions, e.g., OpenStack. A NED implementation will be also made available for OpenStack deployments.

**Click [here](https://github.com/Networks-it-uc3m/FISHY-Sandbox-development/tree/main/Guides) to access the installation guide!**
