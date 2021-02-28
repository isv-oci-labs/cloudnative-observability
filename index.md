

# Introduction
This learning path helps you understand how to deploy applications in kubernetes cluster using OKE and monitor application metrics using prometheus & grafana.
Prometheus is the open source tool which can be used for  monitoring the applications deployed in kubernetes cluster and  grafana is used for analysis &
visualization of  the metric data collected by  prometheus.

![image](https://user-images.githubusercontent.com/77958988/106723867-91c37780-662d-11eb-84cd-a1b1c1bb7bab.png)


# Steps
 1.Setup a kubernetes cluster with 3 worker nodes using OKE.
   Follow this tutorial :  https://www.oracle.com/webfolder/technetwork/tutorials/obe/oci/oke-full/index.html) 
 
   
   Set up  bashion host with below configuration:
![bashionhost](https://user-images.githubusercontent.com/77958988/109423858-35266300-7a07-11eb-8d97-8ce990430735.png)

 2.Install oci-cli on bashion host using below commands . 


```
   bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"
   oci -v
   oci set config
```   
"oci set config" command will ask for user OCID,tenancy OCID and region.
 user OCID is shown in user profile information and tenancy OCID is shown in tenancy information
 User Profile Information
![userprof](https://user-images.githubusercontent.com/77958988/109422219-a3b3f280-7a00-11eb-96bc-f0a5d988de04.png)

![userp](https://user-images.githubusercontent.com/77958988/109422243-be866700-7a00-11eb-9f41-67c24dc44f77.png)

Tenancy Information

![tenancyinfo](https://user-images.githubusercontent.com/77958988/109422393-58e6aa80-7a01-11eb-911c-a2a34c29d9aa.png)

 3.Set up the cluster access
![image](https://user-images.githubusercontent.com/77958988/106737640-eb7f6e00-663c-11eb-9bb1-31350f732107.png)

 4.Install kubectl on bashion host with below commands
 
```
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
chmod 400 /home/opc/.kube/config
```   
5.Install helm version 3 as per the instruction at url
https://helm.sh/docs/intro/install/
```
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
6.Install metric server as per the instruction at url
https://github.com/kubernetes-sigs/metrics-server

7.Install docker engine on bashion host as per the instruction at url
https://blogs.oracle.com/virtualization/install-docker-on-oracle-linux-7-v2

8.Pull docker image from docker hub
```
sudo docker pull vaishalinankani08/vegeta:test
sudo docker pull vaishalinankani08/votingservice:perf
```
9.Generate auth token by navigating to the User details page.
![image](https://user-images.githubusercontent.com/77958988/106742194-b4ac5680-6642-11eb-8cb3-de277bafbe49.png)

![image](https://user-images.githubusercontent.com/77958988/106742496-1e2c6500-6643-11eb-80fe-34cd6973aa33.png)

![image](https://user-images.githubusercontent.com/77958988/106743873-f0e0b680-6644-11eb-9f65-bc714796b8b7.png)

10.Login to docker registry
```
sudo docker login <region>.ocir.io
#enter username as per the below format
username:<tenancynamespace>/<username>
password:authtoken generated in step 9
```
![dockerlogin](https://user-images.githubusercontent.com/77958988/109424695-a9aed100-7a0a-11eb-8895-96d0e76dc59e.png)


11.Tag docker images appropriately using the tenancynamespace and preferred OCIR registry name
```
sudo docker tag vaishalinankani08/vegeta:test <region>.ocir.io/<tenancynamespace>/testimages/vegeta:test
sudo docker tag vaishalinankani08/votingservice:perf <region>.ocir.io/<tenancynamespace>/testimages/votingservice:perf
example:
sudo docker tag vaishalinankani08/vegeta:test ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/vegeta:test
sudo docker tag vaishalinankani08/votingservice:perf ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/votingservice:perf
```
12.Push docker images to OCIR registry
````
sudo docker push <region>.ocir.io/<tenancynamespace>/testimages/vegeta:test
example
sudo docker push ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/votingservice:perf
sudo docker push ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/vegeta:test
````
13.Create namespace("app") for application deployment.

````
 kubectl create namespace app
````

14.Create kubernetes secret for accessing the docker images from OCIR registry

 ````
kubectl create secret -n app docker-registry <secret-name> --docker-server=<region-id>.ocir.io --docker-username='<cloud-account-username>' --docker-password='<auth-token>' --docker-email='<cloud-account-emailid>'
 example:
kubectl create secret -n app docker-registry ocirsecret --docker-server=ap-mumbai-1.ocir.io --docker-username='bme8mxy3zkua/oracleidentitycloudservice/vaishali.nankani@oracle.com' --docker-password='NhgP<5dlL3:>yfXViLpt' --docker-email='vaishali.nankani@oracle.com'
  ````
15.Pick the deployment file for the application  [votingApp.yaml](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/votingApp.yaml) .
execute below command. Execute kubectl commands to verify that deployment and service resources are created appropriately
```
kubectl create -f votingApp.yaml
Verify that kubernetes resources are created successfully using below commands
kubectl get pods -n app
kubectl get services -n app
````
16.Create kubernetes secret in namespace where vegeta will be deployed.In this hands-on lab we are deploying it on default namespace 
    kubernetes secret should be present in same namespace as the deployment that uses it.

````
kubectl create secret -n default docker-registry <secret-name> --docker-server=<region-id>.ocir.io --docker-username='<cloud-account-username>' --docker-password='<auth-token>' --docker-email='<cloud-account-emailid>'
 example:
kubectl create secret -n default docker-registry ocirsecret --docker-server=ap-mumbai-1.ocir.io --docker-username='bme8mxy3zkua/oracleidentitycloudservice/vaishali.nankani@oracle.com' --docker-password='NhgP<5dlL3:>yfXViLpt' --docker-email='vaishali.nankani@oracle.com'
````
17.Pick the deployment file for the vegeta load testing tool  [vegeta.yaml](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/vegeta.yaml)
Execute below command. Execute kubectl commands to verify that deployment and service resources are created appropriately
````
kubectl create -f vegeta.yaml
````
18.Copy [targets.txt](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/targets.txt) , json file [addvoter.json] representing rest api's(https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/addvoter.json) and vegeta binary [vegeta](https://github.com/tsenart/vegeta/releases/download/v12.8.4/vegeta_12.8.4_linux_amd64.tar.gz) in vegeta pod at path /tmp.
````
 kubectl cp vegeta default/http-client:/tmp/vegeta
 kubectl cp targets.txt default/http-client:/tmp/targets.txt
 kubectl cp addvoter.json default/http-client:/tmp/addvoter.json 
````
19.Install prometheus in kubernetes cluster so as to fetch application metrics from application
````
#Installation of prometheus using corresponding helm chart
helm repo add stable https://charts.helm.sh/stable
helm install  prometheus stable/prometheus
````
20.Edit serviceType to LoadBalancer in prometheus k8s service resource using below command so as to access the prometheus server GUI through browser
````
kubectl edit svc prometheus-server -n default

````
![loadbalancer](https://user-images.githubusercontent.com/77958988/109425773-0791e780-7a10-11eb-8b07-c586ae450656.png)

````
#Add this annotation in the annotations section of the service resource
service.beta.kubernetes.io/oci-load-balancer-shape: 10Mbps
````

![oci_prometheus](https://user-images.githubusercontent.com/77958988/107274095-01929180-6a76-11eb-8de8-4fec89379f58.png)
21.Install grafana in kubernetes cluster so as to visualize application statistics
````
#Add helm repository
 helm repo add grafana https://grafana.github.io/helm-charts
#Installation of grafana using corresponding helm chart
 helm install  grafana stable/grafana
 ````
22.Edit serviceType to LoadBalancer in grafana k8s service resource so as to access the grafana GUI through browser
````
 kubectl edit svc grafana -n default
 service.beta.kubernetes.io/oci-load-balancer-shape: 10Mbps
````
![oci_grafana_screen](https://user-images.githubusercontent.com/77958988/107274579-9a291180-6a76-11eb-82cc-e8ced78d707c.png)


23.Run script [traffic_run.sh](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/traffic_run.sh) in one terminal to pump the traffic 
and in another terminal execute  command to verify that application metrics are exposed at /actuator/prometheus

#terminal1
````
./traffic_run.sh
````
![image](https://user-images.githubusercontent.com/77958988/107339421-ad71c680-6ae2-11eb-80b6-efb7a4180075.png)

#terminal2
````
kubectl exec <podname>  -n app -- curl -X GET  "http://voting-app.app.svc.cluster.local:8080/actuator/prometheus" -H "Content-Type: application/json" | grep "votingService"
example
kubectl exec voting-app-6c4b5fd885-phpq5  -n app -- curl -X GET  "http://voting-app.app.svc.cluster.local:8080/actuator/prometheus" -H "Content-Type: application/json" | grep "votingService"
````
24.Check the public IP Address assigned to prometheus and grafana loadbalancer service type using below command.
````
kubectl get svc -n default
````
![image](https://user-images.githubusercontent.com/77958988/107332763-99c26200-6ada-11eb-9dd9-63f25cf51654.png)
25.Open prometheus GUI and grafana GUI using the public IP addresses noted from command in step 24
![prometheus](https://user-images.githubusercontent.com/77958988/107337398-4f43e400-6ae0-11eb-8c6d-b4c7d5455d33.png)

![image](https://user-images.githubusercontent.com/77958988/107337178-03913a80-6ae0-11eb-9144-1b5cdc4e7249.png)
26.Verify that prometheus is able to scrape metrics from application pods by searching metric name in prometheus console
![image](https://user-images.githubusercontent.com/77958988/107338723-e3627b00-6ae1-11eb-81ac-0ff7300e4bca.png)
27.Write the expressions for request rate and response success rate based on aplication metrics to verify that 
expressions are syntactically correct.

Expression for Registration Rate:
````
sum(rate(votingService_voterRegistration_rx_requests_total{app_kubernetes_io_name="voting-app",kubernetes_namespace="$namespace"}[5m]))
````
![image](https://user-images.githubusercontent.com/77958988/107339889-30931c80-6ae3-11eb-9dbd-cbf231563c8b.png)

Expression for Registration Success Rate:
````
sum(rate(votingService_voterRegistration_tx_responses_total{HttpStatusCode=~"2.*"}[5m]))*100/sum(rate(votingService_voterRegistration_tx_responses_total[5m]))
````
![image](https://user-images.githubusercontent.com/77958988/107340205-8071e380-6ae3-11eb-8e05-252e1b3828f9.png)


28.Grafana' admin user password needs to be decoded from kubernetes secret resource . use below command to extract the admin user's password .
````
kubectl edit secret grafana -n default
````
![image](https://user-images.githubusercontent.com/77958988/107355118-0c403b80-6af5-11eb-98cc-48b6ba95ad0e.png)

decode password using [base64decode](https://www.base64decode.org/)

![base64decode](https://user-images.githubusercontent.com/77958988/107393868-4293b000-6b21-11eb-8e8b-2108f3d7f677.png)


Use the decoded password to login to the grafana with username as admin.Change the admin user's password.

![grafanachan](https://user-images.githubusercontent.com/77958988/107396227-97382a80-6b23-11eb-956a-d3a5c460f435.png)

![image](https://user-images.githubusercontent.com/77958988/107403913-ae7b1600-6b2b-11eb-8689-89c54c50a3bc.png)

29.Import json dashborad for application to visualize registration rate,registration success rate as well as container cpu & memory stats
  ![image](https://user-images.githubusercontent.com/77958988/107405450-59400400-6b2d-11eb-87fb-a4beb8d9fdb2.png)
  
   Upload  [votingApp](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/votingservice.json) dashboard json file
  ![grafanaimport](https://user-images.githubusercontent.com/77958988/107408156-98bc1f80-6b30-11eb-8ef3-487caf2f10f4.png)
   
   Panels for Registration Rate,Registration Success Rate as well as Container CPU & Memory Utilization
   
   Registration Rate:
   
  ![image](https://user-images.githubusercontent.com/77958988/107411272-5ac0fa80-6b34-11eb-80fa-d4d2b6c08449.png)
   
   Registration Success Rate:
  
  ![image](https://user-images.githubusercontent.com/77958988/107409810-8e9b2080-6b32-11eb-9dc1-a7a852ddc8ac.png)
  
  Container CPU & Memory Utilization:
  
  ![image](https://user-images.githubusercontent.com/77958988/107412134-56e1a800-6b35-11eb-88b4-a5c376913a68.png)

  
