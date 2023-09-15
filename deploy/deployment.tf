resource "kubernetes_deployment" "task" {
  metadata {
    name = "microservice-deployment"
    labels = {
      app = "task-microservice"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "task-microservice"
      }
    }
    template {
      metadata {
        labels = {
          app = "task-microservice"
        }
      }
      spec {
        container {
          image = "856866880246.dkr.ecr.eu-central-1.amazonaws.com/nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
        container {
          image = "856866880246.dkr.ecr.eu-central-1.amazonaws.com/tomcat"
          name  = "tomcat-container"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "task" {
  depends_on = [kubernetes_deployment.task]
  metadata {
    name = "task-service"
  }
  spec {
    selector = {
      app = "task-microservice"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
