terraform {
  backend "remote" {
    organization = "LHC" 

    workspaces {
      name = "k8s1-cicd" 
    }
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
  }
}

provider "kubernetes" {
  config_path = "/tmp/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "/tmp/kubeconfig"
  }
}

resource "local_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "/tmp/kubeconfig"
}

variable "kubeconfig" {
  description = "The contents of the kubeconfig file"
  type        = string
}

resource "null_resource" "cleanup" {
  provisioner "local-exec" {
    command = "rm -f /tmp/kubeconfig"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "helm_release" "prometheus_operator" {
  name         = "prometheus-operator"
  repository   = "https://prometheus-community.github.io/helm-charts"
  force_update = true
  chart        = "kube-prometheus-stack"
  version      = "47.0.0"
  depends_on = [null_resource.cleanup]

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }
}
