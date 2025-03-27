# kubernetes-icarus-project


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

if this doesn't work for you then RTFM. 


