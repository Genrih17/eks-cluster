#! /bin/bash
echo "Stage: terraform init:"
terraform init

echo "Stage: terraform apply:"
terraform apply

echo "Stage: kubectl config:"
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

echo "Stage: kubectl deploy pod:"
kubectl apply -f deploy/nginx-tomcat-deployment.yaml

echo "Stage: kubectl deploy service:"
kubectl apply -f deploy/nginx-service.yaml
kubectl get ingress/nginx-service