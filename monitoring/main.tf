terraform {
  backend "remote" {
    organization = "LHC" 

    workspaces {
      name = "k8s1-cicd" 
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "prometheus_operator" {
  name         = "prometheus-operator"
  repository   = "https://prometheus-community.github.io/helm-charts"
  force_update = true
  chart        = "kube-prometheus-stack"
  version      = "47.0.0"

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
}
