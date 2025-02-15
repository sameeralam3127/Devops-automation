## What Is a Shell Script?

A **shell script** is a plain text file containing a series of commands that are executed by the shell (the command-line interpreter). Shell scripts help automate repetitive tasks, manage system operations, and perform batch processing. The most common shell on Linux systems is **Bash** (Bourne Again SHell).

## Why Use Shell Scripts?

- **Automation:** Streamline routine tasks.
- **Efficiency:** Execute multiple commands with a single script.
- **System Administration:** Manage files, processes, and system operations.
- **Batch Processing:** Process data or files in bulk.

## Basic Syntax and Concepts

### 1. The Shebang Line
Every shell script typically starts with a **shebang** that tells the system which interpreter to use:
```bash
#!/bin/bash
```

### 2. Comments
Use `#` to add comments. Anything following `#` on a line is ignored by the interpreter:
```bash
# This is a comment
```

### 3. Variables
Variables store data that can be used later in the script. Do not include spaces around the equals sign:
```bash
name="Alice"
echo "Hello, $name"
```

### 4. Command Substitution
Capture the output of a command and store it in a variable:
```bash
current_date=$(date)
echo "Today is $current_date"
```

### 5. Conditionals
Use `if`, `elif`, and `else` to execute commands based on conditions:
```bash
if [ condition ]; then
    # commands
elif [ another_condition ]; then
    # commands
else
    # commands
fi
```

### 6. Loops

- **For Loop:**
  ```bash
  for i in {1..5}; do
      echo "Number: $i"
  done
  ```

- **While Loop:**
  ```bash
  count=1
  while [ $count -le 5 ]; do
      echo "Count: $count"
      ((count++))
  done
  ```

### 7. Functions
Define a reusable block of code:
```bash
greet() {
    echo "Hello, $1!"
}
greet "Bob"
```

### 8. Running a Shell Script
1. Save your script (e.g., `myscript.sh`).
2. Make it executable:
   ```bash
   chmod +x myscript.sh
   ```
3. Run it:
   ```bash
   ./myscript.sh
   ```

---

## 10 Practical Shell Script Examples

### 1. Hello World Script
```bash
#!/bin/bash
# This script prints "Hello, World!"
echo "Hello, World!"
```
*Explanation*: A simple script that uses `echo` to print a greeting message.

---

### 2. Script with Variables
```bash
#!/bin/bash
# Demonstrating variables in shell scripts
greeting="Hello"
name="Alice"
echo "$greeting, $name!"
```
*Explanation*: Assigns values to variables and then prints them.

---

### 3. Arithmetic Operations
```bash
#!/bin/bash
# Performing arithmetic operations
a=5
b=3
sum=$((a + b))
echo "Sum of $a and $b is: $sum"
```
*Explanation*: Uses arithmetic expansion to calculate the sum of two numbers.

---

### 4. User Input Script
```bash
#!/bin/bash
# Reading user input
echo "Enter your name: "
read name
echo "Hello, $name!"
```
*Explanation*: Prompts the user to enter their name and then prints a personalized greeting.

---

### 5. Conditional Statement Example
```bash
#!/bin/bash
# Checking if a file exists
file="example.txt"
if [ -e "$file" ]; then
    echo "$file exists."
else
    echo "$file does not exist."
fi
```
*Explanation*: Uses an `if` statement to check whether a file exists.

---

### 6. For Loop Example
```bash
#!/bin/bash
# Iterating over a sequence with a for loop
for i in {1..5}; do
    echo "Number: $i"
done
```
*Explanation*: Loops through numbers 1 to 5 and prints each one.

---

### 7. While Loop Example
```bash
#!/bin/bash
# Using a while loop to count from 1 to 5
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done
```
*Explanation*: Increments a counter and prints its value until the condition is met.

---

### 8. Functions in Shell Scripts
```bash
#!/bin/bash
# Defining and calling a function
greet() {
    echo "Hello, $1!"
}
greet "Bob"
```
*Explanation*: Demonstrates how to declare a function and call it with an argument.

---

### 9. Command Line Arguments
```bash
#!/bin/bash
# Using command line arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided."
else
    echo "You provided $# arguments: $@"
fi
```
*Explanation*: Checks if any command-line arguments were passed and displays them.

---

### 10. Case Statement Example
```bash
#!/bin/bash
# Using a case statement for simple menu selection
echo "Enter a number between 1 and 3: "
read num
case $num in
    1)
        echo "You entered one." ;;
    2)
        echo "You entered two." ;;
    3)
        echo "You entered three." ;;
    *)
        echo "Invalid number." ;;
esac
```
*Explanation*: Uses a `case` statement to execute different commands based on user input.

---

# SSL Certificate Installation
```bash
#!/bin/bash

# Function to check if the OS is RHEL or Debian-based
detect_os() {
    if [ -f /etc/redhat-release ]; then
        OS="RHEL"
    elif [ -f /etc/debian_version ]; then
        OS="Debian"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

# Function to check and install Certbot
install_certbot() {
    echo "Checking if Certbot is installed..."
    
    if command -v certbot &> /dev/null; then
        echo "Certbot is already installed."
        return
    fi

    echo "Certbot not found. Installing Certbot..."
    
    if [ "$OS" == "Debian" ]; then
        apt-get update
        apt-get install -y certbot
    elif [ "$OS" == "RHEL" ]; then
        yum install -y epel-release
        yum install -y certbot
    else
        echo "Unsupported OS for Certbot installation"
        exit 1
    fi
}

# Function to check the existing SSL certificate details
check_existing_ssl() {
    echo "Checking existing SSL certificates for HTTPD and NGINX..."
    
    for config_file in /etc/httpd/conf.d/ssl.conf /etc/nginx/nginx.conf; do
        if [ -f "$config_file" ]; then
            echo "SSL Configuration found in: $config_file"
            ssl_cert=$(grep -i "SSLCertificateFile\|ssl_certificate" $config_file | awk '{print $2}')
            if [ -f "$ssl_cert" ]; then
                echo "SSL Certificate Details:"
                openssl x509 -in $ssl_cert -noout -text | grep -E 'Issuer:|Subject:|Not After :'
            else
                echo "SSL Certificate not found in the specified location: $ssl_cert"
            fi
        else
            echo "SSL configuration file not found for $config_file"
        fi
    done
}

# Function to create a private key and CSR
create_key_and_csr() {
    echo "Creating Private Key and CSR..."
    mkdir -p /certs

    read -p "Enter Country (2 letter code): " country
    read -p "Enter State or Province Name: " state
    read -p "Enter Locality Name (e.g., city): " locality
    read -p "Enter Organization Name: " organization
    read -p "Enter Organizational Unit Name: " unit
    read -p "Enter Common Name (e.g., domain name): " common_name
    read -p "Enter Email Address: " email

    if [ -z "$common_name" ]; then
        echo "Error: Common Name (domain) is required."
        exit 1
    fi

    openssl req -newkey rsa:2048 -nodes -keyout /certs/mydomain.key -out /certs/mydomain.csr -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$unit/CN=$common_name/emailAddress=$email"
    if [ $? -ne 0 ]; then
        echo "Error creating CSR"
        exit 1
    fi
    echo "Private key and CSR created successfully."
}

# Function to obtain a certificate using Let's Encrypt
create_ssl_certificate() {
    echo "Generating SSL certificate using Let's Encrypt..."
    
    install_certbot
    
    certbot certonly --standalone --non-interactive --agree-tos --email $email -d $common_name
    if [ $? -ne 0 ]; then
        echo "Error generating SSL certificate"
        exit 1
    fi
    echo "SSL certificate generated successfully."
}

# Function to move certificate and key to correct locations for HTTPD and NGINX
install_certificate() {
    echo "Installing SSL certificate for HTTPD and NGINX..."
    mkdir -p /etc/httpd/ssl /etc/nginx/ssl

    mv /etc/letsencrypt/live/$common_name/fullchain.pem /etc/httpd/ssl/mydomain.crt
    mv /etc/letsencrypt/live/$common_name/privkey.pem /etc/httpd/ssl/mydomain.key
    mv /etc/letsencrypt/live/$common_name/fullchain.pem /etc/nginx/ssl/mydomain.crt
    mv /etc/letsencrypt/live/$common_name/privkey.pem /etc/nginx/ssl/mydomain.key

    # Set permissions
    chmod 600 /etc/httpd/ssl/mydomain.key
    chown root:root /etc/httpd/ssl/mydomain.key
    chmod 644 /etc/httpd/ssl/mydomain.crt
    chown root:root /etc/httpd/ssl/mydomain.crt
    chmod 600 /etc/nginx/ssl/mydomain.key
    chown root:root /etc/nginx/ssl/mydomain.key
    chmod 644 /etc/nginx/ssl/mydomain.crt
    chown root:root /etc/nginx/ssl/mydomain.crt

    # Update HTTPD conf
    if grep -q "SSLCertificateFile" /etc/httpd/conf.d/ssl.conf; then
        sed -i "s#SSLCertificateFile .*#SSLCertificateFile /etc/httpd/ssl/mydomain.crt#" /etc/httpd/conf.d/ssl.conf
        sed -i "s#SSLCertificateKeyFile .*#SSLCertificateKeyFile /etc/httpd/ssl/mydomain.key#" /etc/httpd/conf.d/ssl.conf
    else
        echo "SSLCertificateFile /etc/httpd/ssl/mydomain.crt" >> /etc/httpd/conf.d/ssl.conf
        echo "SSLCertificateKeyFile /etc/httpd/ssl/mydomain.key" >> /etc/httpd/conf.d/ssl.conf
    fi

    # Update NGINX conf
    if grep -q "ssl_certificate" /etc/nginx/nginx.conf; then
        sed -i "s#ssl_certificate .*#ssl_certificate /etc/nginx/ssl/mydomain.crt;#" /etc/nginx/nginx.conf
        sed -i "s#ssl_certificate_key .*#ssl_certificate_key /etc/nginx/ssl/mydomain.key;#" /etc/nginx/nginx.conf
    else
        echo "ssl_certificate /etc/nginx/ssl/mydomain.crt;" >> /etc/nginx/nginx.conf
        echo "ssl_certificate_key /etc/nginx/ssl/mydomain.key;" >> /etc/nginx/nginx.conf
    fi

    systemctl restart httpd nginx

    if [ $? -ne 0 ]; then
        echo "Error restarting services. Checking logs..."
        if [ "$OS" == "RHEL" ]; then
            cat /var/log/httpd/error_log /var/log/nginx/error.log
        else
            cat /var/log/apache2/error.log /var/log/nginx/error.log
        fi
        exit 1
    fi

    echo "SSL Certificate installed and services restarted successfully."
}

# Function to renew SSL certificate
renew_certificate() {
    echo "Renewing SSL certificate..."
    certbot renew
    if [ $? -ne 0 ]; then
        echo "Error renewing SSL certificate."
        exit 1
    fi
    install_certificate
}

# Function to validate HTTPS connection
validate_https() {
    echo "Validating HTTPS connection on port 443..."
    curl -Is https://$common_name:443 | head -n 1
    if [ $? -ne 0 ]; then
        echo "Error: Unable to connect to $common_name on port 443."
        exit 1
    fi
    echo "HTTPS validation successful."
}

# Menu-driven interface
while true; do
    echo "SSL Certificate Management Script"
    echo "1. Check Existing SSL Certificate"
    echo "2. Create Key and CSR"
    echo "3. Generate SSL Certificate (Let's Encrypt)"
    echo "4. Install Certificate"
    echo "5. Renew SSL Certificate"
    echo "6. Validate HTTPS Connection"
    echo "7. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1) check_existing_ssl ;;
        2) create_key_and_csr ;;
        3) create_ssl_certificate ;;
        4) install_certificate ;;
        5) renew_certificate ;;
        6) validate_https ;;
        7) echo "Exiting..."; exit ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done
```
