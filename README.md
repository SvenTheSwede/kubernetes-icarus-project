# kubernetes-icarus-project

to do. tidy this abomination up

Dns used is 2 hosted zones. 
The cluster is on the subdomain hosted zone. 

ami is Ubuntu but use whatever you want as long as it's supported by kops. Flatcar is good but aws change per hour on its usage if used from the catalogue.  

OIDC provider requires an additional bucket. Don't use the same as the state one. if using oidc add podIdentitwebhook enabled: true. it requires cert manager. 

Nodes use IMDSv1.  defined by httptoken optional as part of.the instanceGroup definition.

create IAM user as per docs and s3 state bucket 

create 3 public and private subnets 
add nats and eips to public amd change routing on the private subnets 
create ssh key
update yaml file with your own details 

kops create -f kops.yaml --name name of cluster --state state bucket
add sshkey using kops command 
kops update cluster--name name --state bucket --yes

if using pre existing Internet gateway add --life-cycleovwrride InternetGateway option to update. check the docs.

kops export to get kube config 

 Cilium requires the api address of the api load balance k8sApihost 

 aws load balancer controller needs your vpc id and service account stuff if using oidc. if not using oidc add additional policies to hosts and make them all IMDSv1.
 
if this doesn't work for you then RTFM. 


