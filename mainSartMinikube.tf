provider "local" {}

// Variable to determine whether to start or stop Minikube
variable "action" {
  description = "Action to perform: start or stop Minikube"
  type        = string
  default     = "start"
}

// Start Minikube
resource "null_resource" "manage_minikube_start" {
  count = var.action == "start" ? 1 : 0

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "minikube start --cpus=6 --memory=10240 --driver=docker"
  }
}

// Stop Minikube
resource "null_resource" "manage_minikube_stop" {
  count = var.action == "stop" ? 1 : 0

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "minikube stop"
  }
}

