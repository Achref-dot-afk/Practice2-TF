provider "google"{
    credentials = file(var.gcp_key) 
    project = var.projectId
    region = var.region
}

provider "kubernetes"{
    config_path = "~/.kube/config"
    
}