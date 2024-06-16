variable "action" {
  description = "Action to perform: clean, start, stop, or delete Minikube"
  type        = string
  default     = ""
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "minikube.kubeconfig"
}

variable "namespace_satsure" {
  description = "Namespace for deployment"
  type        = string
  default     = "satsure"
}

variable "namespace_monitoring_grafana" {
  description = "Namespace for monitoring tools"
  type        = string
  default     = "vibhor-satsure-monitoring-grafana"
}

variable "namespace_monitoring_prometheus" {
  description = "Namespace for monitoring tools"
  type        = string
  default     = "vibhor-satsure-monitoring-prometheus"
}

