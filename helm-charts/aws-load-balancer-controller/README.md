Add your vpc id to the values file. 

If OIDC enabled make sure the service account is enabled with the role arn of the IAM account it usses.  If not ensure IMDSV1 is fallback mode.   

Nodes may need addional IAM polices attached to them. AWSLoadBalancer full access plus some AWSEc2 permissions. 

To create a https listener on you ALB you'll need a cert.  To create a self signed cert use openssl and add it into AWS ACM.  Use the cert arn in the values.yaml file.  Ensure the user has the correct permisions to do this.  If you get an invalid base error try file instead of fileb.  This works with the current version of aws cli


Create private key

    openssl genrsa 2048 > my-private-key.pem
    
Generate cert using key and answer all the questions. common name MUST be .amazonaws.com

    openssl req -new -x509 -nodes -sha256 -days 365 -key my-private-key.pem -outform PEM -out my-certificate.pem

    
Add it into AWS ACM

     aws acm import-certificate --certificate fileb://my-certificate.pem --private-key fileb://my-private-key.pem

