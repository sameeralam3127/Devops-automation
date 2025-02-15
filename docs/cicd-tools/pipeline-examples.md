**Monitoring Tools: Grafana & Prometheus**

### **Grafana**
- **What it is:** An open-source platform for monitoring and observability, primarily used for visualizing metrics from various data sources.
- **Learning Steps:**
  - **Installation & Setup:** Start by installing Grafana on a local machine or server. The [Grafana Documentation](https://grafana.com/docs/grafana/latest/) is a great resource.
  - **Dashboard Creation:** Learn how to create and customize dashboards.
  - **Integrations:** Understand how to add data sources like Prometheus.
  - **Alerting:** Explore how Grafana can send alerts based on dashboard metrics.

### **Prometheus**
- **What it is:** An open-source systems monitoring and alerting toolkit, which collects and stores metrics as time series data.
- **Learning Steps:**
  - **Architecture Basics:** Understand how Prometheus scrapes metrics, how exporters work, and how to configure jobs.
  - **Installation & Setup:** Follow the [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/) for a step-by-step guide.
  - **Querying:** Learn the PromQL language to query your metrics.
  - **Integration:** See how to integrate Prometheus with Grafana to visualize collected data.

---

## 2. **Linux Commands for Log Management**

As an SRE, you’ll frequently work with logs. Here are some key commands:

- **Viewing Logs:**
  - `tail -f /var/log/syslog` or `tail -f /var/log/messages`: Follow logs in real time.
  - `cat /var/log/syslog`: Display the entire log file.
  - `less /var/log/syslog`: View logs page by page.
- **Searching Within Logs:**
  - `grep "error" /var/log/syslog`: Search for specific keywords.
  - `journalctl -u servicename`: View logs for a specific service (for systems using `systemd`).
- **Log Rotation & Management:** Familiarize yourself with tools like `logrotate` for managing log file sizes and retention.

---

## 3. **Creating a Shell Script to Gather Logs & System Details**

Below is an example shell script that collects basic system logs and details. Customize the file paths as per your system (e.g., `/var/log/syslog` vs. `/var/log/messages`).

```bash
#!/bin/bash
# A simple script to collect logs and system details

# Define a directory to store the collected logs
OUTPUT_DIR="/tmp/system_logs_$(date +'%Y%m%d_%H%M%S')"
mkdir -p "$OUTPUT_DIR"

echo "Collecting logs and system details..."

# 1. Collect System Logs
if [ -f /var/log/syslog ]; then
    cp /var/log/syslog "$OUTPUT_DIR/"
elif [ -f /var/log/messages ]; then
    cp /var/log/messages "$OUTPUT_DIR/"
else
    echo "No standard log file found."
fi

# 2. Collect System Information
{
  echo "=== Uptime ==="
  uptime
  
  echo -e "\n=== Disk Usage ==="
  df -h
  
  echo -e "\n=== Memory Usage ==="
  free -h
  
  echo -e "\n=== Top 10 Processes by Memory Usage ==="
  ps aux --sort=-%mem | head -n 10
} > "$OUTPUT_DIR/system_info.txt"

echo "Data collection complete. Check the output in: $OUTPUT_DIR"
```

### **Script Explanation:**
- **Directory Setup:** The script creates a unique directory in `/tmp` to store logs and details.
- **Log Collection:** It checks for common log files (`syslog` or `messages`) and copies them.
- **System Details:** It collects uptime, disk usage, memory usage, and the top 10 memory-consuming processes.
- **Usage:** Save the script as `collect_info.sh`, make it executable with `chmod +x collect_info.sh`, and run it using `./collect_info.sh`.

---

