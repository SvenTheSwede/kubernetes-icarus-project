
Uses mixed spot instances for scaling as main IGs do not scale to reduce costs

Seperate file for IGs.  If updating IGs use this file rather than the main config.


This setup uses IAM Provider.  Kops will create the necessary provider and supply kube API with the necessary arguments. You can sometimes run into trouble if using the pod identity webhook provider if you don't have any networking set like this config.   Install pod identity webhook after the networking (Cilium) is installed. 
