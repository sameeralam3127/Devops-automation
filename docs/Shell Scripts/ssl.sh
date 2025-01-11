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