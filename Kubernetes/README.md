# Mastering Kubernetes: From Introduction to Deploying NGINX

Kubernetes is a powerful tool that helps manage and run applications in containers. It makes tasks like deploying, scaling, and maintaining apps much easier. This guide will help you learn the basics of Kubernetes, set it up in Docker Desktop, use `kubectl`, and deploy NGINX.

## What is Kubernetes?

Kubernetes is a free, open-source system that helps automate the management of applications in containers. It simplifies the deployment and operation of applications by handling the underlying infrastructure for you. Here’s a quick look at its main features:

### Key Concepts

1. **Pod**:
   - **What It Is**: The smallest unit in Kubernetes. A Pod can hold one or more containers that share the same network and storage.
   - **What It Does**: Runs single instances of applications or services, keeping them consistent and separate from others.

2. **Deployment**:
   - **What It Is**: Manages how Pods are deployed and scaled. It ensures that the right number of Pods are running and helps with updates.
   - **What It Does**: Automates creating, updating, and scaling Pods, making sure your app is always available.

3. **Service**:
   - **What It Is**: Defines a way to access a set of Pods and provides a stable network address.
   - **What It Does**: Helps with load balancing and finding services, ensuring reliable communication between app parts.

4. **ReplicaSet**:
   - **What It Is**: Ensures a specified number of Pod copies are running. Usually managed by Deployments.
   - **What It Does**: Keeps your app reliable and scalable by maintaining the right number of Pod copies.

5. **Namespace**:
   - **What It Is**: Divides cluster resources into virtual clusters to organize and control access.
   - **What It Does**: Useful for separating environments like development and production, or for managing different projects.

## Setting Up Kubernetes in Docker Desktop

Docker Desktop includes a built-in Kubernetes cluster for local development. Here’s how to set it up:

1. **Open Docker Desktop**:
   - Start Docker Desktop from your applications menu.

2. **Go to Settings**:
   - Click the gear icon (⚙️) in the top-right corner.

3. **Select the Kubernetes Tab**:
   - Choose the "Kubernetes" tab from the sidebar.

4. **Enable Kubernetes**:
   - Check "Enable Kubernetes".

5. **Apply & Restart**:
   - Click "Apply & Restart" to start Kubernetes. Docker Desktop will restart to configure it.

6. **Wait for Setup**:
   - It might take a few minutes for Kubernetes to start. Docker Desktop will show the setup status.

## What is `kubectl`?

`kubectl` is a command-line tool for managing Kubernetes clusters. It lets you interact with your Kubernetes resources.

### Key Features of `kubectl`:

- **Run Commands**: Manage resources like Pods, Services, and Deployments.
- **Change Configurations**: Apply changes to create or update resources.
- **Check Status**: View and debug the state of resources in the cluster.

### Common `kubectl` Commands:

- **Get Resources**:
  ```bash
  kubectl get [resource]
  ```
  - Lists resources like Pods, Services, or Deployments.

- **Describe Resource**:
  ```bash
  kubectl describe [resource] [name]
  ```
  - Shows detailed info about a specific resource.

- **Apply Configuration**:
  ```bash
  kubectl apply -f [file.yaml]
  ```
  - Applies changes from a YAML file.

- **Delete Resource**:
  ```bash
  kubectl delete -f [file.yaml]
  ```
  - Deletes resources from the cluster.

## Checking Versions

### Check `kubectl` Version

To find out which version of `kubectl` you have:

```bash
kubectl version --client
```

```bash
kubectl version
```

- This shows both the client and server versions of Kubernetes.

## Deploying NGINX Instances

To deploy multiple NGINX instances, follow these steps:

### Step 1: Create a Deployment

1. **Open Terminal**:
   - Use your terminal or command prompt.

2. **Create Deployment YAML File**:
   - Save the following to `nginx-deployment.yaml`:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
         - name: nginx
           image: nginx:latest
           ports:
           - containerPort: 80
   ```

   - **What It Does**: Defines a Deployment with 3 replicas of NGINX.

3. **Apply the Deployment**:
   - Run:

   ```bash
   kubectl apply -f nginx-deployment.yaml
   ```

### Step 2: Expose the Deployment

1. **Create Service YAML File**:
   - Save the following to `nginx-service.yaml`:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: nginx-service
   spec:
     selector:
       app: nginx
     ports:
       - protocol: TCP
         port: 80
         targetPort: 80
     type: LoadBalancer
   ```

   - **What It Does**: Creates a Service to expose the NGINX Deployment.

2. **Apply the Service**:
   - Run:

   ```bash
   kubectl apply -f nginx-service.yaml
   ```

3. **Access NGINX in Browser**:
   - Open:

   ```bash
   http://127.0.0.1/
   ```

### Step 3: Check the Status

1. **List Pods**:
   - Check Pods:

   ```bash
   kubectl get pods
   ```

2. **Check Deployment**:
   - Verify Deployment:

   ```bash
   kubectl get deployments
   ```

3. **Check Service**:
   - View Service status:

   ```bash
   kubectl get services
   ```

   - **Note**: Docker Desktop has a Kubernetes dashboard for a visual view of your resources.

### Step 4: Clean Up

1. **Delete the Service**:

   ```bash
   kubectl delete -f nginx-service.yaml
   ```

2. **Delete the Deployment**:

   ```bash
   kubectl delete -f nginx-deployment.yaml
   ```

3. **Verify Deletion**:
   - Ensure Pods and Services are removed:

   ```bash
   kubectl get pods
   kubectl get services
   ```

---
