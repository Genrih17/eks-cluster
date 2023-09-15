# Home task for Ops



 - example of multi container pod deployment with at least one dockerfile and container registry other than docker.io 

 - a way to deploy eks cluster with either terraform or cloudformation

#


Terraform will creates follow resources:
 - VPC with 2 privat and 2 public subnets in 2 AZs, with route tables and SG, NACLs;
 - NAT gateway, internet gateway;
 - Cluster with nodegroup (based on t3.small instance type);
 - Pod with nginx and tomcat containers;
 - Service nginx-service to provide acces to nginx on HTTP port.
#

   ## Prepare:

**Configure AWS Credentials:**

> Ensure you have your AWS access and secret keys configured either via AWS CLI or environment variables.


**Configure region:**

> Replace eu-central-1 with your desired region and configure the security group rules according to your needs.

**Login to ECR:**

> Use the AWS CLI to log in to your ECR registry. Replace <your-aws-region> and <your-aws-account-id> with your specific information:

`aws ecr get-login-password --region <your-aws-region> | docker login --username AWS --password-stdin <your-aws-account-id>.dkr.ecr.<your-aws-region>.amazonaws.com`


![image](https://github.com/Genrih17/eks-cluster/assets/84070046/d3f7369c-9b89-4443-87e8-158dc669a716)


**Build images:**

> Inside the nginx and tomcat directories, placed Dockerfiles and optional config file for Nginx and .war app for Tomcat. Build localy with command:

`docker build -t nginx .`

`docker build -t tomcat .`

**Tag images:**

> After the build completes, tag image so you can push the image to ECR repository.

`docker tag nginx:latest <your-aws-account-id>.dkr.ecr.<your-aws-region>.amazonaws.com/nginx:latest`

**Push the Docker Image to ECR:**

> Push the tagged Docker image to your ECR repository.

`docker push <your-aws-account-id>.dkr.ecr.<your-aws-region>.amazonaws.com/nginx:latest`

![image](https://github.com/Genrih17/eks-cluster/assets/84070046/6ad78a24-8851-440e-8ddb-16248523c81f)


![image](https://github.com/Genrih17/eks-cluster/assets/84070046/e7321be8-27fb-4926-8ef4-0b8df5a3ac65)

## Deploy Resources:

**Provide execution rigth with cmod to ./eks_buld.sh scrips and execute it with `./eks_build.sh`.**

This script contains steps with commands:

```
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

echo "You can check nginx container's index.html page at LB DNSname:"
kubectl get services nginx-service --output jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

> I have ommit the '--auto-approve' flag just to you will see what resourses will be created.

Previous steps with build and push image can be included in script as well, if needed.



## Or you can deploy it manually by following steps:


> Run terraform commands in eks-cluster directory:

`terraform init`

`terraform apply`


**Run the following command to retrieve the access credentials for your cluster and configure kubectl.**

 `aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)`

> You can now use kubectl to manage your cluster and deploy Kubernetes configurations to it.



**Deploy Kubernetes Resources:**

> After the Terraform deployment is complete, deploy Kubernetes resources.
```
kind: Pod
apiVersion: v1
metadata:
  name: testpod
  labels:
    app: nginx-tomcat
spec:
  containers:
    - name: nginx
      image: <ecr-url>/nginx
      ports:
        - containerPort: 80
    - name: tomcat
      image: <ecr-url>/tomcat
      ports:
        - containerPort: 8080

```

> *Replace <ecr-url> with the URL of ECR repository.*



**Apply Kubernetes Resources:**

> Apply your Kubernetes resources using kubectl:

```kubectl apply -f nginx-tomcat.yaml```

![image](https://github.com/Genrih17/eks-cluster/assets/84070046/e66a5a82-3e06-4e21-ae5d-6cc4ac4c5ffe)

**Create Services:**

> To expose nginx container to the internet, create a Kubernetes Service of type ***LoadBalancer***:

```apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx-tomcat
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```
**Apply the Service using kubectl:**

```kubectl apply -f nginx-service.yaml```
![image](https://github.com/Genrih17/eks-cluster/assets/84070046/d04d8d94-0b10-49de-9afc-2fea4a4b2dcf)

We should have an EKS cluster with a multi-container pod running Nginx and Tomcat, with Nginx accessible from the internet via a LoadBalancer service.

Using LoadBalanser DNSname you can check the result on HTTP port:
![image](https://github.com/Genrih17/eks-cluster/assets/84070046/dd1bf2c2-79e0-446e-a2e6-27c2a6ba90f3)


**You can destroy resources after with command:**


```terraform destroy```
