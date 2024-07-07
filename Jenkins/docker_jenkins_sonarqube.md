To set up Jenkins, SonarQube, and Nginx on an Ubuntu system using Docker and Docker Compose, you'll need to create a `Dockerfile` for each service (if necessary) and a `docker-compose.yml` file to manage and run all the services together. Below is a step-by-step guide to achieve this:

### Step 1: Install Docker and Docker Compose

First, ensure you have Docker and Docker Compose installed on your Ubuntu system.

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Step 2: Create Docker Compose File

Create a directory for your project and navigate to it:

```bash
mkdir jenkins-sonarqube-nginx
cd jenkins-sonarqube-nginx
```

Create a `docker-compose.yml` file in this directory with the following content:

```yaml
version: '3'

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home

  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    ports:
      - "9000:9000"
    environment:
      - SONARQUBE_JDBC_URL=jdbc:postgresql://db:5432/sonar
      - SONARQUBE_JDBC_USERNAME=sonar
      - SONARQUBE_JDBC_PASSWORD=sonar
    depends_on:
      - db

  db:
    image: postgres:latest
    container_name: db
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
      - POSTGRES_DB=sonar
    volumes:
      - db_data:/var/lib/postgresql/data

  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf

volumes:
  jenkins_home:
  db_data:
```

### Step 3: Configure Nginx

Create an `nginx.conf` file in the same directory with the following content to reverse proxy to Jenkins and SonarQube:

```nginx
worker_processes 1;

events { worker_connections 1024; }

http {
    sendfile on;

    upstream jenkins {
        server jenkins:8080;
    }

    upstream sonarqube {
        server sonarqube:9000;
    }

    server {
        listen 80;

        location /jenkins/ {
            proxy_pass http://jenkins/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_redirect http://jenkins/ /jenkins/;
        }

        location /sonarqube/ {
            proxy_pass http://sonarqube/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_redirect http://sonarqube/ /sonarqube/;
        }
    }
}
```

### Step 4: Start the Services

Now, start the services using Docker Compose:

```bash
sudo docker-compose up -d
```

This will start Jenkins on port 8080, SonarQube on port 9000, and Nginx on port 80. You can access Jenkins at `http://<your_server_ip>/jenkins/` and SonarQube at `http://<your_server_ip>/sonarqube/`.

### Step 5: Configure Jenkins and SonarQube

- Access Jenkins at `http://<your_server_ip>/jenkins/` and follow the initial setup instructions.
- Access SonarQube at `http://<your_server_ip>/sonarqube/` and follow the initial setup instructions.

### Optional: Persistent Data

If you want to persist Jenkins and PostgreSQL data across container restarts, the `volumes` configuration in the `docker-compose.yml` file takes care of that.

That's it! You have successfully set up Jenkins, SonarQube, and Nginx using Docker and Docker Compose on an Ubuntu system.
