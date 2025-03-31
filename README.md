# kubernetes-icarus-project

to do. tidy this abomination up

Dns used is 2 hosted zones. 
The cluster is on the subdomain hosted zone. 

ami is Ubuntu but use whatever you want as long as it's supported by kops. Flatcar is good but aws change per hour on its usage if used from the catalogue.  

OIDC provider requires an additional bucket. Don't use the same as the state one. if using oidc add podIdentitwebhook enabled: true. it requires cert manager. 

Terraform for the kops basics are in this repo. 

Check status of terraform  network directory in this repo if you require networking. 
Otherwise create

 3 public and private subnets
 
2 3 Nat Gateways and EIPS on the public networks.

3  Change routing of private networks by removing them from the main routing table and create 3 news ones and add a route pointing to your nat gateway.
```
0.0.0.0/0 nat-gw11234555
```


Add two variables to your .bashrc  

```
export NAME=your-cluster-name
export BUCKET=s3://your-state-bucket
. .bashrc
```


update  kops.yaml file with your own details 

```
kops create -f kops.yaml --name $NAME --state $BUCKET
```

add sshkey using kops command 

```
kops create sshpublickey --name your-cluster-nane --state s3://your-s3-state-bucket  -i ~/.ssh/id_rsa.pub 
```

The kops update will create all the necessary infra and the cluster.  If not using a pre existing internet gateway.
```
kops update cluster--name $NAME --state $BUCKET --yes
```

if using pre existing Internet gateway.
```
kops update cluster--name $NAME --state $BUCKET --lifecycle-overrides InternetGateway=ExistsAndWarnIfChanges--yes
```

Export the kube config. This will eventually expire though.
```
kops export kubeconfig --name $NAME --state $BUCKET --admin
```
Validate the cluster
```
kops validate cluster --name $NAME --state $BUCKET  --wait 5m
```

Update the cilium values file and add the api address under k8sServiceHost or use --set k8sapihost and install cilium. The value can be found in kube config TLS server,  The nodes will be in a NotReady state till you do this.  Once installed the nodes will be in a ready state.
```
helm install cilium cilium/cilium -f values.yaml -n kube-system
```
OR
```
helm install cilium cilium/cilium -f values.yaml -n kube-system --set k8sServiceHost: = "Your TLS server ADDRESS"
```
Verify the installation
```
cilium status
```

Once Cilium is install edit the cluster config and add

```
podIdentityWebhook:
  enabled: true
```

```
kops edit cluster --name $NAME --state $BUCKET


kops update cluster--name $NAME --state $BUCKET --lifecycle-overrides InternetGateway=ExistsAndWarnIfChanges--yes
```

The cluster should now be ready to install AWS load balancer controller.  


To delete the cluster
```
kops delete cluster --name $NAME --state $BUCKET --yes
```

 
if this doesn't work for you then RTFM. 
