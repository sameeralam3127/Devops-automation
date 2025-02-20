# Shell Scripts for SRE and DevOps Engineers
!!! note "Definition"
    A **shell script** is a plain text file containing a series of commands executed by the shell (the command-line interpreter). Shell scripts help automate repetitive tasks, manage system operations, and perform batch processing. The most common shell on Linux systems is **Bash** (Bourne Again SHell).<br>
    **Advantages**

      - **Automation:** Streamline routine tasks.
      - **Efficiency:** Execute multiple commands with a single script.
      - **System Administration:** Manage files, processes, and system operations.
      - **Batch Processing:** Process data or files in bulk.


### Shebang Line
```bash
#!/bin/bash
```
!!! tip "Tip"
    The shebang tells the system which interpreter (here, Bash) to use for executing the script.

### Comments
```bash
# This is a comment
```
!!! note "Note"
    Use comments to explain your code. Anything after `#` is ignored by the interpreter.

### Variables
```bash
name="Alice"
echo "Hello, $name"
```
!!! tip "Tip"
    Variables store data. Remember: do not leave spaces around the equals sign.

### Command Substitution
```bash
current_date=$(date)
echo "Today is $current_date"
```
!!! note "Note"
    Use command substitution to capture the output of commands into a variable.

### Conditionals
```bash
if [ condition ]; then
    # commands
elif [ another_condition ]; then
    # commands
else
    # commands
fi
```
!!! tip "Tip"
    Conditionals allow your script to take different actions based on specific conditions.

### Loops

#### For Loop
```bash
for i in {1..5}; do
    echo "Number: $i"
done
```
!!! note "Note"
    Iterate through a list or sequence with a for loop.

#### While Loop
```bash
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done
```
!!! tip "Tip"
    A while loop runs as long as the condition is true.

### Functions
```bash
greet() {
    echo "Hello, $1!"
}
greet "Bob"
```
!!! note "Note"
    Functions let you reuse code. Pass parameters to functions for flexibility.

---

## Practical Script Examples

Below are some practical examples that illustrate key concepts.

### 1. Hello World Script
```bash
#!/bin/bash
echo "Hello, World!"
```
!!! tip "Explanation"
    A simple script to print "Hello, World!" to the console.

### 2. Disk Usage Monitor 📊
```bash
#!/bin/bash
THRESHOLD=80
PARTITION="/"
LOG_FILE="/var/log/disk_usage.log"

usage=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$usage" -ge "$THRESHOLD" ]; then
  echo "$(date): Disk usage on $PARTITION is ${usage}%." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    This script checks if the disk usage exceeds 80% and logs a message.

### 3. Memory Usage Monitor 💾
```bash
#!/bin/bash
THRESHOLD=500  # in MB
LOG_FILE="/var/log/memory_usage.log"

free_mem=$(free -m | awk '/^Mem:/{print $7}')
if [ "$free_mem" -lt "$THRESHOLD" ]; then
  echo "$(date): Low memory: ${free_mem}MB available." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Monitors available memory and logs if it drops below the threshold.

### 4. Service Auto-Restart 🔄
```bash
#!/bin/bash
SERVICE="nginx"
LOG_FILE="/var/log/service_monitor.log"

if ! systemctl is-active --quiet "$SERVICE"; then
  echo "$(date): $SERVICE is down. Attempting restart..." >> "$LOG_FILE"
  systemctl restart "$SERVICE"
  if systemctl is-active --quiet "$SERVICE"; then
    echo "$(date): $SERVICE restarted successfully." >> "$LOG_FILE"
  else
    echo "$(date): Failed to restart $SERVICE." >> "$LOG_FILE"
  fi
fi
```
!!! note "Explanation"
    Checks if a service (nginx) is active and attempts a restart if it isn’t.

### 5. Network Connectivity Checker 🌐
```bash
#!/bin/bash
HOSTS=("8.8.8.8" "1.1.1.1")
LOG_FILE="/var/log/network_connectivity.log"

for host in "${HOSTS[@]}"; do
  if ! ping -c 2 "$host" &>/dev/null; then
    echo "$(date): Host $host is unreachable." >> "$LOG_FILE"
  fi
done
```
!!! tip "Explanation"
    Pings a list of hosts and logs unreachable ones.

### 6. SSL Certificate Expiry Checker 🔒
```bash
#!/bin/bash
DOMAIN="example.com"
EXP_THRESHOLD=30  # days
LOG_FILE="/var/log/ssl_expiry.log"

expiry_date=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN":443 2>/dev/null \
             | openssl x509 -noout -dates | grep 'notAfter' | cut -d= -f2)
expiry_seconds=$(date -d "$expiry_date" +%s)
current_seconds=$(date +%s)
days_left=$(( (expiry_seconds - current_seconds) / 86400 ))

if [ "$days_left" -le "$EXP_THRESHOLD" ]; then
  echo "$(date): SSL certificate for $DOMAIN expires in $days_left days." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Checks the expiration date of an SSL certificate and logs if it’s near expiry.

---

## SSL Certificate Installation

This section details an advanced script that automates SSL certificate tasks such as detection, installation, renewal, and HTTPS validation.

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
!!! note "Explanation"
    This multi-function script automates SSL certificate management with Certbot and OpenSSL. Follow the prompts to manage certificates.

---

## Monitoring & Automation Scripts

Below are 50+ scripts designed to monitor system resources, services, and perform various automated checks. Each script includes a code snippet and an explanation using MkDocs admonitions.

### 1. HTTP Service Health Check
```bash
#!/bin/bash
SERVICE_URL="http://localhost:8080/health"
TIMEOUT=5
LOG_FILE="/var/log/health_check.log"

response=$(curl -s --max-time $TIMEOUT -o /dev/null -w "%{http_code}" "$SERVICE_URL")
if [ "$response" -eq 200 ]; then
  echo "$(date): Service is up." >> "$LOG_FILE"
else
  echo "$(date): Service is down! HTTP code: $response" >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Checks an HTTP endpoint and logs the health status of the service.

---

### 2. Disk Usage Monitor
*(See the Practical Example above.)*

---

### 3. Memory Usage Monitor
*(See the Practical Example above.)*

---

### 4. CPU Load Monitor
```bash
#!/bin/bash
THRESHOLD=2.0
LOG_FILE="/var/log/cpu_load.log"

load_avg=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')
if (( $(echo "$load_avg > $THRESHOLD" | bc -l) )); then
  echo "$(date): High load average detected: $load_avg" >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Monitors the 1-minute load average and logs if it exceeds a threshold.

---

### 5. Process Monitor
```bash
#!/bin/bash
PROCESS_NAME="nginx"
LOG_FILE="/var/log/process_monitor.log"

if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
  echo "$(date): Process $PROCESS_NAME not found." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Checks if a specific process is running and logs if not.

---

### 6. Service Auto-Restart
*(See the Practical Example above.)*

---

### 7. Log File Error Monitor
```bash
#!/bin/bash
LOG_FILE="/var/log/application.log"
OUTPUT_LOG="/var/log/error_monitor.log"
PATTERN="ERROR"

if grep -q "$PATTERN" "$LOG_FILE"; then
  echo "$(date): Errors found in $LOG_FILE:" >> "$OUTPUT_LOG"
  grep "$PATTERN" "$LOG_FILE" >> "$OUTPUT_LOG"
fi
```
!!! tip "Explanation"
    Scans a log file for error patterns and logs any errors found.

---

### 8. SSL Certificate Expiry Checker
*(See the Practical Example above.)*

---

### 9. Configuration Backup with Rotation
```bash
#!/bin/bash
BACKUP_DIR="/backups/config"
SOURCE_DIR="/etc"
DATE=$(date +%F)
BACKUP_FILE="${BACKUP_DIR}/config_backup_${DATE}.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"
find "$BACKUP_DIR" -type f -mtime +7 -exec rm {} \;
echo "$(date): Backup created: $BACKUP_FILE"
```
!!! note "Explanation"
    Creates a compressed backup of the `/etc` directory and rotates backups older than 7 days.

---

### 10. Docker Container Monitor
*(See the Practical Example above.)*

---

### 11. System Update Automation
```bash
#!/bin/bash
LOG_FILE="/var/log/system_update.log"
{
  echo "----- $(date) -----"
  apt update && apt upgrade -y
  echo "Update complete."
} >> "$LOG_FILE" 2>&1
```
!!! tip "Explanation"
    Automates system package updates on Debian/Ubuntu and logs the output.

---

### 12. Network Connectivity Checker
*(See script 5 above for network checks.)*

---

### 13. Temporary File Cleaner
```bash
#!/bin/bash
find /tmp -type f -mtime +7 -exec rm -f {} \;
echo "$(date): Cleaned temporary files older than 7 days."
```
!!! note "Explanation"
    Removes files in `/tmp` that are older than 7 days.

---

### 14. Open File Descriptor Monitor
```bash
#!/bin/bash
THRESHOLD=1000
LOG_FILE="/var/log/fd_monitor.log"
fd_count=$(lsof | wc -l)

if [ "$fd_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High file descriptor count: $fd_count" >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Monitors the number of open file descriptors and logs if above threshold.

---

### 15. Combined System Resource Monitor
```bash
#!/bin/bash
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/resource_monitor.log"

cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
mem_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

alert=0
(( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )) && alert=1
(( $(echo "$mem_usage > $MEM_THRESHOLD" | bc -l) )) && alert=1
[ "$disk_usage" -gt "$DISK_THRESHOLD" ] && alert=1

if [ $alert -eq 1 ]; then
  echo "$(date): Resource Alert - CPU: ${cpu_usage}%, Memory: ${mem_usage}%, Disk: ${disk_usage}%" >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Checks CPU, memory, and disk usage; logs an alert if any exceed the thresholds.

---

### 16. Active SSH Sessions Monitor
```bash
#!/bin/bash
THRESHOLD=5
LOG_FILE="/var/log/ssh_sessions.log"
session_count=$(who | grep -c 'pts/')

if [ "$session_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High number of SSH sessions: $session_count" >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Monitors the count of active SSH sessions and logs if they exceed the defined threshold.

---

### 17. System Uptime Logger
```bash
#!/bin/bash
LOG_FILE="/var/log/uptime.log"
echo "$(date): Uptime - $(uptime)" >> "$LOG_FILE"
```
!!! note "Explanation"
    Logs the current system uptime.

---

### 18. System Temperature Monitor
```bash
#!/bin/bash
THRESHOLD=70
LOG_FILE="/var/log/temperature.log"

if command -v sensors &>/dev/null; then
  temp=$(sensors | awk '/^Package id 0:/ {print $4}' | tr -d '+°C')
  if (( $(echo "$temp > $THRESHOLD" | bc -l) )); then
    echo "$(date): High CPU temperature detected: $temp°C" >> "$LOG_FILE"
  fi
else
  echo "sensors command not found." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Uses the `sensors` command to check CPU temperature and logs if it’s too high.

---

### 19. Log Rotation and Archiving
```bash
#!/bin/bash
LOG_FILE="/var/log/myapp.log"
ARCHIVE_DIR="/var/log/archive"
mkdir -p "$ARCHIVE_DIR"
DATE=$(date +%F)
mv "$LOG_FILE" "$ARCHIVE_DIR/myapp.log.$DATE"
gzip "$ARCHIVE_DIR/myapp.log.$DATE"
touch "$LOG_FILE"
echo "$(date): Rotated log file."
```
!!! note "Explanation"
    Rotates a log file by compressing the old log and starting a new one.

---

### 20. Database Connection Monitor
```bash
#!/bin/bash
DB_HOST="localhost"
DB_USER="root"
DB_PASS="password"
LOG_FILE="/var/log/db_connection.log"

if ! mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" --silent; then
  echo "$(date): Cannot reach MySQL on $DB_HOST." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Checks if a MySQL database is reachable and logs if not.

---

### 21. Database Query Health Check
```bash
#!/bin/bash
DB_HOST="localhost"
DB_USER="root"
DB_PASS="password"
DB_NAME="testdb"
LOG_FILE="/var/log/db_query.log"

result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SELECT 1;" 2>&1)
echo "$(date): Query result: $result" >> "$LOG_FILE"
```
!!! note "Explanation"
    Runs a simple query against a MySQL database and logs the output.

---

### 22. Kafka Topic Monitor
```bash
#!/bin/bash
TOPIC="important_topic"
KAFKA_BIN="/usr/bin/kafka-topics.sh"
LOG_FILE="/var/log/kafka_monitor.log"

if ! "$KAFKA_BIN" --list --zookeeper localhost:2181 | grep -qw "$TOPIC"; then
  echo "$(date): Kafka topic $TOPIC not found." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Checks if a Kafka topic exists and logs if missing.

---

### 23. Network Port Usage Monitor
```bash
#!/bin/bash
CRITICAL_PORT=80
LOG_FILE="/var/log/port_usage.log"

if ! netstat -tuln | grep -q ":$CRITICAL_PORT "; then
  echo "$(date): Critical port $CRITICAL_PORT is not in use." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Verifies if a critical network port is in use.

---

### 24. Firewall Status Checker
```bash
#!/bin/bash
LOG_FILE="/var/log/firewall_status.log"

if command -v ufw &>/dev/null; then
  status=$(ufw status | head -n 1)
  if [[ "$status" != *"active"* ]]; then
    echo "$(date): UFW firewall is not active." >> "$LOG_FILE"
  fi
else
  echo "ufw not installed." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Checks if the UFW firewall is active and logs if not.

---

### 25. Disk IOPS and Latency Monitor
```bash
#!/bin/bash
THRESHOLD_IOPS=100
LOG_FILE="/var/log/disk_iops.log"

if command -v iostat &>/dev/null; then
  iops=$(iostat -dx 1 2 | awk 'NR==7 {print $4}')
  if (( $(echo "$iops > $THRESHOLD_IOPS" | bc -l) )); then
    echo "$(date): High IOPS detected: $iops" >> "$LOG_FILE"
  fi
else
  echo "iostat not found." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Monitors disk IOPS using `iostat` and logs when thresholds are exceeded.

---

### 26. Prometheus Metrics Pusher
```bash
#!/bin/bash
PUSHGATEWAY="http://localhost:9091"
JOB_NAME="sre_metrics"
METRIC_VALUE=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')
echo "load_average $METRIC_VALUE" | curl --data-binary @- "$PUSHGATEWAY/metrics/job/$JOB_NAME"
```
!!! tip "Explanation"
    Pushes a custom load average metric to a Prometheus pushgateway.

---

### 27. SSL Certificate Chain Checker
```bash
#!/bin/bash
DOMAIN="example.com"
LOG_FILE="/var/log/ssl_chain.log"
chain=$(echo | openssl s_client -showcerts -servername "$DOMAIN" -connect "$DOMAIN":443 2>/dev/null)
if [[ -z "$chain" ]]; then
  echo "$(date): Failed to retrieve certificate chain for $DOMAIN." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Validates the SSL certificate chain for a given domain.

---

### 28. Filesystem Mount Checker
```bash
#!/bin/bash
FS="/mnt/data"
LOG_FILE="/var/log/mount_check.log"

if ! mount | grep -q "$FS"; then
  echo "$(date): Filesystem $FS is not mounted." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Verifies that a specific filesystem is mounted and logs if it isn’t.

---

### 29. RAID Status Monitor
```bash
#!/bin/bash
LOG_FILE="/var/log/raid_status.log"
if command -v mdadm &>/dev/null; then
  status=$(mdadm --detail /dev/md0 | grep 'State :' | awk '{print $3}')
  if [[ "$status" != "clean" && "$status" != "active" ]]; then
    echo "$(date): RAID status is $status." >> "$LOG_FILE"
  fi
else
  echo "mdadm not installed." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Checks the health of a RAID array and logs if it isn’t healthy.

---

### 30. Swap Usage Monitor
```bash
#!/bin/bash
THRESHOLD=50  # percentage
LOG_FILE="/var/log/swap_usage.log"
swap_usage=$(free | awk '/Swap/ {print $3/$2 * 100.0}')
if (( $(echo "$swap_usage > $THRESHOLD" | bc -l) )); then
  echo "$(date): High swap usage: $swap_usage%" >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Monitors swap usage and logs if it exceeds a threshold percentage.

---

### 31. Boot Time Logger
```bash
#!/bin/bash
LOG_FILE="/var/log/boot_time.log"
boot_time=$(who -b | awk '{print $3, $4}')
echo "$(date): Boot time - $boot_time" >> "$LOG_FILE"
```
!!! note "Explanation"
    Logs the system boot time to a file.

---

### 32. Process Count Monitor
```bash
#!/bin/bash
THRESHOLD=300
LOG_FILE="/var/log/process_count.log"
process_count=$(ps aux | wc -l)
if [ "$process_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High process count: $process_count" >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Monitors the total number of processes and logs if the count is too high.

---

### 33. Load Average Alert
```bash
#!/bin/bash
THRESHOLD=3.0
LOG_FILE="/var/log/load_average.log"
load_avg=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')
if (( $(echo "$load_avg > $THRESHOLD" | bc -l) )); then
  echo "$(date): Load average high: $load_avg" >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Alerts if the 1-minute load average is above a specified threshold.

---

### 34. DNS Resolution Tester
```bash
#!/bin/bash
DOMAINS=("example.com" "google.com")
LOG_FILE="/var/log/dns_resolution.log"

for domain in "${DOMAINS[@]}"; do
  if ! nslookup "$domain" &>/dev/null; then
    echo "$(date): DNS resolution failed for $domain" >> "$LOG_FILE"
  fi
done
```
!!! tip "Explanation"
    Tests DNS resolution for a list of domains and logs any failures.

---

### 35. Active Network Connections Monitor
```bash
#!/bin/bash
THRESHOLD=100
LOG_FILE="/var/log/network_connections.log"
conn_count=$(netstat -an | grep ESTABLISHED | wc -l)
if [ "$conn_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High number of active connections: $conn_count" >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Monitors established network connections and logs if the count is high.

---

### 36. Package Update Checker (Debian)
```bash
#!/bin/bash
LOG_FILE="/var/log/package_update.log"
apt update > /dev/null 2>&1
updates=$(apt list --upgradable 2>/dev/null | grep -v "Listing...")
echo "$(date): Available updates:" >> "$LOG_FILE"
echo "$updates" >> "$LOG_FILE"
```
!!! tip "Explanation"
    Checks for available package updates on Debian/Ubuntu systems and logs them.

---

### 37. NTP Synchronization Checker
```bash
#!/bin/bash
LOG_FILE="/var/log/ntp_sync.log"
if command -v timedatectl &>/dev/null; then
  sync_status=$(timedatectl show -p NTPSynchronized --value)
  if [ "$sync_status" != "yes" ]; then
    echo "$(date): NTP is not synchronized." >> "$LOG_FILE"
  fi
else
  echo "timedatectl not found." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Verifies whether NTP is synchronized and logs if it isn’t.

---

### 38. Virtualization Host Metrics
```bash
#!/bin/bash
LOG_FILE="/var/log/virt_metrics.log"
if grep -qi hypervisor /proc/cpuinfo; then
  echo "$(date): Running on a virtualization host." >> "$LOG_FILE"
  top -b -n1 | head -n 10 >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Logs basic metrics if the system is a virtualization host.

---

### 39. Hardware Error Monitor
```bash
#!/bin/bash
LOG_FILE="/var/log/hardware_errors.log"
if dmesg | grep -i -E "error|fail" &>/dev/null; then
  echo "$(date): Hardware errors detected." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Monitors `dmesg` for hardware errors and logs if any are detected.

---

### 40. Synthetic Transaction Script
```bash
#!/bin/bash
URL="http://localhost:8080/api/transaction"
LOG_FILE="/var/log/synthetic_transaction.log"

response=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
if [ "$response" -ne 200 ]; then
  echo "$(date): Synthetic transaction failed with code $response" >> "$LOG_FILE"
else
  echo "$(date): Synthetic transaction succeeded." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Simulates a user transaction by performing an HTTP request and logging the response.

---

### 41. System Metrics Collector
```bash
#!/bin/bash
LOG_FILE="/var/log/vmstat.log"
vmstat 1 5 >> "$LOG_FILE"
```
!!! note "Explanation"
    Collects system metrics using `vmstat` and logs the output.

---

### 42. Swap Usage Over Time Monitor
```bash
#!/bin/bash
LOG_FILE="/var/log/swap_usage_trend.log"
swap_used=$(free -m | awk '/Swap/ {print $3}')
echo "$(date): Swap used: ${swap_used}MB" >> "$LOG_FILE"
```
!!! tip "Explanation"
    Logs the current swap usage for trend analysis.

---

### 43. I/O Wait Monitor
```bash
#!/bin/bash
THRESHOLD=20
LOG_FILE="/var/log/iowait.log"
iowait=$(vmstat 1 2 | tail -1 | awk '{print $15}')
if [ "$iowait" -gt "$THRESHOLD" ]; then
  echo "$(date): High I/O wait: ${iowait}%" >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Checks I/O wait time using `vmstat` and logs if above the threshold.

---

### 44. Controlled Failover Test
```bash
#!/bin/bash
SERVICE="dummy_service"
LOG_FILE="/var/log/failover_test.log"
systemctl stop "$SERVICE"
sleep 5
systemctl start "$SERVICE"
if systemctl is-active --quiet "$SERVICE"; then
  echo "$(date): Failover test successful for $SERVICE." >> "$LOG_FILE"
else
  echo "$(date): Failover test failed for $SERVICE." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Simulates a service failure by stopping and restarting a dummy service, then logs the outcome.

---

### 45. Backup Cleanup Script
```bash
#!/bin/bash
BACKUP_DIR="/backups"
find "$BACKUP_DIR" -type f -mtime +30 -exec rm {} \;
echo "$(date): Cleaned up backups older than 30 days."
```
!!! note "Explanation"
    Removes backup files older than 30 days from the specified directory.

---

### 46. Network Latency and Jitter Monitor
```bash
#!/bin/bash
ENDPOINTS=("8.8.8.8" "1.1.1.1")
LOG_FILE="/var/log/network_latency.log"
for host in "${ENDPOINTS[@]}"; do
  result=$(ping -c 5 "$host" | tail -1 | awk -F'/' '{print "Latency: "$5", Jitter: "$6}')
  echo "$(date): $host - $result" >> "$LOG_FILE"
done
```
!!! tip "Explanation"
    Measures ping latency and jitter for multiple endpoints and logs the results.

---

### 47. Cron Job Health Monitor
```bash
#!/bin/bash
CRON_LOG="/var/log/cron.log"
KEYWORD="daily_backup"
LOG_FILE="/var/log/cron_monitor.log"
if ! grep -q "$KEYWORD" "$CRON_LOG"; then
  echo "$(date): Cron job $KEYWORD did not run." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Checks if critical cron jobs have run by searching for log entries.

---

### 48. Service Dependency Checker
```bash
#!/bin/bash
SERVICE="myapp"
DEPENDENCY_PORT=6379  # Example: Redis
LOG_FILE="/var/log/dependency_check.log"

if ! netstat -tuln | grep -q ":$DEPENDENCY_PORT "; then
  echo "$(date): Dependency on port $DEPENDENCY_PORT not met for $SERVICE." >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Verifies that required dependencies (e.g., a Redis port) are available for a service.

---

### 49. Environment Variable Checker
```bash
#!/bin/bash
REQUIRED_VARS=("APP_ENV" "DB_HOST" "DB_USER")
LOG_FILE="/var/log/env_check.log"
missing=0

for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Environment variable $var is not set." >> "$LOG_FILE"
    missing=1
  fi
done

if [ $missing -eq 1 ]; then
  echo "$(date): One or more required environment variables are missing." >> "$LOG_FILE"
fi
```
!!! note "Explanation"
    Checks that essential environment variables are set and logs if any are missing.

---

### 50. Custom Alerting Aggregator
```bash
#!/bin/bash
LOG_FILE="/var/log/alert_summary.log"
: > "$LOG_FILE"

# Check nginx service
if ! systemctl is-active --quiet nginx; then
  echo "nginx service down" >> "$LOG_FILE"
fi

# Check disk usage
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$disk_usage" -gt 80 ]; then
  echo "Disk usage high: ${disk_usage}%" >> "$LOG_FILE"
fi

# Additional checks can be added here...

if [ -s "$LOG_FILE" ]; then
  echo "Alert summary generated at $(date):" >> "$LOG_FILE"
fi
```
!!! tip "Explanation"
    Aggregates multiple health checks and logs a summary if issues are detected.

---


