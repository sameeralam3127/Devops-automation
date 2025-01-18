# Jenkins Installation and First Pipeline Setup on Ubuntu

???info "Mastering Jenkins: Installing on Ubuntu and Creating Your First Pipeline"
    Jenkins is an open-source automation server that helps with continuous integration and continuous delivery (CI/CD). This guide will walk you through the process of installing Jenkins on Ubuntu, checking system details using a Bash script, and creating your first pipeline using Jenkins' powerful pipeline functionality.

---

## **Step 1: Installing Jenkins on Ubuntu**

Before we begin, ensure your system is up-to-date.

### **1.1 Update System Packages**

First, update your system’s package list to ensure everything is up to date:

```bash
sudo apt update && sudo apt upgrade -y
```

### **1.2 Install Java**

Jenkins requires Java to run. Install the default Java Development Kit (JDK):

```bash
sudo apt install openjdk-11-jdk -y
```

To verify the installation, use:

```bash
java -version
```

### **1.3 Add Jenkins Repository**

To install Jenkins, add its official repository to your system:

```bash
wget -q -O - https://pkg.jenkins.io/jenkins.io.key | sudo tee /etc/apt/trusted.gpg.d/jenkins.asc
```

Next, add the Jenkins repository:

```bash
sudo sh -c 'echo deb http://pkg.jenkins.io/debian/ stable main > /etc/apt/sources.list.d/jenkins.list'
```

### **1.4 Install Jenkins**

Once the repository is added, update the package list and install Jenkins:

```bash
sudo apt update
sudo apt install jenkins -y
```

### **1.5 Start Jenkins**

Enable and start the Jenkins service:

```bash
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

You can check the status of Jenkins:

```bash
sudo systemctl status jenkins
```

---

## **Step 2: Accessing Jenkins**

Jenkins will be running on port 8080 by default. Open your browser and navigate to:

```
http://localhost:8080
```

### **2.1 Unlock Jenkins**

To unlock Jenkins, you will need the `initialAdminPassword`. Retrieve it with the following command:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Enter the password in the browser prompt.

### **2.2 Install Suggested Plugins**

Once you’ve unlocked Jenkins, you'll be prompted to install plugins. Choose the "Install suggested plugins" option to proceed with the default plugin installation.

---

## **Step 3: Creating Your First Jenkins Pipeline**

### **3.1 Create a New Pipeline Project**

1. After logging into Jenkins, click on **New Item**.
2. Enter a name for your pipeline (e.g., "First-Pipeline").
3. Select **Pipeline** and click **OK**.

### **3.2 Configure the Pipeline**

In the pipeline configuration page, scroll down to the **Pipeline** section. Here, you'll define your pipeline script. For this guide, we’ll use a simple pipeline that checks system details using a Bash script.

```groovy
pipeline {
    agent any

    stages {
        stage('Check System Details') {
            steps {
                script {
                    sh 'bash check_system_details.sh'
                }
            }
        }
    }
}
```

### **3.3 Create a Bash Script**

In your Jenkins workspace, create a script called `check_system_details.sh`. This script will gather system information.

```bash
#!/bin/bash

echo "System Information:"
echo "--------------------"
hostnamectl
echo
df -h
echo
free -h
echo
uname -a
```

Ensure that the script has executable permissions:

```bash
chmod +x check_system_details.sh
```

### **3.4 Run the Pipeline**

Save the pipeline and click **Build Now** to execute the pipeline. Jenkins will run the `check_system_details.sh` script, and you should see the system details in the build log.

---
