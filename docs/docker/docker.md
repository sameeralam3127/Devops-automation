# [Docker: From Basics to Advanced]()

??? info "What is Docker?"
Docker is an open-source platform designed to simplify application deployment. It ensures that applications run reliably regardless of the environment.  
It allows developers to build, ship, and run applications in isolated environments called **containers**. Containers package applications with their libraries, dependencies, and configurations, ensuring consistency across development, testing, and production.

---

??? tip "Why Use Docker?"

- **Consistency**: Applications behave the same in development, testing, and production.
- **Lightweight**: Containers share the host OS kernel, making them more efficient than virtual machines.
- **Portable**: Run applications anywhere, from local machines to cloud platforms.

---

??? tip "Getting Started with Docker Installation"

**1. Install Docker on Linux**

```bash
# Update the package index
sudo apt update

# Install required packages
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Verify the installation
docker --version
```

**2. Install Docker on macOS**

??? note "Prerequisites for macOS"

- Requires macOS 10.14 or newer
- Ensure adequate resources are available for Docker Desktop

```bash
# Download Docker Desktop for Mac from:
https://www.docker.com/products/docker-desktop/

# Install Docker by dragging it to the Applications folder
# Open Docker Desktop and follow setup instructions
```

**3. Install Docker on Windows**

??? info "Supported Windows Versions"
Docker Desktop supports Windows 10 64-bit (Professional, Enterprise, Education) and Windows 11

Steps:

1. Download Docker Desktop from [Docker's official website](https://www.docker.com/products/docker-desktop).
2. Run the installer and follow on-screen instructions.
3. After installation, verify with:

   ```powershell
   docker --version
   ```

---

**Useful Tips**

!!! tip "Enable Non-Root Docker Access on Linux"
Add your user to the Docker group to run Docker without `sudo`:

```bash
sudo usermod -aG docker $USER
```

Log out and log back in for changes to take effect.

!!! warning "Docker Resource Limits"
Containers share host resources. Ensure sufficient CPU and memory allocation for performance.

!!! note "Docker Desktop vs Docker Engine"

- **Docker Desktop**: Includes GUI tools, ideal for macOS and Windows.
- **Docker Engine**: Lightweight CLI-based version for Linux servers.

---

**Verify Your Docker Installation**

Run a test container:

```bash
docker run hello-world
```

Expected output:

```plaintext
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

---

## Docker Command Reference

## Basic Commands

- **Check Docker Version**

```bash
docker --version
```

- **List Docker Images**

```bash
docker images
```

- **List Running Containers**

```bash
docker ps
```

- **List All Containers**

```bash
docker ps -a
```

- **Run a Container**

```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

- **Stop a Running Container**

```bash
docker stop CONTAINER_ID
```

- **Remove a Container**

```bash
docker rm CONTAINER_ID
```

- **Remove an Image**

```bash
docker rmi IMAGE_ID
```

---

## Building Docker Images

- **Build an Image from a Dockerfile**

```bash
docker build -t IMAGE_NAME:TAG PATH
```

- **Build Without Cache**

```bash
docker build --no-cache -t IMAGE_NAME:TAG PATH
```

- **View Build History**

```bash
docker history IMAGE_NAME:TAG
```

---

## Dockerfile Basics

**Example:**

```dockerfile
# Use a base image
FROM ubuntu:latest

# Set environment variables
ENV MY_ENV_VAR=value

# Install dependencies
RUN apt-get update && apt-get install -y curl

# Copy files
COPY ./local_file /container_file

# Define default command
CMD ["echo", "Hello, Docker!"]
```

---

## Networking and Volumes

- **Create a Network**

```bash
docker network create my_network
```

- **Run a Container on a Network**

```bash
docker run --network my_network IMAGE_NAME
```

- **Create a Volume**

```bash
docker volume create my_volume
```

- **Run with a Volume**

```bash
docker run -v my_volume:/container_path IMAGE_NAME
```

---

## Docker Compose

- **Start Services**

```bash
docker-compose up
```

- **Detached Mode**

```bash
docker-compose up -d
```

- **Stop Services**

```bash
docker-compose down
```

- **View Logs**

```bash
docker-compose logs
```

---

## Registry Operations

- **Push to Docker Hub**

```bash
docker push IMAGE_NAME:TAG
```

- **Pull from Docker Hub**

```bash
docker pull IMAGE_NAME:TAG
```

- **Tag an Image**

```bash
docker tag SOURCE_IMAGE:TAG TARGET_IMAGE:TAG
```

- **Login**

```bash
docker login
```

---

## Troubleshooting and Scenarios

## Scenario 1: Container Not Starting

- **Symptom**: Container exits immediately
- **Solution**: Check logs

```bash
docker logs CONTAINER_ID
```

Ensure command is valid and not terminating.

??? info "Debug Tip"
Use `-it` to keep the container interactive during debugging.

---

## Scenario 2: Image Build Fails

- **Symptom**: `docker build` fails
- **Solution**:

  - Review error messages
  - Ensure `Dockerfile` syntax is correct
  - Use no-cache build:

    ```bash
    docker build --no-cache -t IMAGE_NAME:TAG .
    ```

??? warning "Cache Considerations"
Cached layers may cause outdated dependencies. Use `--no-cache` to ensure fresh builds.

---

## Scenario 3: Port Already in Use

- **Symptom**: Port conflict error
- **Solution**:

  - Identify process:

    ```bash
    lsof -i :PORT
    ```

  - Stop conflicting process or map a new port:

    ```bash
    docker run -p NEW_PORT:CONTAINER_PORT IMAGE_NAME
    ```

??? note "Port Conflict Resolution"
Use `docker ps` to review port mappings of running containers.

---

## Scenario 4: Cannot Remove Container/Image

- **Symptom**: Removal fails with "in use" error
- **Solution**:

  - Stop all containers:

    ```bash
    docker stop $(docker ps -q)
    ```

  - Force remove:

    ```bash
    docker rm -f CONTAINER_ID
    docker rmi -f IMAGE_ID
    ```

??? info "Forced Removal"
The `-f` flag forces removal even when containers or images are in use.
