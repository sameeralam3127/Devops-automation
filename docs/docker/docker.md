??? info "What is Docker?"
    Docker is an open-source platform designed to simplify application deployment. It ensures that your applications run smoothly, regardless of where they are executed.
    Docker is a platform that enables developers to build, ship, and run applications in isolated environments called **containers**. These containers bundle everything an application needs, including libraries, dependencies, and configurations, ensuring it works consistently across different environments.

??? example "Why Use Docker?"
    - **Consistency**: Applications behave the same in development, testing, and production.  
    - **Lightweight**: Containers share the host OS, making them more efficient than virtual machines.  
    - **Portable**: Run your application anywhere, from your laptop to the cloud.

??? tips "Getting Started with Docker Installation"
    **1. Install Docker on Linux**
    ```bash
    # Update the package index
    sudo apt update

    # Install required packages
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add the Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y

    # Verify the installation
    docker --version
    ```

    #### **Install Docker on macOS**
    ??? note "Pre-requisites for macOS"
        - Docker requires macOS 10.14 or newer.
        - Ensure you have enough system resources for Docker Desktop.

    ```bash
    # Download Docker Desktop for Mac from the official site:
    https://www.docker.com/products/docker-desktop/

    # Install Docker by dragging it to the Applications folder.
    # Open Docker Desktop, and follow the setup instructions.
    ```

    #### **Docker on Windows**
    ??? info "Supported Windows Versions"
        Docker Desktop supports Windows 10 64-bit (Professional, Enterprise, and Education) and Windows 11.

    1. Download Docker Desktop from [Docker's official website](https://www.docker.com/products/docker-desktop).  
    2. Run the installer and follow the on-screen instructions.  
    3. After installation, verify it using the command:
        ```powershell
        docker --version
        ```

    ---

    📒 **Useful Tips**

    !!! tip "Enable Non-Root Docker Access on Linux"
        To run Docker commands without `sudo`, add your user to the Docker group:
        ```bash
        sudo usermod -aG docker $USER
        ```
        Log out and log back in for the changes to take effect.

    !!! warning "Docker Resource Limits"
        Containers share system resources with the host. Ensure you allocate sufficient CPU and memory for optimal performance.

    !!! note "Docker Desktop vs Docker Engine"
        - **Docker Desktop**: Includes GUI tools and is ideal for macOS and Windows.  
        - **Docker Engine**: A lightweight CLI-based version for Linux servers.

    ---

    ✅ **Verify Your Docker Installation**

    After installation, run a test container to verify Docker is working correctly:

    ```bash
    docker run hello-world
    ```

    If Docker is installed correctly, you should see the following output:
    ```plaintext
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    ```


---

## **Docker Command Cheat Sheet**

#### **Basic Commands**

- **Check Docker Version**  
  Verify the Docker installation and version:
  ```bash
  docker --version
  ```

- **List Docker Images**  
  View all images stored locally:
  ```bash
  docker images
  ```

- **List Running Containers**  
  Display currently running containers:
  ```bash
  docker ps
  ```

- **List All Containers (including stopped)**  
  Show both active and inactive containers:
  ```bash
  docker ps -a
  ```

- **Run a Container**  
  Start a new container:
  ```bash
  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
  ```

- **Stop a Running Container**  
  Gracefully stop a running container:
  ```bash
  docker stop CONTAINER_ID
  ```

- **Remove a Container**  
  Delete a stopped container:
  ```bash
  docker rm CONTAINER_ID
  ```

- **Remove an Image**  
  Delete a local image:
  ```bash
  docker rmi IMAGE_ID
  ```

---

### **Building Docker Images**

- **Build an Image from a Dockerfile**  
  Create a Docker image using a `Dockerfile`:
  ```bash
  docker build -t IMAGE_NAME:TAG PATH
  ```

- **Build an Image without Using Cache**  
  Force a fresh build without cache:
  ```bash
  docker build --no-cache -t IMAGE_NAME:TAG PATH
  ```

- **View Build History**  
  Check the layer history of an image:
  ```bash
  docker history IMAGE_NAME:TAG
  ```

---

### **Dockerfile Basics**

- **Basic Dockerfile Example**
  ```Dockerfile
  # Use a base image
  FROM ubuntu:latest

  # Set environment variables
  ENV MY_ENV_VAR=value

  # Install dependencies
  RUN apt-get update && apt-get install -y curl

  # Copy files into the image
  COPY ./local_file /container_file

  # Define the default command
  CMD ["echo", "Hello, Docker!"]
  ```

---

### **Networking and Volumes**

- **Create a Network**  
  Set up a custom Docker network:
  ```bash
  docker network create my_network
  ```

- **Run a Container on a Network**  
  Connect a container to a specific network:
  ```bash
  docker run --network my_network IMAGE_NAME
  ```

- **Create a Volume**  
  Create a persistent volume for data storage:
  ```bash
  docker volume create my_volume
  ```

- **Run a Container with a Volume**  
  Mount a volume to a container:
  ```bash
  docker run -v my_volume:/container_path IMAGE_NAME
  ```

---

### **Docker Compose**

- **Start Services**  
  Bring up services defined in a `docker-compose.yml`:
  ```bash
  docker-compose up
  ```

- **Start Services in Detached Mode**  
  Run services in the background:
  ```bash
  docker-compose up -d
  ```

- **Stop Services**  
  Shut down all services:
  ```bash
  docker-compose down
  ```

- **View Logs**  
  Check logs for all services:
  ```bash
  docker-compose logs
  ```

---

### **Pipeline Commands**

- **Push an Image to Docker Hub**  
  Upload an image to a Docker registry:
  ```bash
  docker push IMAGE_NAME:TAG
  ```

- **Pull an Image from Docker Hub**  
  Download an image from a registry:
  ```bash
  docker pull IMAGE_NAME:TAG
  ```

- **Tag an Image**  
  Add a new tag to an image:
  ```bash
  docker tag SOURCE_IMAGE:TAG TARGET_IMAGE:TAG
  ```

- **Login to Docker Hub**  
  Authenticate to push or pull images:
  ```bash
  docker login
  ```

---

## **Troubleshooting and Scenarios**

#### **Scenario 1: Container Not Starting**
- **Symptom:** You run a container, but it exits immediately.  
- **Solution:**
  Check the container logs:
  ```bash
  docker logs CONTAINER_ID
  ```
  Ensure the container’s command is valid and not exiting with errors.

??? info "Tip"
    Check the Dockerfile or the container command to see if it exits immediately due to a failure or invalid command. Adding `-it` flag for an interactive terminal can help debug.

---

#### **Scenario 2: Image Build Fails**
- **Symptom:** `docker build` fails with an error.  
- **Solution:**
  - Check the error message and fix syntax issues in your `Dockerfile`.  
  - Use `--no-cache` to bypass cached layers:
    ```bash
    docker build --no-cache -t IMAGE_NAME:TAG .
    ```

??? warning "Cache Issues"
    Sometimes, the Docker build cache can cause problems with outdated dependencies or commands. Use `--no-cache` to ensure a clean build.

---

#### **Scenario 3: Port Already in Use**
- **Symptom:** You get a `port already in use` error when running a container.  
- **Solution:**
  - Identify the process using the port:
    ```bash
    lsof -i :PORT
    ```
  - Stop the conflicting process or choose another port for the container:
    ```bash
    docker run -p NEW_PORT:CONTAINER_PORT IMAGE_NAME
    ```

??? note "Port Conflicts"
    Port conflicts occur when two processes try to bind to the same port. Use `docker ps` to list running containers and their ports.

---

#### **Scenario 4: Cannot Remove Container/Image**
- **Symptom:** `docker rm` or `docker rmi` fails with a "container/image in use" error.  
- **Solution:**
  - Stop all running containers:
    ```bash
    docker stop $(docker ps -q)
    ```
  - Force remove the container/image:
    ```bash
    docker rm -f CONTAINER_ID
    docker rmi -f IMAGE_ID
    ```

??? info "Force Remove"
    The `-f` flag forces the removal of containers or images that are in use or running.

---

