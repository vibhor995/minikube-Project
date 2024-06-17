# minikube-Project

# Start / Stop minikube using mainSartMinikube.tf 
terraform apply -var="action=start" 
terraform apply -var="action=stop" 

add **-auto-approve**,  include this flag, it automatically approves the proposed changes without prompting for manual confirmation

# Docker image build and push
docker build -t your_username/your_image_name:tag .
docker login
docker push your_username/your_image_name:tag

