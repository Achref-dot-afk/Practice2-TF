terraform{
    required_providers{
        google ={
            source = "hashicorp/google"
            version = "~> 4.0"
        }
        kubernetes ={
            source = "hashicorp/kubernetes"
            version = "~> 2.0"
        }
    }
}

resource "google_container_cluster" "cluster"{
    provider = google
    name = var.cluster_name
    location = var.zone
     node_pool {
        initial_node_count  = 1  
  }
  
}


resource "kubernetes_deployment" "nginx" {
    provider = kubernetes
    depends_on =[google_container_cluster.cluster]
    metadata {
        name = "nginx-deployment"
    }
    spec {
        replicas = 3
        selector {
            match_labels = {
                app = "nginx"
            }
        }
        template {
            metadata {
                labels = {
                    app = "nginx" 
                }
            }
            spec {
                container {
                    image = "nginx"
                    name ="nginx-pod"
                }
                
            }
        }
    }
}
resource "kubernetes_service" "nginx-svc" {
    provider = kubernetes
    metadata {
        name = "nginx-service"

    }
    spec {
        selector = {
            app = "nginx"
        }
        port {
            protocol = "TCP"
            port = 80
            target_port = 80
            node_port = 30000

        }
        type = "NodePort"
    }
}