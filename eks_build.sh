#! /bin/bash
echo "Stage: terraform init:"
terraform init

echo "Stage: terraform apply:"
terraform apply

echo "Stage: kubectl config:"
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

echo "Stage: kubectl deploy pod:"
kubectl apply -f deploy/nginx-tomcat.yaml

echo "Stage: kubectl deploy service:"
kubectl apply -f deploy/nginx-service.yaml

echo "You can check nginx index.html page at LB DNSname:"
kubectl get services nginx-service --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'