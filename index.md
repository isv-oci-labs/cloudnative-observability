

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
5.Install helm version 3 as per the instruction at below mentioned url
https://helm.sh/docs/intro/install/
```
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```
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
11.Tag docker images appropriately using the tenancynamespace and preferred OCIR registry name
```
sudo docker tag vaishalinankani08/vegeta:test <region>.ocir.io/<tenancynamespace>/testimages/vegeta:test
sudo docker tag vaishalinankani08/votingservice:perf <region>.ocir.io/<tenancynamespace>/testimages/votingservice:perf
example:
sudo docker tag vaishalinankani08/vegeta:test ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/vegeta:test
sudo docker tag vaishalinankani08/votingservice:perf ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/votingservice:perf
```
12.Push docker images to OCIR registry
sudo docker push <region>.ocir.io/<tenancynamespace>/testimages/vegeta:tes
example
sudo docker push ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/votingservice:perf
sudo docker push ap-mumbai-1.ocir.io/bme8mxy3zkua/testimages/vegeta:test
13.Create namespace for application deployment.
 kubectl create namespace app
14.Create kubernetes secret for accessing the secured image from OCIR registry

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
18.Copy [targets.txt](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/targets.txt) , json file's representing rest api's [addvoter.json](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/addvoter.json)and vegeta binary [vegeta](https://github.com/tsenart/vegeta/releases/download/v12.8.4/vegeta_12.8.4_linux_amd64.tar.gz) in vegeta pod at path /tmp.
````
 kubectl cp vegeta default/http-client:/tmp/vegeta
 kubectl cp targets.txt default/http-client:/tmp/targets.txt
 kubectl cp addvoter.json default/http-client:/tmp/addvoter.json
 kubectl cp addvoter_badreq.json default/http-client:/tmp/addvoter_badreq.json
````
19.Install prometheus in kubernetes cluster so as to fetch application metrics from application
````
#Installation of prometheus using corresponding helm chart
helm repo add stable https://charts.helm.sh/stable
helm install  prometheus stable/prometheus
````
20.Edit serviceType to loadBalancer in prometheus service resource using below command
````
kubectl edit svc prometheus-server -n default
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
22. Edit serviceType to loadBalancer in grafana service resource/actuator/prometheus
````
 kubectl edit svc grafana -n default
 service.beta.kubernetes.io/oci-load-balancer-shape: 10Mbps
````
![oci_grafana_screen](https://user-images.githubusercontent.com/77958988/107274579-9a291180-6a76-11eb-82cc-e8ced78d707c.png)


23.run script [traffic_run.sh](https://github.com/vaishalinankani08/CloudNative-Observability/blob/gh-pages/traffic_run.sh) in one terminal to pump the traffic and in another terminal execute this command to verify that
application metrics are exposed at /actuator/prometheus
````
#terminal1
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
27.write the expressions for request rate and response success rate based on aplication metrics to verify that 
expressions are syntactically correct.

Expression:
````
sum(rate(votingService_voterRegistration_rx_requests_total{app_kubernetes_io_name="voting-app",kubernetes_namespace="$namespace"}[5m]))
![image](https://user-images.githubusercontent.com/77958988/107339889-30931c80-6ae3-11eb-9dbd-cbf231563c8b.png)
````
Expression:
````
sum(rate(votingService_voterRegistration_tx_responses_total{HttpStatusCode=~"2.*"}[5m]))*100/sum(rate(votingService_voterRegistration_tx_responses_total[5m]))
````
![image](https://user-images.githubusercontent.com/77958988/107340205-8071e380-6ae3-11eb-8e05-252e1b3828f9.png)
