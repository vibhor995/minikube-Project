# minikube-Project

# Start / Stop minikube
terraform apply -var="action=start" -auto-approve
terraform apply -var="action=stop" -auto-approve

# Docker image build and push
docker build -t your_username/your_image_name:tag .
docker login
docker push your_username/your_image_name:tag

