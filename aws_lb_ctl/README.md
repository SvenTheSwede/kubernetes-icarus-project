### AWS LB

The cluster build contained in this repo use AWS Identity provider.  AWS load balancer controller needs permissions to create ALBs, this guide helps you set it up using OIDC.

First create a [AWS Policy](https://github.com/SvenTheSwede/kubernetes-icarus-project/edit/main/aws_lb_ctl/json/policy.json) 

Create a AWS role  called aws-lb and assign the policy to it.

You will need the ARN for your oidc provider.  Edit the trust policy using this [example](https://github.com/SvenTheSwede/kubernetes-icarus-project/edit/main/aws_lb_ctl/json/trust-policy.json)   

```
aws iam get-role --role-name aws-lb
```
Edit the helm chart values adding your own vpc-id and in the serviceAccount section add an annotation to link the service account to the IAM role.
```

serviceAccount:
  create: true
  annotations: 
    eks.amazonaws.com/role-arn: arn:aws:iam::1234567899999:role/aws-lb
```

Install the helm chart
```
helm install aws-lb-ctl eks/aws-load-balancer-controller -f values.yaml -n kube-system
```

The service account will be **aws-lb-ctl-aws-load-balancer-controller**.  This is the same name used in the trust policy

To test it create a simple ingress. This example uses the utility (Public) subnets used by kops.

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  labels:
    app: ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/subnets: subnet-,subnet-,subnet-
spec:
  rules:
    - http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: some-gateway
              port: 
                number: 80
```

Check the load balancer has been created
```
kubectl get ingress
```

Check the load balancer pod logs
```
kubectl logs -f -n kube-system -l app.kubernetes.io=aws-load-balancer
```


