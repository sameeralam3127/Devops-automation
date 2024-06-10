Bash script that automates the installation of Jenkins, sets up Java, enables and starts the Jenkins service, and configures the firewall on an Ubuntu system. 
It also retrieves and prints the initial Jenkins password and the IP address along with the port number.

```bash
#!/bin/bash

# Function to print messages
print_message() {
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

# Update system
print_message "Updating system packages..."
sudo apt-get update -y

# Install Java
print_message "Installing OpenJDK 17..."
sudo apt-get install -y fontconfig openjdk-17-jre

# Verify Java installation
print_message "Verifying Java installation..."
java -version

# Add Jenkins key and repository
print_message "Adding Jenkins repository and key..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update system again
print_message "Updating system packages again..."
sudo apt-get update -y

# Install Jenkins
print_message "Installing Jenkins..."
sudo apt-get install -y jenkins

# Enable Jenkins service
print_message "Enabling Jenkins service..."
sudo systemctl enable jenkins

# Start Jenkins service
print_message "Starting Jenkins service..."
sudo systemctl start jenkins

# Check Jenkins service status
print_message "Checking Jenkins service status..."
sudo systemctl status jenkins

# Configure firewall
print_message "Configuring firewall to allow Jenkins..."
sudo ufw allow 8080
sudo ufw enable

# Print IP address and port
print_message "Printing IP address and port..."
IP_ADDRESS=$(hostname -I | awk '{print $1}')
PORT=8080
echo "Jenkins is running on http://$IP_ADDRESS:$PORT"

# Retrieve and print the Jenkins initial password
print_message "Retrieving Jenkins initial admin password..."
INITIAL_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "Initial Admin Password: $INITIAL_PASSWORD"

print_message "Jenkins installation and setup completed successfully!"
```

To use this script:

1. Save the script to a file, for example, `install_jenkins.sh`.
2. Make the script executable: `chmod +x install_jenkins.sh`
3. Run the script with sudo privileges: `sudo ./install_jenkins.sh`

