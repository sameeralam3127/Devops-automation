# Introduction to Ansible

## 1. **What is Ansible?**

Ansible is an open-source IT automation tool that allows you to automate provisioning, configuration management, application deployment, and orchestration.

- It uses simple YAML files (called **playbooks**) to define automation tasks.
- It is **agentless**, requiring only SSH access (or WinRM for Windows) to manage remote systems.

**Earlier approaches/tools used before Ansible:**

- Manual scripting with **Bash/Shell scripts** or **Python scripts**.
- Configuration management tools such as **Puppet** and **Chef**, which required agents and had steeper learning curves.
- Orchestration and provisioning tools like **Terraform** (still widely used, but focused more on infrastructure provisioning rather than configuration management).

!!! note
Ansible excels at configuration management, whereas Terraform is stronger for infrastructure provisioning.

---

## 2. **Core Concepts**

1. **Inventory** – A file listing the machines (hosts) you want to manage.
2. **Playbooks** – YAML files that define sets of tasks for execution.
3. **Modules** – Pre-built units of work (installing packages, copying files, managing services, etc.).
4. **Roles** – A structured way to organize playbooks and files for reuse.

---

## 3. **Configuration File**

Ansible can use a configuration file (`ansible.cfg`). It is loaded in the following order:

1. `ANSIBLE_CONFIG` (if set as an environment variable)
2. `ansible.cfg` (in the current directory)
3. `~/.ansible.cfg` (in the home directory)
4. `/etc/ansible/ansible.cfg`

!!! tip
Always create a project-level `ansible.cfg` to avoid conflicts with global settings.

---

## 4. **Installing Ansible**

- **Using pip (Python package manager):**

  ```bash
  pip install ansible
  ```

- **On Ubuntu/Debian:**

  ```bash
  sudo apt update
  sudo apt install ansible
  ```

- **On macOS (Homebrew):**

  ```bash
  brew install ansible
  ```

- **On Windows (via WSL):**
  Install Ansible inside Ubuntu/Debian WSL using the steps above.

**Verify installation:**

```bash
ansible --version
```

!!! warning
Do not mix OS package installs (apt, brew) with pip installs on the same machine to avoid version conflicts.

---

## 5. **Working with Inventory**

Create a file named `hosts.ini`:

```ini
[webservers]
192.168.1.10
192.168.1.11

[databases]
db1.example.com
```

List hosts:

```bash
ansible all --list-hosts
```

---

## 6. **Running Ad-Hoc Commands**

- Ping all hosts:

  ```bash
  ansible all -m ping
  ansible all -m ping -vvv
  ```

- Run commands with password prompt:

  ```bash
  ansible web -m command -a "uptime" -k
  ansible web -m command -a "yum install httpd* -y" -k
  ```

- Copy and fetch files:

  ```bash
  ansible all -m copy -a "src=/etc/passwd dest=/tmp"
  ansible all -m fetch -a "src=/var/log/yum.log dest=/logs"
  ```

- File management:

  ```bash
  ansible all -m file -a "path=/tmp/india mode=777"
  ansible all -m file -a "path=/tmp/india state=absent"
  ```

- Run shell scripts:

  ```bash
  ansible all -m shell -a "sh /tmp/scripts.sh"
  ```

---

## 7. **Writing Your First Playbook**

`playbook.yml`:

```yaml
---
- name: Install Apache on webservers
  hosts: webservers
  become: yes
  tasks:
    - name: Ensure Apache is installed
      apt:
        name: apache2
        state: present
      when: ansible_os_family == "Debian"
```

Run it:

```bash
ansible-playbook -i hosts.ini playbook.yml
```

---

## 8. **Gathering Facts**

Ansible automatically collects system information (facts):

```bash
ansible all -m setup
ansible all -m setup -a "filter=ansible_python_version"
```

---

## 9. **Verbose Mode**

- `-v` basic verbose
- `-vv` more details
- `-vvv` debug level (SSH, facts, module arguments)

---

## 10. **Disabling Host Key Checking**

```bash
export ANSIBLE_HOST_KEY_CHECKING=False
```

Or update `ansible.cfg`:

```ini
[defaults]
host_key_checking = False
```

---

## 11. **Troubleshooting Common Issues**

- **Python Interpreter Issue:**
  Some hosts may not have Python installed or use a different version. Define interpreter in inventory:

  ```ini
  [webservers]
  192.168.1.10 ansible_python_interpreter=/usr/bin/python3
  ```

- **SSH Key Authentication (Passwordless):**

  ```bash
  ssh-keygen
  ssh-copy-id user@host
  ```

- **Connection Problems:**
  Use `ansible -vvv` for detailed debugging.

!!! note
Always verify SSH connectivity manually before using Ansible.

---

## 12. **Advanced Usage**

- **Modules:** Explore with:

  ```bash
  ansible-doc -l
  ansible-doc copy
  ```

- **Packages:**

  ```bash
  ansible all -m package -a "name=httpd state=present"
  ansible all -m package -a "name=samba* state=latest use=yum"
  ```

---

## 13. **Roles**

Organize reusable playbooks:

- `tasks/`
- `handlers/`
- `templates/`
- `files/`
- `vars/` / `defaults/`

---

## 14. **Automation Tower (AWX/Ansible Tower)**

- A web-based UI and REST API to manage playbooks.
- Provides RBAC, job scheduling, logging, and notifications.
- AWX is the open-source upstream project of Ansible Tower.

---

## 15. **Terraform vs Ansible**

- **Terraform:** Best for provisioning and managing infrastructure as code (e.g., creating servers, networks, cloud resources).
- **Ansible:** Best for configuration management, application deployment, and post-provisioning tasks.
- They are often used together: Terraform provisions, Ansible configures.

!!! tip
Use Terraform to build infrastructure, then hand off to Ansible for configuration and deployment.

---

## 16. **Community and Learning Resources**

- **Official Documentation:** [Ansible Docs](https://docs.ansible.com/)
- **Ansible Galaxy:** A hub for finding and sharing community-developed roles.
- **Community:** Forums, GitHub repositories, and mailing lists.
- **Practice Ideas:**

  - Automate a web server deployment.
  - Configure a database.
  - Deploy a multi-tier app with roles.

---

!!! success
**Recommendation:** Use virtual machines, WSL, or cloud instances to practice Ansible playbooks.
**Next step:** Start with simple ad-hoc commands, then move to playbooks and roles for real automation.

---

# Troubleshooting, Roles, and Advanced Details

## 1. **Troubleshooting and Environment Variables**

## Environment Variables vs. Config File Precedence

- **Environment variables** (e.g., `export ANSIBLE_CONFIG=/custom/path/ansible.cfg`) take **highest precedence**.
- **Config file settings** (e.g., `ansible.cfg`) are overridden by environment variables.
- Order of precedence (highest to lowest):
  1. Command-line flags (e.g., `--private-key`)
  2. Environment variables (e.g., `ANSIBLE_PRIVATE_KEY_FILE`)
  3. Config file settings
  4. Default values

## Common Troubleshooting Tips

1. **SSH Connection Issues**:

   ```bash
   # Test SSH connectivity manually first:
   ssh user@target-host

   # Enable verbose Ansible output:
   ansible -i inventory.ini all -m ping -vvv
   ```

2. **Python Interpreter Errors**:

   ```ini
   # In inventory.ini, specify Python path:
   [webservers]
   web1 ansible_host=192.168.1.10 ansible_python_interpreter=/usr/bin/python3
   ```

3. **Permission Denied**:
   Use `--become` (`-b`) to escalate privileges:

   ```bash
   ansible -i inventory.ini all -m package -a "name=nginx" --become
   ```

4. **Debug Modules**:
   Use the `debug` module to print variables:
   ```yaml
   - name: Display variables
     debug:
       var: my_variable
   ```

---

## 2. **Creating Roles Simplified**

## Step-by-Step Role Creation

1. **Generate role structure**:

   ```bash
   ansible-galaxy role init my_role
   ```

   Creates:

   ```
   my_role/
   ├── defaults/    # Low-priority variables
   ├── tasks/       # Main tasks
   ├── handlers/    # Handlers
   ├── templates/   # Jinja2 templates
   ├── files/       # Static files
   ├── vars/        # High-priority variables
   └── meta/        # Role dependencies
   ```

2. **Add tasks** (`tasks/main.yml`):

   ```yaml
   - name: Install Nginx
     apt:
       name: nginx
       state: present
     notify: restart nginx
   ```

3. **Add handlers** (`handlers/main.yml`):

   ```yaml
   - name: restart nginx
     service:
       name: nginx
       state: restarted
   ```

4. **Use the role in a playbook**:
   ```yaml
   - hosts: webservers
     roles:
       - my_role
   ```

---

## 3. **Group Variables, Inventory, and Host Variables**

## Dynamic Inventory

Use dynamic inventories for cloud providers (AWS, Azure):

```bash
ansible-inventory -i aws_ec2.yml --list
```

## Group Variables

1. **Directory structure**:

   ```
   inventory/
   ├── group_vars/
   │   ├── webservers.yml
   │   └── databases.yml
   └── hosts.ini
   ```

2. **Define group variables** (`group_vars/webservers.yml`):
   ```yaml
   ---
   http_port: 80
   ntp_servers: [0.pool.ntp.org, 1.pool.ntp.org]
   ```

## Host Variables

1. **In inventory file**:

   ```ini
   [webservers]
   web1 ansible_host=192.168.1.10 http_port=8080
   ```

2. **In `host_vars/` directory**:
   ```
   inventory/
   ├── host_vars/
   │   └── web1.yml
   ```
   `web1.yml`:
   ```yaml
   ---
   http_port: 8080
   ```

---

## 4. **Advanced Configuration Details**

## Custom Config File

Create a project-specific `ansible.cfg`:

```ini
[defaults]
inventory = ./inventory/hosts.ini
roles_path = ./roles
retry_files_enabled = False
host_key_checking = False

[privilege_escalation]
become = True
become_method = sudo
become_user = root
```

## Vault for Secrets

Encrypt sensitive data:

```bash
ansible-vault create secrets.yml
ansible-playbook site.yml --ask-vault-pass
```

---

## 5. **Example: Full Project Structure**

```
my_ansible_project/
├── ansible.cfg
├── inventory/
│   ├── hosts.ini
│   ├── group_vars/
│   │   └── webservers.yml
│   └── host_vars/
│       └── web1.yml
├── roles/
│   └── nginx/
│       ├── tasks/
│       ├── handlers/
│       └── templates/
└── playbooks/
    └── deploy.yml
```

---

## 6. **Quick Command Reference**

```bash
# Test connectivity
ansible all -m ping

# Run a playbook with custom inventory
ansible-playbook -i inventory/custom.ini playbook.yml

# Dry-run (check changes)
ansible-playbook playbook.yml --check

# Limit to specific hosts
ansible-playbook playbook.yml --limit webservers

# Use vault
ansible-playbook playbook.yml --vault-id @prompt
```

---

## 7. **Best Practices**

1. Use `ansible-lint` to validate playbooks.
2. Version control all Ansible content.
3. Use `--check` mode before applying changes.
4. Document variables and roles with `README.md`.

By following this guide, you’ll streamline your Ansible workflows, avoid common pitfalls, and create reusable, maintainable automation code!
