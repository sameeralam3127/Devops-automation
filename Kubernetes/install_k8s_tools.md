Shell script that automates the installation of `kubectl`, `minikube`, and `docker` on Ubuntu 22.04 (Jammy Jellyfish):

```bash
#!/bin/bash

# Update system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg lsb-release -y

# Add Docker's official GPG key
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# Install kubectl
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

# Print installation versions
echo "Docker version:"
docker --version
echo "kubectl version:"
kubectl version --client
echo "Minikube version:"
minikube version

echo "Installation complete. Please log out and log back in to apply the Docker group membership."
```

### Instructions to Run the Script

1. Save the script to a file, for example `install_k8s_tools.sh`.
2. Make the script executable:
    ```bash
    chmod +x install_k8s_tools.sh
    ```
3. Run the script:
    ```bash
    ./install_k8s_tools.sh
    ```

This script will:

- Update and upgrade the system packages.
- Install Docker and add the current user to the `docker` group.
- Install `kubectl` from the Kubernetes APT repository.
- Install the latest version of `minikube`.

After running the script, log out and log back in to apply the Docker group membership changes.
