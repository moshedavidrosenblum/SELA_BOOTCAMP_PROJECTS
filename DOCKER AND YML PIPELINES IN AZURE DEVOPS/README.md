![](docs/docker-cover.png)
## The azure-pipelines.yml file will run the pipeline in azuredevops as follows:

### It  is not possible to make a change in the main brunch but first its needed to go to  the brunch  feature  and make a change there. 
## Once the change has been made it will make a trigger that will run the first stage . 
### The first stage takes from the git  the dockerfile builds  the image and pushes it to the ACR. 
## Once the first stage has been successfully completed the branch will make a pull request for the main brunch. 
### Only after the first stage has been successfully completed and the application is  approved it  will do  the other stages. 
## The "DeployToStaging" stage will take from  ACR the image will build run and deploy the container that contains the application on the staging servers. 
## The "deployToProduction" stagewill do the same thing on the production servers
