

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
```
sudo docker login -u vaishalinankani08
sudo docker pull vaishalinankani08/votingservice:test
sudo docker pull vaishalinankani08/votingservice:perf
```
9.Generate auth token by navigating to the User details page.
![image](https://user-images.githubusercontent.com/77958988/106742194-b4ac5680-6642-11eb-8cb3-de277bafbe49.png)

![image](https://user-images.githubusercontent.com/77958988/106742496-1e2c6500-6643-11eb-80fe-34cd6973aa33.png)

![image](https://user-images.githubusercontent.com/77958988/106743873-f0e0b680-6644-11eb-9f65-bc714796b8b7.png)

10.Login to docker registry
```
sudo docker login <region>.ocir.io
example:
sudo docker login ap-mumbai-1.ocir.io
#enter username as per the below format
username:<tenancynamespace>/<username>
Example username:
username:bme8mxy3zkua/oracleidentitycloudservice/vaishali.nankani@oracle.com
password:authtoken generated in step 9
```
11.tag docker images appropriately using the tenancynamespace and preferred OCIR registry name
```
sudo docker tag vaishalinankani08/vegeta:test <region>.ocir.io/<tenancynamespace>/testimages/vegeta:test
sudo docker tag vaishalinankani08/votingservice:perf <region>.ocir.io/<tenancynamespace>/testimages/votingservice:perf
example:
sudo docker tag vaishalinankani08/vegeta:test ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/vegeta:test
sudo docker tag vaishalinankani08/votingservice:perf ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/votingservice:perf
```
