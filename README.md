# minikube-Project

# Start / Stop minikube using mainSartMinikube.tf 
terraform apply -var="action=start" 

terraform apply -var="action=stop" 

add **-auto-approve**,  include this flag, it automatically approves the proposed changes without prompting for manual confirmation

# Docker image build and push

docker build -t your_username/your_image_name:tag .

docker login

docker push your_username/your_image_name:tag

**Automated Setup and cluster deployment  using a Terraform  using Script Execution** [this will use main.tf file ]

# Create  a **terraform workspace** for maintaining multiple state files within a single **main.tf** for different sets of resources like **Prometheus** and **grafana** using the below command

**Run deployment action on default workspace but for prometheus and grafana installation switch to  their respective workspace and then run the script.**
**terraform workspace new Prometheus**

**terraform workspace new grafana**


**Start minikube:**
terraform apply -var="action=start"

**Deploy kubernetes pod:**
terraform apply -var="action=deployment"
      
**Deploy service:**
terraform apply -var="action=service"

**Deploy network policy:**
terraform apply -var="action=network_policy"


**Deploy Prometheus:**
Switch workspace:  terraform workspace select Prometheus
               cmd:  terraform apply -var="action=prometheus"

**Deploy grafana:**
Switch workspace: terraform workspace select grafana
cmd :                      terraform apply -var="action=grafana"


**Stop minikube:**
terraform apply -var="action=stop"

**Clean:**
terraform apply -var="action=clean"


**Delete:**
terraform apply -var="action=delete"
