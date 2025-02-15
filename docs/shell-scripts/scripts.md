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



---

### 1. HTTP Service Health Check
```bash
#!/bin/bash
# Script 1: HTTP Service Health Check
# Checks an HTTP endpoint and logs if the service is down.

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

---

### 2. Disk Usage Monitor
```bash
#!/bin/bash
# Script 2: Disk Usage Monitor
# Monitors disk usage on a given partition and logs if usage exceeds a threshold.

THRESHOLD=80
PARTITION="/"
LOG_FILE="/var/log/disk_usage.log"

usage=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$usage" -ge "$THRESHOLD" ]; then
  echo "$(date): Disk usage on $PARTITION is ${usage}%." >> "$LOG_FILE"
fi
```

---

### 3. Memory Usage Monitor
```bash
#!/bin/bash
# Script 3: Memory Usage Monitor
# Checks available memory and logs if free memory drops below a threshold.

THRESHOLD=500  # in MB
LOG_FILE="/var/log/memory_usage.log"

free_mem=$(free -m | awk '/^Mem:/{print $7}')
if [ "$free_mem" -lt "$THRESHOLD" ]; then
  echo "$(date): Low memory: ${free_mem}MB available." >> "$LOG_FILE"
fi
```

---

### 4. CPU Load Monitor
```bash
#!/bin/bash
# Script 4: CPU Load Monitor
# Monitors the 1-minute load average and logs if it exceeds a threshold.

THRESHOLD=2.0
LOG_FILE="/var/log/cpu_load.log"

load_avg=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')
if (( $(echo "$load_avg > $THRESHOLD" | bc -l) )); then
  echo "$(date): High load average detected: $load_avg" >> "$LOG_FILE"
fi
```

---

### 5. Process Monitor
```bash
#!/bin/bash
# Script 5: Process Monitor
# Checks if a specific process is running; logs if it’s not found.

PROCESS_NAME="nginx"
LOG_FILE="/var/log/process_monitor.log"

if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
  echo "$(date): Process $PROCESS_NAME not found." >> "$LOG_FILE"
fi
```

---

### 6. Service Auto-Restart
```bash
#!/bin/bash
# Script 6: Service Auto-Restart
# Checks a systemd service and attempts a restart if it’s not active, then logs the result.

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

---

### 7. Log File Error Monitor
```bash
#!/bin/bash
# Script 7: Log File Error Monitor
# Scans a log file for error patterns and logs any errors found.

LOG_FILE="/var/log/application.log"
OUTPUT_LOG="/var/log/error_monitor.log"
PATTERN="ERROR"

if grep -q "$PATTERN" "$LOG_FILE"; then
  echo "$(date): Errors found in $LOG_FILE:" >> "$OUTPUT_LOG"
  grep "$PATTERN" "$LOG_FILE" >> "$OUTPUT_LOG"
fi
```

---

### 8. SSL Certificate Expiry Checker
```bash
#!/bin/bash
# Script 8: SSL Certificate Expiry Checker
# Checks the expiration date of an SSL certificate and logs if expiry is near.

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
else
  echo "$(date): SSL certificate for $DOMAIN is valid for $days_left more days." >> "$LOG_FILE"
fi
```

---

### 9. Configuration Backup with Rotation
```bash
#!/bin/bash
# Script 9: Configuration Backup with Rotation
# Creates a compressed backup of /etc and rotates backups older than 7 days.

BACKUP_DIR="/backups/config"
SOURCE_DIR="/etc"
DATE=$(date +%F)
BACKUP_FILE="${BACKUP_DIR}/config_backup_${DATE}.tar.gz"

mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"
find "$BACKUP_DIR" -type f -mtime +7 -exec rm {} \;
echo "$(date): Backup created: $BACKUP_FILE"
```

---

### 10. Docker Container Monitor
```bash
#!/bin/bash
# Script 10: Docker Container Monitor
# Checks if critical Docker containers are running and attempts a restart if not, then logs the result.

containers=("webapp" "db")
LOG_FILE="/var/log/docker_monitor.log"

for container in "${containers[@]}"; do
  if ! docker ps --format '{{.Names}}' | grep -wq "$container"; then
    echo "$(date): Container $container is down. Attempting restart..." >> "$LOG_FILE"
    docker start "$container"
    if ! docker ps --format '{{.Names}}' | grep -wq "$container"; then
      echo "$(date): Failed to restart container $container." >> "$LOG_FILE"
    else
      echo "$(date): Container $container restarted successfully." >> "$LOG_FILE"
    fi
  fi
done
```

---

### 11. System Update Automation
```bash
#!/bin/bash
# Script 11: System Update Automation
# Updates system packages (Debian/Ubuntu) and logs the output.

LOG_FILE="/var/log/system_update.log"
{
  echo "----- $(date) -----"
  apt update && apt upgrade -y
  echo "Update complete."
} >> "$LOG_FILE" 2>&1
```

---

### 12. Network Connectivity Checker
```bash
#!/bin/bash
# Script 12: Network Connectivity Checker
# Pings a list of remote hosts and logs if any are unreachable.

HOSTS=("8.8.8.8" "1.1.1.1")
LOG_FILE="/var/log/network_connectivity.log"

for host in "${HOSTS[@]}"; do
  if ! ping -c 2 "$host" &>/dev/null; then
    echo "$(date): Host $host is unreachable." >> "$LOG_FILE"
  fi
done
```

---

### 13. Temporary File Cleaner
```bash
#!/bin/bash
# Script 13: Temporary File Cleaner
# Removes files from /tmp older than 7 days.

find /tmp -type f -mtime +7 -exec rm -f {} \;
echo "$(date): Cleaned temporary files older than 7 days."
```

---

### 14. Open File Descriptor Monitor
```bash
#!/bin/bash
# Script 14: Open File Descriptor Monitor
# Logs if the number of open file descriptors exceeds a threshold.

THRESHOLD=1000
LOG_FILE="/var/log/fd_monitor.log"
fd_count=$(lsof | wc -l)

if [ "$fd_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High file descriptor count: $fd_count" >> "$LOG_FILE"
fi
```

---

### 15. Combined System Resource Monitor
```bash
#!/bin/bash
# Script 15: Combined System Resource Monitor
# Checks CPU, memory, and disk usage and logs if any exceed thresholds.

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

---

### 16. Active SSH Sessions Monitor
```bash
#!/bin/bash
# Script 16: Active SSH Sessions Monitor
# Counts active SSH sessions and logs if they exceed a threshold.

THRESHOLD=5
LOG_FILE="/var/log/ssh_sessions.log"
session_count=$(who | grep -c 'pts/')

if [ "$session_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High number of SSH sessions: $session_count" >> "$LOG_FILE"
fi
```

---

### 17. System Uptime Logger
```bash
#!/bin/bash
# Script 17: System Uptime Logger
# Logs the system uptime to a file.

LOG_FILE="/var/log/uptime.log"
echo "$(date): Uptime - $(uptime)" >> "$LOG_FILE"
```

---

### 18. System Temperature Monitor
```bash
#!/bin/bash
# Script 18: System Temperature Monitor
# Uses the sensors command to monitor CPU temperature and logs if too high.

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

---

### 19. Log Rotation and Archiving
```bash
#!/bin/bash
# Script 19: Log Rotation and Archiving
# Rotates a log file by compressing the current log and starting a new one.

LOG_FILE="/var/log/myapp.log"
ARCHIVE_DIR="/var/log/archive"
mkdir -p "$ARCHIVE_DIR"
DATE=$(date +%F)
mv "$LOG_FILE" "$ARCHIVE_DIR/myapp.log.$DATE"
gzip "$ARCHIVE_DIR/myapp.log.$DATE"
touch "$LOG_FILE"
echo "$(date): Rotated log file."
```

---

### 20. Database Connection Monitor
```bash
#!/bin/bash
# Script 20: Database Connection Monitor
# Checks if a MySQL database is reachable and logs if not.

DB_HOST="localhost"
DB_USER="root"
DB_PASS="password"
LOG_FILE="/var/log/db_connection.log"

if ! mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" --silent; then
  echo "$(date): Cannot reach MySQL on $DB_HOST." >> "$LOG_FILE"
fi
```

---

### 21. Database Query Health Check
```bash
#!/bin/bash
# Script 21: Database Query Health Check
# Runs a simple query against a MySQL database and logs the result.

DB_HOST="localhost"
DB_USER="root"
DB_PASS="password"
DB_NAME="testdb"
LOG_FILE="/var/log/db_query.log"

result=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SELECT 1;" 2>&1)
echo "$(date): Query result: $result" >> "$LOG_FILE"
```

---

### 22. Kafka Topic Monitor
```bash
#!/bin/bash
# Script 22: Kafka Topic Monitor
# Checks if a Kafka topic exists and logs if it is missing.

TOPIC="important_topic"
KAFKA_BIN="/usr/bin/kafka-topics.sh"
LOG_FILE="/var/log/kafka_monitor.log"

if ! "$KAFKA_BIN" --list --zookeeper localhost:2181 | grep -qw "$TOPIC"; then
  echo "$(date): Kafka topic $TOPIC not found." >> "$LOG_FILE"
fi
```

---

### 23. Network Port Usage Monitor
```bash
#!/bin/bash
# Script 23: Network Port Usage Monitor
# Checks if a critical port is in use and logs if it’s not.

CRITICAL_PORT=80
LOG_FILE="/var/log/port_usage.log"

if ! netstat -tuln | grep -q ":$CRITICAL_PORT "; then
  echo "$(date): Critical port $CRITICAL_PORT is not in use." >> "$LOG_FILE"
fi
```

---

### 24. Firewall Status Checker
```bash
#!/bin/bash
# Script 24: Firewall Status Checker
# Checks if UFW is active and logs if it isn’t.

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

---

### 25. Disk IOPS and Latency Monitor
```bash
#!/bin/bash
# Script 25: Disk IOPS and Latency Monitor
# Uses iostat to monitor disk IOPS and latency; logs if thresholds are exceeded.

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

---

### 26. Prometheus Metrics Pusher
```bash
#!/bin/bash
# Script 26: Prometheus Metrics Pusher
# Pushes a custom metric (load average) to a Prometheus pushgateway.

PUSHGATEWAY="http://localhost:9091"
JOB_NAME="sre_metrics"
METRIC_VALUE=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')
echo "load_average $METRIC_VALUE" | curl --data-binary @- "$PUSHGATEWAY/metrics/job/$JOB_NAME"
```

---

### 27. SSL Certificate Chain Checker
```bash
#!/bin/bash
# Script 27: SSL Certificate Chain Checker
# Validates the SSL certificate chain for a given domain and logs if retrieval fails.

DOMAIN="example.com"
LOG_FILE="/var/log/ssl_chain.log"
chain=$(echo | openssl s_client -showcerts -servername "$DOMAIN" -connect "$DOMAIN":443 2>/dev/null)
if [[ -z "$chain" ]]; then
  echo "$(date): Failed to retrieve certificate chain for $DOMAIN." >> "$LOG_FILE"
fi
```

---

### 28. Filesystem Mount Checker
```bash
#!/bin/bash
# Script 28: Filesystem Mount Checker
# Verifies that a specific filesystem is mounted and logs if it is not.

FS="/mnt/data"
LOG_FILE="/var/log/mount_check.log"

if ! mount | grep -q "$FS"; then
  echo "$(date): Filesystem $FS is not mounted." >> "$LOG_FILE"
fi
```

---

### 29. RAID Status Monitor
```bash
#!/bin/bash
# Script 29: RAID Status Monitor
# Checks the status of a RAID array managed by mdadm and logs if it is not healthy.

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

---

### 30. Swap Usage Monitor
```bash
#!/bin/bash
# Script 30: Swap Usage Monitor
# Checks swap usage and logs if usage exceeds a threshold percentage.

THRESHOLD=50  # percentage
LOG_FILE="/var/log/swap_usage.log"
swap_usage=$(free | awk '/Swap/ {print $3/$2 * 100.0}')
if (( $(echo "$swap_usage > $THRESHOLD" | bc -l) )); then
  echo "$(date): High swap usage: $swap_usage%" >> "$LOG_FILE"
fi
```

---

### 31. Boot Time Logger
```bash
#!/bin/bash
# Script 31: Boot Time Logger
# Logs the system boot time to a file.

LOG_FILE="/var/log/boot_time.log"
boot_time=$(who -b | awk '{print $3, $4}')
echo "$(date): Boot time - $boot_time" >> "$LOG_FILE"
```

---

### 32. Process Count Monitor
```bash
#!/bin/bash
# Script 32: Process Count Monitor
# Monitors the total number of processes and logs if it exceeds a threshold.

THRESHOLD=300
LOG_FILE="/var/log/process_count.log"
process_count=$(ps aux | wc -l)
if [ "$process_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High process count: $process_count" >> "$LOG_FILE"
fi
```

---

### 33. Load Average Alert
```bash
#!/bin/bash
# Script 33: Load Average Alert
# Logs if the 1-minute load average is above a specified threshold.

THRESHOLD=3.0
LOG_FILE="/var/log/load_average.log"
load_avg=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')
if (( $(echo "$load_avg > $THRESHOLD" | bc -l) )); then
  echo "$(date): Load average high: $load_avg" >> "$LOG_FILE"
fi
```

---

### 34. DNS Resolution Tester
```bash
#!/bin/bash
# Script 34: DNS Resolution Tester
# Tests DNS resolution for a list of domains and logs any failures.

DOMAINS=("example.com" "google.com")
LOG_FILE="/var/log/dns_resolution.log"

for domain in "${DOMAINS[@]}"; do
  if ! nslookup "$domain" &>/dev/null; then
    echo "$(date): DNS resolution failed for $domain" >> "$LOG_FILE"
  fi
done
```

---

### 35. Active Network Connections Monitor
```bash
#!/bin/bash
# Script 35: Active Network Connections Monitor
# Monitors the number of established network connections and logs if high.

THRESHOLD=100
LOG_FILE="/var/log/network_connections.log"
conn_count=$(netstat -an | grep ESTABLISHED | wc -l)
if [ "$conn_count" -gt "$THRESHOLD" ]; then
  echo "$(date): High number of active connections: $conn_count" >> "$LOG_FILE"
fi
```

---

### 36. Package Update Checker (Debian)
```bash
#!/bin/bash
# Script 36: Package Update Checker (Debian)
# Checks for available package updates and logs the output.

LOG_FILE="/var/log/package_update.log"
apt update > /dev/null 2>&1
updates=$(apt list --upgradable 2>/dev/null | grep -v "Listing...")
echo "$(date): Available updates:" >> "$LOG_FILE"
echo "$updates" >> "$LOG_FILE"
```

---

### 37. NTP Synchronization Checker
```bash
#!/bin/bash
# Script 37: NTP Synchronization Checker
# Checks if NTP is synchronized and logs if it is not.

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

---

### 38. Virtualization Host Metrics
```bash
#!/bin/bash
# Script 38: Virtualization Host Metrics
# Logs basic metrics if the system is running as a virtualization host.

LOG_FILE="/var/log/virt_metrics.log"
if grep -qi hypervisor /proc/cpuinfo; then
  echo "$(date): Running on a virtualization host." >> "$LOG_FILE"
  top -b -n1 | head -n 10 >> "$LOG_FILE"
fi
```

---

### 39. Hardware Error Monitor
```bash
#!/bin/bash
# Script 39: Hardware Error Monitor
# Monitors dmesg for hardware errors and logs if any are detected.

LOG_FILE="/var/log/hardware_errors.log"
if dmesg | grep -i -E "error|fail" &>/dev/null; then
  echo "$(date): Hardware errors detected." >> "$LOG_FILE"
fi
```

---

### 40. Synthetic Transaction Script
```bash
#!/bin/bash
# Script 40: Synthetic Transaction Script
# Simulates a user transaction by performing an HTTP request and logs the response code.

URL="http://localhost:8080/api/transaction"
LOG_FILE="/var/log/synthetic_transaction.log"

response=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
if [ "$response" -ne 200 ]; then
  echo "$(date): Synthetic transaction failed with code $response" >> "$LOG_FILE"
else
  echo "$(date): Synthetic transaction succeeded." >> "$LOG_FILE"
fi
```

---

### 41. System Metrics Collector
```bash
#!/bin/bash
# Script 41: System Metrics Collector
# Collects system metrics using vmstat and logs the output.

LOG_FILE="/var/log/vmstat.log"
vmstat 1 5 >> "$LOG_FILE"
```

---

### 42. Swap Usage Over Time Monitor
```bash
#!/bin/bash
# Script 42: Swap Usage Over Time Monitor
# Logs swap usage periodically for trend analysis.

LOG_FILE="/var/log/swap_usage_trend.log"
swap_used=$(free -m | awk '/Swap/ {print $3}')
echo "$(date): Swap used: ${swap_used}MB" >> "$LOG_FILE"
```

---

### 43. I/O Wait Monitor
```bash
#!/bin/bash
# Script 43: I/O Wait Monitor
# Checks I/O wait time using vmstat and logs if it exceeds a threshold.

THRESHOLD=20
LOG_FILE="/var/log/iowait.log"
iowait=$(vmstat 1 2 | tail -1 | awk '{print $15}')
if [ "$iowait" -gt "$THRESHOLD" ]; then
  echo "$(date): High I/O wait: ${iowait}%" >> "$LOG_FILE"
fi
```

---

### 44. Controlled Failover Test
```bash
#!/bin/bash
# Script 44: Controlled Failover Test
# Simulates a service failure by stopping and then restarting a dummy service, logging the outcome.

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

---

### 45. Backup Cleanup Script
```bash
#!/bin/bash
# Script 45: Backup Cleanup Script
# Removes backup files older than 30 days from the backup directory.

BACKUP_DIR="/backups"
find "$BACKUP_DIR" -type f -mtime +30 -exec rm {} \;
echo "$(date): Cleaned up backups older than 30 days."
```

---

### 46. Network Latency and Jitter Monitor
```bash
#!/bin/bash
# Script 46: Network Latency and Jitter Monitor
# Measures ping latency and jitter for multiple endpoints and logs the results.

ENDPOINTS=("8.8.8.8" "1.1.1.1")
LOG_FILE="/var/log/network_latency.log"
for host in "${ENDPOINTS[@]}"; do
  result=$(ping -c 5 "$host" | tail -1 | awk -F'/' '{print "Latency: "$5", Jitter: "$6}')
  echo "$(date): $host - $result" >> "$LOG_FILE"
done
```

---

### 47. Cron Job Health Monitor
```bash
#!/bin/bash
# Script 47: Cron Job Health Monitor
# Checks if critical cron jobs have run by searching for log entries and logs if missing.

CRON_LOG="/var/log/cron.log"
KEYWORD="daily_backup"
LOG_FILE="/var/log/cron_monitor.log"
if ! grep -q "$KEYWORD" "$CRON_LOG"; then
  echo "$(date): Cron job $KEYWORD did not run." >> "$LOG_FILE"
fi
```

---

### 48. Service Dependency Checker
```bash
#!/bin/bash
# Script 48: Service Dependency Checker
# Verifies that required dependencies (e.g., a Redis port) for a service are available, and logs if not.

SERVICE="myapp"
DEPENDENCY_PORT=6379  # Example: Redis
LOG_FILE="/var/log/dependency_check.log"

if ! netstat -tuln | grep -q ":$DEPENDENCY_PORT "; then
  echo "$(date): Dependency on port $DEPENDENCY_PORT not met for $SERVICE." >> "$LOG_FILE"
fi
```

---

### 49. Environment Variable Checker
```bash
#!/bin/bash
# Script 49: Environment Variable Checker
# Checks that essential environment variables are set for an application and logs if any are missing.

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

---

### 50. Custom Alerting Aggregator
```bash
#!/bin/bash
# Script 50: Custom Alerting Aggregator
# Aggregates multiple health checks and logs a summary if issues are detected.

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

---


