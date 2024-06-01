Here is a shell script to automate the setup of a Kubernetes 1.27 cluster using `kubeadm`, excluding the step to join the worker nodes to the cluster. This script should be run on all nodes (control plane and workers) to prepare them for the Kubernetes setup.

```sh
#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Step 1: Initial Setup on All Nodes

# Create configuration file for containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# Load the necessary modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Set system configurations for Kubernetes networking
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply the new settings
sudo sysctl --system

# Install containerd
sudo apt-get update
sudo apt-get install -y containerd.io

# Create the default configuration file for containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Restart containerd to ensure the new configuration file is used
sudo systemctl restart containerd

# Verify that containerd is running
sudo systemctl status containerd

# Disable swap
sudo swapoff -a

# Install dependency packages
sudo apt-get install -y apt-transport-https curl

# Download and add the GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes to the repository list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /
EOF

# Update the package listings
sudo apt-get update

# Install Kubernetes packages
sudo apt-get install -y kubelet kubeadm kubectl

# Turn off automatic updates for Kubernetes packages
sudo apt-mark hold kubelet kubeadm kubectl

# If this is the control plane node, initialize the Kubernetes cluster
if [[ $(hostname) == "k8s-control" ]]; then
    sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.27.11

    # Set up kubectl for the control plane node
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    # Install Calico Networking
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

    # Verify the installation
    kubectl get nodes
fi
```

**Instructions:**
1. Save the script to a file, for example `setup_k8s_cluster.sh`.
2. Make the script executable:

    ```sh
    chmod +x setup_k8s_cluster.sh
    ```

3. Run the script on all nodes:

    ```sh
    ./setup_k8s_cluster.sh
    ```

4. For the control plane node, set the hostname to `k8s-control` before running the script:

    ```sh
    sudo hostnamectl set-hostname k8s-control
    ```

5. Similarly, set the hostnames for the worker nodes (`k8s-worker1`, `k8s-worker2`) before running the script on them.
