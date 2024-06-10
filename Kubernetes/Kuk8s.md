### Building a Kubernetes 1.27 Cluster with kubeadm

**Introduction**

Building a Kubernetes cluster is a vital skill for managing containerized applications. This guide will walk you through the process of setting up a Kubernetes 1.27 cluster using `kubeadm` with one control plane node and two worker nodes. The cluster will use `containerd` as the container runtime and the Calico network add-on for networking.

**Prerequisites**

- Three Linux servers
- Basic understanding of SSH and Linux command line
- Access to the internet from the servers

**Step 1: Initial Setup**

**Log in to the servers:**

Log in to each of the servers using SSH.

```sh
ssh cloud_user@<PUBLIC_IP_ADDRESS>
```

**Install necessary packages:**

Log in to the control plane node first, and then repeat these steps on all nodes.

1. **Create configuration file for containerd:**

    ```sh
    cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
    overlay
    br_netfilter
    EOF
    ```

2. **Load the necessary modules:**

    ```sh
    sudo modprobe overlay
    sudo modprobe br_netfilter
    ```

3. **Set system configurations for Kubernetes networking:**

    ```sh
    cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    EOF
    sudo sysctl --system
    ```

4. **Install containerd:**

    ```sh
    sudo apt-get update && sudo apt-get install -y containerd.io
    ```

5. **Create the default configuration file for containerd:**

    ```sh
    sudo mkdir -p /etc/containerd
    sudo containerd config default | sudo tee /etc/containerd/config.toml
    sudo systemctl restart containerd
    sudo systemctl status containerd
    ```

6. **Disable swap:**

    ```sh
    sudo swapoff -a
    ```

7. **Install dependency packages:**

    ```sh
    sudo apt-get update && sudo apt-get install -y apt-transport-https curl
    ```

8. **Download and add the GPG key:**

    ```sh
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    ```

9. **Add Kubernetes to the repository list:**

    ```sh
    cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
    deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /
    EOF
    sudo apt-get update
    ```

10. **Install Kubernetes packages:**

    ```sh
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    ```

Repeat the above steps for all worker nodes.

**Step 2: Initialize the Cluster**

1. **Initialize the Kubernetes cluster on the control plane node:**

    ```sh
    sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.27.11
    ```

2. **Set up kubectl for the control plane node:**

    ```sh
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

3. **Test access to the cluster:**

    ```sh
    kubectl get nodes
    ```

**Step 3: Install the Calico Network Add-On**

1. **Install Calico Networking on the control plane node:**

    ```sh
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
    ```

2. **Check the status of the control plane node:**

    ```sh
    kubectl get nodes
    ```

**Step 4: Join the Worker Nodes to the Cluster**

1. **Create the join command token on the control plane node:**

    ```sh
    kubeadm token create --print-join-command
    ```

2. **Copy the output from the previous command and run it on each worker node:**

    ```sh
    sudo kubeadm join <control-plane-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
    ```

3. **Verify the nodes have joined the cluster:**

    ```sh
    kubectl get nodes
    ```

