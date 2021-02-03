

# Introduction
This learning path helps you understand how to deploy applications in kubernetes cluster using OKE and monitor application metrics using prometheus & grafana.
Prometheus is the open source tool which can be used for  monitoring the applications deployed in kubernetes cluster and  grafana is used for analysis &
visualization of  the metric data collected by  prometheus.

![image](https://user-images.githubusercontent.com/77958988/106723867-91c37780-662d-11eb-84cd-a1b1c1bb7bab.png)


# Steps
> 1.setup a kubernetes cluster with 3 worker nodes using OKE.

> 2.Install oci-cli using below commands
```
   bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
   oci -v
   oci set config
```   
> 3.Set up the cluster access
![image](https://user-images.githubusercontent.com/77958988/106737640-eb7f6e00-663c-11eb-9bb1-31350f732107.png)



