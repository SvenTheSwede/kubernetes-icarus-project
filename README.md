# kubernetes-icarus-project

to do. tidy this abomination up

Dns used is 2 hosted zones. 
The cluster is on the subdomain hosted zone. 

ami is Ubuntu but use whatever you want as long as it's supported by kops. Flatcar is good but aws change per hour on its usage if used from the catalogue.  

OIDC provider requires an additional bucket. Don't use the same as the state one. if using oidc add podIdentitwebhook enabled: true. it requires cert manager. 

Nodes use IMDSv1.  defined by httptoken optional as part of.the instanceGroup definition.

Terraform for the kops basics are in this repo. 

Check status of terraform  network directory in this repo if you require networking. 
Otherwise create:
1 3 public and private subnets
2 3 Nat Gateways and EIPS on the public networks.
3  Change routing of private networks and add a route pointing to your nat gateway.
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
kops create -f kops.yaml --name name of cluster --state state bucket
```

add sshkey using kops command 

```
kops create sshpublickey --name your-cluster-nane --state s3://your-s3-state-bucket  -i ~/.ssh/id_rsa.pub 
```

The kops update will create all the necessary infra and the cluster.  If not using a pre existing internet gateway.
```
kops update cluster--name name --state bucket --l
```

if using pre existing Internet gateway.
```
kops update cluster--name name --state bucket --lifecycle-overrides InternetGateway=ExistsAndWarnIfChanges--yes
```

Export the kube config. This will eventually expire though.
```
kops export kubeconfig --name $NAME --state $BUCKET --admin
```
Validate the cluster
```
kops validate cluster --name $NAME --state $BUCKET  --wait 5m
```

 
if this doesn't work for you then RTFM. 
