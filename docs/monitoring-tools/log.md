
**Monitoring is a crucial part of DevOps**, helping teams detect issues before they become critical. In this guide, we will install **Prometheus, Grafana, and Node Exporter** using **Podman**, an alternative to Docker. By the end, you'll have a fully functional monitoring stack with visual dashboards to analyze system metrics.  

---

## **What Are Prometheus, Grafana, and Node Exporter?**  

### **1. Prometheus: The Time-Series Database**  
Prometheus is an open-source monitoring system that collects and stores metrics as **time-series data**. It is widely used in DevOps due to its powerful querying language (**PromQL**) and easy integration with multiple exporters.  

📌 **Key Features:**  
- Time-series data storage  
- Pull-based metric collection  
- Alerting and rule-based evaluations  

### **2. Node Exporter: The System Metrics Collector**  
Node Exporter is a lightweight agent that runs on a machine to collect system metrics such as CPU usage, memory utilization, disk I/O, and network statistics.  

📌 **Common Metrics Collected:**  
- **CPU Load:** `node_cpu_seconds_total`  
- **Memory Usage:** `node_memory_MemAvailable_bytes`  
- **Disk Space:** `node_filesystem_avail_bytes`  
- **Network Traffic:** `node_network_receive_bytes_total`  

### **3. Grafana: The Visualization Tool**  
Grafana is an open-source tool that helps visualize and analyze time-series data. It allows you to create dashboards with real-time graphs, alerts, and reports.  

📌 **Why Use Grafana?**  
- Connects to multiple data sources (Prometheus, MySQL, AWS CloudWatch, etc.)  
- Beautiful and interactive dashboards  
- Custom alerts and notifications  

---

# **Step 1: Install and Run Containers**  

We will use **Podman**, a rootless container runtime similar to Docker, to set up our monitoring stack.

## **1.1 Pull and Run a CentOS Container**  
We'll start by running a CentOS container where we will install Node Exporter.

```bash
podman run -dit --name centos_container -p 9100:9100 centos:latest
```

Verify that the container is running:

```bash
podman ps
```

## **1.2 Run Prometheus**  
Now, let's run Prometheus, which will scrape metrics from Node Exporter.

```bash
podman run -d --name prometheus -p 9090:9090 quay.io/prometheus/prometheus
```

Check if Prometheus is running properly:

```bash
podman logs prometheus
```

You can now access Prometheus at:  
👉 **http://localhost:9090/query**

To enter the Prometheus container:

```bash
podman exec -it prometheus /bin/sh
```

---

# **Step 2: Install and Run Node Exporter**  

Log into the CentOS container:

```bash
podman exec -it centos_container /bin/bash
```

Download and extract Node Exporter:

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.0/node_exporter-1.9.0.linux-386.tar.gz
tar -xvf node_exporter-1.9.0.linux-386.tar.gz
cd node_exporter-1.9.0.linux-386
./node_exporter
```

Now, you can check the collected metrics at:  
👉 **http://localhost:9100/metrics**

---

# **Step 3: Configure Prometheus to Scrape Node Exporter Metrics**  

Modify the **Prometheus configuration file** (`prometheus.yml`):  

```bash
cd /etc/prometheus
vim prometheus.yml
```

Add the following configuration:

```yaml
global:
  scrape_interval: 15s # Collect metrics every 15 seconds

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "centos_node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
```

Restart Prometheus:

```bash
podman restart prometheus
```

Check if Prometheus is scraping Node Exporter:  
👉 **http://localhost:9090/targets**

---

# **Step 4: Deploy Grafana**  

Run the Grafana container:

```bash
podman run -d --name grafana -p 3000:3000 grafana/grafana
```

Get the IP address of Prometheus:

```bash
podman inspect -f '{{ .NetworkSettings.IPAddress }}' prometheus
```

Access Grafana at:  
👉 **http://localhost:3000**  

📌 **Default Login:**  
- **Username:** `admin`  
- **Password:** `admin` (change it on first login)  

---

# **Step 5: Add Prometheus as a Data Source in Grafana**  

1. Open **Grafana** (`http://localhost:3000`).  
2. Go to **Configuration > Data Sources**.  
3. Click **"Add Data Source"**, select **Prometheus**.  
4. Set the URL as **`http://prometheus:9090`**.  
5. Click **"Save & Test"**.  

---

# **Step 6: Import Node Exporter Dashboard**  

1. In Grafana, go to **"Create" > "Import"**.  
2. Enter the **Dashboard ID**: `1860` (or search for "Node Exporter Full").  
3. Select **Prometheus** as the data source.  
4. Click **"Import"**.  

You should now see a **full system monitoring dashboard**! 🎉  

---

# **Step 7: Managing Containers**  

To stop and remove containers:

```bash
podman stop centos_container
podman rm centos_container
```

Restart Prometheus and Grafana:

```bash
podman restart prometheus
podman restart grafana
```

---
