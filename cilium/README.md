Update k8sApiHost with the address of your loda balancer which can be found in your kube config

This setup replaces kube proxy, wireguard is enabled, pod cidr is 10.10.0.0/8.   Bandwidth manager is enabled. 

Install this when all nodes have joined the cluster.  The nodes will be in a NotReady state till it's installed. 

Hubble and Hubble relay not enabled. 
