# kubernetes-icarus-project



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


    /¯¯\
 /¯¯\__/¯¯\    Cilium:             OK                                                                                                                                                                                                      
 \__/¯¯\__/    Operator:           OK
 /¯¯\__/¯¯\    Envoy DaemonSet:    2 errors
 \__/¯¯\__/    Hubble Relay:       disabled
    \__/       ClusterMesh:        disabled

DaemonSet              cilium                   Desired: 6, Ready: 6/6, Available: 6/6
DaemonSet              cilium-envoy             Desired: 6, Unavailable: 6/6
Deployment             cilium-operator          Desired: 2, Ready: 2/2, Available: 2/2
Containers:            cilium                   Running: 6
                       cilium-envoy             
                       cilium-operator          Running: 2
                       clustermesh-apiserver    
                       hubble-relay             
Cluster Pods:          22/22 managed by Cilium
Helm chart version:    1.17.2
Image versions         cilium             quay.io/cilium/cilium:v1.17.0@sha256:51f21bdd003c3975b5aaaf41bd21aee23cc08f44efaa27effc91c621bc9d8b1d: 6
                       cilium-operator    quay.io/cilium/operator-generic:v1.17.0@sha256:1ce5a5a287166fc70b6a5ced3990aaa442496242d1d4930b5a3125e44cccdca8: 2
Errors:                cilium-envoy       cilium-envoy    6 pods of DaemonSet cilium-envoy are not ready
                       cilium-envoy       cilium-envoy    daemonset cilium-envoy is rolling out - 0 out of 6 pods updated

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

Validate the cluster is ready to progress.
```
  kops validate --name $NAME --state $BUCKET --wait 2m
```
You should eventually see  the cluster validated.
```
INSTANCE GROUPS
NAME                            ROLE            MACHINETYPE     MIN     MAX     SUBNETS
control-plane-eu-north-1a       ControlPlane    t3.medium       1       1       eu-north-1a
control-plane-eu-north-1b       ControlPlane    t3.medium       1       1       eu-north-1b
control-plane-eu-north-1c       ControlPlane    t3.medium       1       1       eu-north-1c
nodes-eu-north-1a               Node            t3.medium       1       1       eu-north-1a
nodes-eu-north-1b               Node            t3.medium       1       1       eu-north-1b
nodes-eu-north-1c               Node            t3.medium       1       1       eu-north-1c

NODE STATUS
NAME                    ROLE            READY
i-00509607b1a6462ff     node            True
i-0096917881b3152e0     node            True
i-059d9822ecc6cae2b     control-plane   True
i-060400d1737b01ba2     node            True
i-0bd5ae25d7a1626fa     control-plane   True
i-0cdb59f0a8f9d734f     control-plane   True

Your cluster kops.k8s.icarus-project.net is ready
```


The cluster should now be ready to install AWS load balancer controller.  
[AWS Loadbalancer Instructions](https://github.com/SvenTheSwede/kubernetes-icarus-project/tree/main/aws_lb_ctl)


To delete the cluster
```
kops delete cluster --name $NAME --state $BUCKET --yes
```

 
if this doesn't work for you then RTFM. 
