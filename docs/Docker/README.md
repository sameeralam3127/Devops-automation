
---

### **Docker Command Cheat Sheet**

#### **Basic Commands**

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

- **List All Containers (including stopped)**
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

#### **Building Docker Images**

- **Build an Image from a Dockerfile**
  ```bash
  docker build -t IMAGE_NAME:TAG PATH
  ```

- **Build an Image from a Dockerfile (No Cache)**
  ```bash
  docker build --no-cache -t IMAGE_NAME:TAG PATH
  ```

- **View Build History**
  ```bash
  docker history IMAGE_NAME:TAG
  ```

#### **Dockerfile Basics**

- **Basic Dockerfile Structure**
  ```Dockerfile
  # Use a base image
  FROM ubuntu:latest

  # Set environment variables
  ENV VAR_NAME=value

  # Install dependencies
  RUN apt-get update && apt-get install -y package

  # Add files to the image
  COPY local_path /container_path

  # Set the working directory
  WORKDIR /container_path

  # Define the command to run
  CMD ["executable", "param1", "param2"]
  ```

#### **Networking and Volumes**

- **Create a Network**
  ```bash
  docker network create NETWORK_NAME
  ```

- **Run a Container with a Network**
  ```bash
  docker run --network NETWORK_NAME IMAGE_NAME
  ```

- **Create a Volume**
  ```bash
  docker volume create VOLUME_NAME
  ```

- **Run a Container with a Volume**
  ```bash
  docker run -v VOLUME_NAME:/container_path IMAGE_NAME
  ```

#### **Docker Compose**

- **Start Services**
  ```bash
  docker-compose up
  ```

- **Start Services in Detached Mode**
  ```bash
  docker-compose up -d
  ```

- **Stop Services**
  ```bash
  docker-compose down
  ```

- **Build Services**
  ```bash
  docker-compose build
  ```

- **View Logs**
  ```bash
  docker-compose logs
  ```

#### **Pipeline Commands**

- **Push Image to Registry**
  ```bash
  docker push IMAGE_NAME:TAG
  ```

- **Pull Image from Registry**
  ```bash
  docker pull IMAGE_NAME:TAG
  ```

- **Tag an Image**
  ```bash
  docker tag SOURCE_IMAGE:TAG TARGET_IMAGE:TAG
  ```

- **Login to Docker Hub**
  ```bash
  docker login
  ```

- **Logout from Docker Hub**
  ```bash
  docker logout
  ```

---

