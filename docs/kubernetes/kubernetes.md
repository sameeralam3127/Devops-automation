# [Kubernetes: From Basics to Advanced]()

## Why Container Orchestration and Need for Containers

Before containers, applications were deployed on physical or virtual machines, which posed challenges:

- **Dependency Conflicts**: Applications required specific library versions, causing conflicts on shared machines.
- **Environment Inconsistency**: Differences between development, testing, and production environments led to issues like "it works on my machine."
- **Resource Inefficiency**: Virtual machines included full operating systems, consuming significant resources.

!!! note "How Containers Solve This"
Containers package applications with their dependencies, ensuring consistency across environments.  
 They are lightweight, sharing the host OS kernel, unlike virtual machines.

---

## The Rise of Container Orchestration

As container usage scaled, manual management became inefficient. Key needs included:

- Deploying containers across multiple machines.
- Scaling applications based on demand.
- Ensuring high availability and handling failures.
- Managing networking and storage.

!!! info "Why Orchestration Tools?"
Container orchestration tools automate deployment, scaling, and resource management, improving reliability and efficiency.

---

## Why Kubernetes?

Kubernetes, originally developed by Google, became the standard for container orchestration due to:

- **Scalability**: Manages thousands of containers across clusters.
- **Portability**: Runs on-premises, in the cloud, or in hybrid setups.
- **Ecosystem**: Supported by a vast community and toolset.
- **Flexibility**: Handles diverse workloads, from stateless apps to stateful databases.

!!! tip "Key Features"
Kubernetes adoption is driven by features like auto-scaling, self-healing, and service discovery.

---

## Understanding OCI and runc

## Open Container Initiative (OCI)

!!! info "OCI Specifications"
The Open Container Initiative (OCI), under the Linux Foundation, defines standards for container formats and runtimes to ensure interoperability.

- **Container Image Specification**: Defines image structure, layers, and metadata.
- **Runtime Specification**: Defines how runtimes create and manage containers.

---

## runc

!!! note "About runc"
runc is a lightweight, CLI-based container runtime implementing the OCI runtime specification.

- Creates containers using Linux namespaces and cgroups.
- Executes processes in isolated environments.
- Foundation for higher-level tools like Docker and containerd.

!!! example "Creating a Container with runc (Red Hat and Ubuntu)"
**1. Install prerequisites**  
 On **Red Hat**:  
 `bash
    sudo yum install -y runc
    `

    On **Ubuntu/Debian**:
    ```bash
    sudo apt-get update
    sudo apt-get install -y runc
    ```

    **2. Create root filesystem (using BusyBox for demo)**
    ```bash
    mkdir rootfs
    docker export $(docker create busybox) | tar -C rootfs -xvf -
    ```

    **3. Generate default config**
    ```bash
    runc spec
    ```

    **4. Start a container**
    ```bash
    sudo runc run mycontainer
    ```

    **5. Install a package inside the container**
    For **Red Hat-based container**:
    ```bash
    yum install -y vim
    ```
    For **Ubuntu-based container**:
    ```bash
    apt-get update
    apt-get install -y vim
    ```

    **6. Check resource usage of the container**
    From host system:
    ```bash
    runc list
    runc state mycontainer
    ```

    Using Linux tools:
    ```bash
    top
    htop
    free -m
    ```

    This workflow demonstrates creating, running, and managing a container directly with `runc`, without Docker or higher-level tools.

---

## Linux Kernel Features: Namespaces and cgroups

## Namespaces

Namespaces provide isolation for containers, giving each its own:

- **PID Namespace**: Isolated process IDs.
- **Network Namespace**: Separate network stack.
- **Mount Namespace**: Isolated filesystem.
- **User Namespace**: Isolated user and group IDs.

## cgroups (Control Groups)

cgroups control resource usage:

- **CPU**: E.g., 50% of a core.
- **Memory**: E.g., 1 GB.
- **I/O**: Disk bandwidth.

!!! summary "Key Takeaway"
Containers use namespaces for isolation and cgroups for resource control.  
 Tools like Docker, containerd, and Kubernetes build on these features.

---

## Installing Local Kubernetes Environments

## Minikube

!!! tip "About Minikube"
Minikube runs a single-node Kubernetes cluster locally, ideal for learning and development.

**Prerequisites**

- CPU: 2+ CPUs
- Memory: 2 GB (4 GB recommended)
- Disk Space: 20 GB free
- OS: Linux, macOS, or Windows
- Virtualization: VT-x/AMD-V
- Tools: Docker or hypervisor (VirtualBox, Hyper-V), kubectl

**Installation Steps**

```bash
# Linux: Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# macOS
brew install kubectl
```

For Windows, download from [https://dl.k8s.io/release/stable.txt](https://dl.k8s.io/release/stable.txt) and add to PATH.

```bash
# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# macOS
brew install minikube
```

For Windows, download from [https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/).

```bash
# Start and Verify
minikube start --driver=docker
kubectl get nodes
```

Access dashboard:

```bash
minikube dashboard
```

!!! note "Usage Notes"
Minikube is for development only.
Use `minikube stop` or `minikube delete` for cleanup.

---

## Rancher Desktop

!!! info "About Rancher Desktop"
Rancher Desktop provides a lightweight Kubernetes cluster (k3s) with a GUI.

**Prerequisites**

- CPU: 4+ CPUs
- Memory: 8 GB
- OS: Linux, macOS, or Windows
- Virtualization: QEMU (Linux/macOS), WSL2 (Windows)

**Steps**

1. Download from [rancherdesktop.io](https://rancherdesktop.io/).

   ```bash
   sudo apt install ./rancher-desktop-<version>.deb
   ```

2. Enable Kubernetes in _Preferences > Kubernetes_.
3. Choose runtime: containerd or dockerd.
4. Verify with:

   ```bash
   kubectl get namespaces
   ```

!!! note "Highlights"
\- Uses k3s for efficiency.
\- Supports containerd and dockerd.

---

## Docker Desktop

!!! info "About Docker Desktop"
Docker Desktop integrates Kubernetes for local clusters.

**Prerequisites**

- OS: Windows 10/11 (Pro/Enterprise), macOS
- Virtualization: WSL2 (Windows), HyperKit (macOS)
- Memory: 4 GB (8 GB recommended)

**Steps**

1. Download from [docker.com](https://www.docker.com/products/docker-desktop/) and install.
2. Enable Kubernetes: _Settings > Kubernetes > Enable Kubernetes_.
3. Verify:

   ```bash
   kubectl cluster-info
   ```

4. Deploy Kubernetes Dashboard:

   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
   kubectl proxy
   ```

   Access at: [http://localhost:8001](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

!!! note "Usage Notes"
\- May require a paid license for large organizations.
\- Uses containerd as runtime.

---

## Hands-On with Online Kubernetes Tools

- **Katacoda**: Free browser-based labs ([https://www.katacoda.com/courses/kubernetes](https://www.katacoda.com/courses/kubernetes)).
- **Play with Kubernetes**: Temporary clusters ([https://labs.play-with-k8s.com/](https://labs.play-with-k8s.com/)).

---

## Cloud-Based Kubernetes Services

## AWS Elastic Kubernetes Service (EKS)

!!! info "About EKS"
A managed Kubernetes service integrated with AWS.

**Setup**

```bash
# Configure AWS CLI
aws configure

# Install eksctl
curl --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Create cluster
eksctl create cluster --name my-cluster --region us-west-2 --nodegroup-name my-nodes --node-type t3.medium --nodes 2

# Verify
kubectl get nodes
```

!!! note "Features"
\- Integrates with AWS services (ELB, IAM, CloudWatch).
\- Supports auto-scaling and HA.

---

## Red Hat OpenShift

!!! info "About OpenShift"
Kubernetes-based platform with developer tools.

**Setup**

- Use [Red Hat Developer Sandbox](https://developers.redhat.com/developer-sandbox).

**Features**

- CI/CD pipelines.
- Developer UI and CLI (`oc`).
- Enhanced security.

---

## Other Providers

- **Google Kubernetes Engine (GKE)**: GCP integration.
- **Azure Kubernetes Service (AKS)**: Part of Azure ecosystem.
- **IBM Cloud Kubernetes Service**: Security-focused.

---

## Example: Running a Container with containerd

```bash
sudo yum install -y containerd
sudo systemctl start containerd
sudo systemctl enable containerd

# Configure
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Pull and run Alpine
sudo ctr image pull docker.io/library/alpine:latest
export CTR_NAMESPACE=my-ns
sudo ctr --namespace $CTR_NAMESPACE run -t --rm docker.io/library/alpine:latest my-container sh

# List namespaces
sudo ctr namespaces list
```

---

## Advanced Kubernetes Concepts

## Deployments and Services

```bash
kubectl create deployment my-app --image=nginx:latest --replicas=3
kubectl expose deployment my-app --type=NodePort --port=80
```

## Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
    - host: myapp.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app
                port:
                  number: 80
```

## ConfigMaps and Secrets

```bash
kubectl create configmap my-config --from-literal=key1=value1
kubectl create secret generic my-secret --from-literal=password=secure123
```

## Persistent Volumes (PV) and Persistent Volume Claims (PVC)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

## Helm Charts

```bash
# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Deploy a chart
helm install my-release nginx-stable/nginx-ingress
```

---

## Conclusion

Kubernetes enables scalable, portable container orchestration.
Local tools like Minikube, Rancher Desktop, and Docker Desktop are great for learning, while AWS EKS and OpenShift provide production-grade solutions.

By leveraging Linux namespaces, cgroups, containerd, and Helm, Kubernetes simplifies cloud-native application development.

**Further Learning**

- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Rancher Desktop](https://rancherdesktop.io/)
- [AWS EKS](https://aws.amazon.com/eks/)
- [OpenShift Sandbox](https://developers.redhat.com/developer-sandbox)
