locals {
  is_action_set = var.action != ""
  run_clean = var.action == "clean"
  run_start = var.action == "start"
  run_stop = var.action == "stop"
  run_delete = var.action == "delete"
  run_deployment = var.action == "" || var.action == "deployment"
  run_service = var.action == "" || var.action == "service"
  run_network_policy = var.action == "" || var.action == "network_policy"
  run_prometheus = var.action == "prometheus"
  run_grafana = var.action == "grafana"
}

// Clean Minikube
resource "null_resource" "manage_minikube_clean" {
  count = local.run_clean ? 1 : 0

  triggers = {
    always_run = timestamp()
  }
 provisioner "local-exec" {
    command = <<EOF
kubectl delete namespace ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path} || true && 
kubectl delete namespace ${var.namespace_monitoring_grafana} --kubeconfig=${var.kubeconfig_path} || true && 
kubectl delete namespace ${var.namespace_monitoring_prometheus} --kubeconfig=${var.kubeconfig_path} || true && minikube delete --purge
EOF
  }
}

// Start Minikube
resource "null_resource" "manage_minikube_start" {
  count = local.run_start ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "minikube start --cpus=6 --memory=10240 --driver=docker"
  }

  depends_on = [null_resource.manage_minikube_clean]
}

// Stop Minikube
resource "null_resource" "manage_minikube_stop" {
  count = local.run_stop ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "minikube stop --kubeconfig=${var.kubeconfig_path}"
  }
}

// Delete Minikube
resource "null_resource" "manage_minikube_delete" {
  count = local.run_delete ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "minikube delete --kubeconfig=${var.kubeconfig_path}"
  }
}

// Create namespace satsure
resource "kubernetes_namespace" "satsure" {
  count = (local.run_deployment || local.run_service || local.run_network_policy) ? 1 : 0

  metadata {
    name = var.namespace_satsure
  }
}

// Create namespace vibhor_satsure_monitoring_grafana
resource "kubernetes_namespace" "vibhor_satsure_monitoring_grafana" {
  count = local.run_grafana ? 1 : 0

  metadata {
    name = var.namespace_monitoring_grafana
  }
}
// Create namespace vibhor_satsure_monitring_prometheus
resource "kubernetes_namespace" "vibhor_satsure_monitoring_prometheus" {
  count = local.run_prometheus ? 1 : 0

  metadata {
    name = var.namespace_monitoring_prometheus
  }
}

// Apply deployment manifest
resource "null_resource" "apply_ping_pong_deployment" {
  count = local.run_deployment ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/deployment.yaml -n ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path}"
  }

  provisioner "local-exec" {
    command = "kubectl rollout status deployment/ping-pong-api -n ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path}"
  }

  depends_on = [kubernetes_namespace.satsure]
}

// Apply service manifest
resource "null_resource" "apply_ping_pong_service" {
  count = local.run_service ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/service.yaml -n ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path}"
  }

  provisioner "local-exec" {
    command = "kubectl get service ping-pong-api -n ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path}"
  }

  provisioner "local-exec" {
    command = "kubectl describe service ping-pong-api -n ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path}"
  }

  depends_on = [kubernetes_namespace.satsure]
}

// Apply network policy
resource "null_resource" "apply_network_policy" {
  count = local.run_network_policy ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/traffic-allow.yaml -n ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path}"
  }

  provisioner "local-exec" {
    command = "kubectl describe networkpolicy allow-internal-traffic -n ${var.namespace_satsure} --kubeconfig=${var.kubeconfig_path}"
  }

  depends_on = [kubernetes_namespace.satsure]
}

// Install Prometheus using Helm
resource "helm_release" "prometheus" {
  count = local.run_prometheus ? 1 : 0

  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = var.namespace_monitoring_prometheus
  values     = []

  depends_on = [kubernetes_namespace.vibhor_satsure_monitoring_prometheus]
}

// Install Grafana using Helm
resource "helm_release" "grafana" {
  count = local.run_grafana ? 1 : 0

  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.namespace_monitoring_grafana
  values     = []

  depends_on = [kubernetes_namespace.vibhor_satsure_monitoring_grafana]
}

