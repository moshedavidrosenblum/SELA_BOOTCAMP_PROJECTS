
![](docs/kubernetesblog02.jpg)
* in this project we have a pipeline that deploys the weight tracker app on azure kubernetes services.
* the source code is stored in this repo . the file azure-pipelines.yaml contains all the pipeline tasks they are running in azure devops .
* in kubernetes i installed ingress controller and it used to do load balancing for all trafic that comes form the cluster to the outside world.
* config map is used to store non sensitive environments and secret is used to sore the sensitive environments
![](docs/0_ysJX4XkD8klNviWQ.png)
## Azure pipeline process

* first task taks the Dockerfile from the repo builds it and deploys it to ACR  .
* in order to get image from ACR to kubernetes the task will create a imagePullSecret .
* create secret to store sensitive data and encrypt it with azure variables .
* create a task to deploy to kubernetes by sending manifests

