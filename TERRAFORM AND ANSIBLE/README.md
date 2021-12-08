![](training/hashicorp-terraform-logo.jpg)
### This project has the infrastructure that will built in azure resource group that will contain 2 virtual machines.   load balancer that will go through the management of the machines.  when we install an application on the machines. 

- If we wont to see the application, we  go to the load balancer's IP and it will refer to the available machine. 
- The database is from azure postgres and is managed by azure. 
- The production folder is very similar to the staging folder and they will build the same environment one different is 
- that the production machines will be larger.
- The modules/vm folder contains the structure of the virtual machines. 
- Both the production environment and the staging environment use this folder, only when building the module for each  nvironment is given the appropriate size for the machine .
- another file is needed in order to run rhe terraform, the file that contains 2 variables admin_password and  admin_username, thos files or not in git for security reson .

![](training/ansible.png)


```diff
- in the folder ansible is the plabook that is used to install all dependencies for the application 
```

## - Installation

requires  azure cli and azure acount.

```sh
cd staging/production
terraform init 
terraform apply
```
