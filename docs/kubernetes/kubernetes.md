# Kubernetes
??? info "Mastering Kubernetes: From Introduction to Deploying NGINX"
    Kubernetes is a powerful open-source platform that automates the management, deployment, and scaling of containerized applications. In this guide, we'll walk you through the basics of Kubernetes, how to set it up with Docker Desktop, use the `kubectl` command-line tool, and deploy an NGINX instance to see how it works.

    ---

    ## **What is Kubernetes?**

    Kubernetes, often abbreviated as K8s, is a container orchestration platform designed to simplify the deployment and management of containerized applications. It abstracts away the underlying infrastructure and makes it easier to deploy and scale applications seamlessly.

    Here’s a quick overview of the main concepts in Kubernetes:

    ### **Key Concepts**

    1. **Pod**:
       - **What It Is**: The smallest and simplest Kubernetes object. A Pod can host one or more containers that share the same network and storage.
       - **What It Does**: It serves as the environment where your application containers run.

    2. **Deployment**:
       - **What It Is**: Manages the deployment of Pods. Ensures the desired number of Pods are running and handles updates.
       - **What It Does**: Helps with scaling and automating the update process for your application.

    3. **Service**:
       - **What It Is**: A way to expose and access a set of Pods with a stable network address.
       - **What It Does**: Handles load balancing and makes sure that services can find and communicate with each other reliably.

    4. **ReplicaSet**:
       - **What It Is**: Ensures that the specified number of Pod replicas are running.
       - **What It Does**: Helps maintain the availability of your application by scaling Pods when necessary.

    5. **Namespace**:
       - **What It Is**: Provides a way to divide cluster resources into separate, logical groups.
       - **What It Does**: Useful for managing different environments (e.g., development, production) within the same cluster.


    ## **Setting Up Kubernetes in Docker Desktop**

    Docker Desktop includes a built-in Kubernetes cluster that can be easily configured for local development. Here's how you can set it up:

      1. **Open Docker Desktop**:
         - Start Docker Desktop from your application menu.

      2. **Go to Settings**:
         - Click on the gear icon (⚙️) in the top-right corner.

      3. **Select the Kubernetes Tab**:
         - Click on the "Kubernetes" tab from the sidebar.

      4. **Enable Kubernetes**:
         - Check the box that says "Enable Kubernetes".

      5. **Apply & Restart**:
         - Click "Apply & Restart" to apply the changes. Docker Desktop will restart to configure Kubernetes.

      6. **Wait for Setup**:
         - It may take a few minutes for Kubernetes to start. Docker Desktop will show the status of the Kubernetes setup.

         ??? info "Tip"
            If you are new to Kubernetes, Docker Desktop is a great way to get started as it provides an easy local environment without needing to set up a full Kubernetes cluster.

---

## **What is `kubectl`?**

`kubectl` is the command-line tool for interacting with Kubernetes clusters. It allows you to create, manage, and troubleshoot your Kubernetes resources.

### **Key Features of `kubectl`**:
- **Run Commands**: Manage Pods, Deployments, and other resources.
- **Change Configurations**: Apply YAML files to create or update Kubernetes resources.
- **Check Status**: View the status of your resources to troubleshoot or monitor your application.

### **Common `kubectl` Commands**:

- **Get Resources**:
  ```bash
  kubectl get [resource]
  ```
  - Lists resources such as Pods, Services, Deployments, etc.

- **Describe Resource**:
  ```bash
  kubectl describe [resource] [name]
  ```
  - Shows detailed information about a specific resource.

- **Apply Configuration**:
  ```bash
  kubectl apply -f [file.yaml]
  ```
  - Applies changes from a YAML configuration file.

- **Delete Resource**:
  ```bash
  kubectl delete -f [file.yaml]
  ```
  - Deletes resources defined in a YAML file.

??? warning "Deleting Resources"
    Be careful when using the `kubectl delete` command, as it permanently removes resources like Pods and Services from your cluster.

---

## **Checking Versions**

### **Check `kubectl` Version**

To check the version of `kubectl`, run the following command:

```bash
kubectl version --client
```

For both the client and server versions of Kubernetes, use:

```bash
kubectl version
```

---

## **Deploying NGINX Instances**

Now, let’s walk through deploying multiple NGINX instances on your Kubernetes cluster.

### **Step 1: Create a Deployment**

1. **Open Terminal**:
   - Use your terminal or command prompt.

2. **Create Deployment YAML File**:
   - Save the following YAML definition to a file named `nginx-deployment.yaml`:

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

### **Step 2: Expose the Deployment**

1. **Create Service YAML File**:
   - Save the following YAML to `nginx-service.yaml`:

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
   - Open a web browser and navigate to:

   ```bash
   http://127.0.0.1/
   ```

---

### **Step 3: Check the Status**

1. **List Pods**:
   - Check the status of the Pods:

   ```bash
   kubectl get pods
   ```

2. **Check Deployment**:
   - Verify the deployment:

   ```bash
   kubectl get deployments
   ```

3. **Check Service**:
   - View the status of the Service:

   ```bash
   kubectl get services
   ```

   - **Note**: Docker Desktop includes a Kubernetes dashboard, which provides a visual view of your resources.

---

### **Step 4: Clean Up**

1. **Delete the Service**:
   - To remove the Service:

   ```bash
   kubectl delete -f nginx-service.yaml
   ```

2. **Delete the Deployment**:
   - To remove the Deployment:

   ```bash
   kubectl delete -f nginx-deployment.yaml
   ```

3. **Verify Deletion**:
   - Ensure that the Pods and Services have been removed:

   ```bash
   kubectl get pods
   kubectl get services
   ```

---

