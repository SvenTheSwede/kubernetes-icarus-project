Add your vpc id to the values file. 

If OIDC enabled make sure the service account is enabled with the role arn of the IAM account it usses.  If not ensure IMDSV1 is fallback mode.   

Nodes may need addional IAM polices attached to them. AWSLoadBalancer full access plus some AWSEc2 permissions. 


