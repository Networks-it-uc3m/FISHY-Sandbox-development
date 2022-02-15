# FISHY-Sandbox FAQ

Welcome to the FAQ section of the FISHY-Sandbox. In this section of the repository, we will cover the most important questions related to the installation and operation of the FISHY-Sandbox used in the H2020 FISHY project

## FAQ

__Q: My VM has been shutdown, or I had to reboot my VM where I was running a Domain. What steps should I perform to re-create the Domain in my Sandbox?__ 

A: After performing a reboot in the VM where the Domain has been installed, it is neccessary to run the update script in order to re-create the Kubernetes cluster  and build the neccessary network interfaces. Otherwise, the Domain will not work properly. Run the following commands after you have rebooted your VM and introduce the information asked by the command prompt. See the FISHY-Sandbox Installation section in the [FISHY-Sandbox Installation Guide](https://github.com/Networks-it-uc3m/FISHY-Sandbox-development/blob/main/Guides/README.md) for further information. 

```bash
./sandbox-config.bash update
y
```
#### IMPORTANT: ALL YOUR CHANGES IN THE DOMAIN (K8S CLUSTER) WILL BE LOST AFTER THE UPDATE. MAKE SURE TO SAVE A COPY OF YOUR DEPLOYMENTS BEFORE THE UPDATE PROCCESS IF YOU WANT TO KEEP YOUR MODIFICATIONS.
