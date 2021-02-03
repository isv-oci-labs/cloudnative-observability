

# Introduction
This learning path helps you understand how to deploy applications in kubernetes cluster using OKE and monitor application metrics using prometheus & grafana.
Prometheus is the open source tool which can be used for  monitoring the applications deployed in kubernetes cluster and  grafana is used for analysis &
visualization of  the metric data collected by  prometheus.

![image](https://user-images.githubusercontent.com/77958988/106723867-91c37780-662d-11eb-84cd-a1b1c1bb7bab.png)


# Steps
 1.setup a kubernetes cluster with 3 worker nodes using OKE.

 2.Install oci-cli using below commands
```
   bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
   oci -v
   oci set config
```   
 3.Set up the cluster access
![image](https://user-images.githubusercontent.com/77958988/106737640-eb7f6e00-663c-11eb-9bb1-31350f732107.png)

 4.Install kubectl
 
```
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
chmod 400 /home/opc/.kube/config
```   
5.Install helm as per the instruction at below mentioned url
https://helm.sh/docs/intro/install/

6.Install metric server as per the instruction at below mentioned url
https://github.com/kubernetes-sigs/metrics-server

7.Install docker engine on bashion host as per the instruction at below mentioned url
https://blogs.oracle.com/virtualization/install-docker-on-oracle-linux-7-v2

8.Pull docker image from docker hub

sudo docker login -u vaishalinankani08
sudo docker pull vaishalinankani08/votingservice:test
sudo docker pull vaishalinankani08/votingservice:perf

9.Push these images to the OCIR docker registry
![image](https://user-images.githubusercontent.com/77958988/106740792-e3c1c880-6640-11eb-9bf8-9e03efc0cd84.png)
