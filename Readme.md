# Home task for Ops

### Prepare:

 - example of multi container pod deployment with at least one dockerfile and container registry other than docker.io 

 - a way to deploy eks cluster with either terraform or cloudformation


**Configure AWS Credentials:**

> Ensure you have your AWS access and secret keys configured either via AWS CLI or environment variables.


**Configure region:**

> Replace eu-central-1 with your desired region and configure the security group rules according to your needs.


**Configure images:**

> Inside the nginx and tomcat directories, placed Dockerfiles and optional config file for Nginx and .war app for Tomcat.


**Deploy Resources:**

> Run the following commands in your eks-cluster directory:

`terraform init`

`terraform apply`

**Deploy Kubernetes Resources:**

> After the Terraform deployment is complete, deploy Kubernetes resources, including Pods, Deployments, and Services.
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-tomcat-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-tomcat
  template:
    metadata:
      labels:
        app: nginx-tomcat
    spec:
      containers:
        - name: nginx-container
          image: <ecr-url>/nginx:latest
          ports:
            - containerPort: 80
        - name: tomcat-container
          image: <ecr-url>/tomcat:latest
          ports:
            - containerPort: 8080
```

> *Replace <ecr-url> with the URL of ECR repository.*



**Apply Kubernetes Resources:**

> Apply your Kubernetes resources using kubectl:

```kubectl apply -f nginx-tomcat-deployment.yaml```


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

We should have an EKS cluster with a multi-container pod running Nginx and Tomcat, with Nginx accessible from the internet via a LoadBalancer service.
