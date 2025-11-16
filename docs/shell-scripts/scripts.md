# [Shell Scripts for SRE and DevOps]()

Shell scripts are programs written for command-line interpreters (shells) that automate system tasks and operations. They combine sequences of commands into reusable scripts that can be executed as single units.

They are widely used by **SRE (Site Reliability Engineers)** and **DevOps engineers** to automate operations, reduce manual effort, and standardize workflows.

---

## Historical Context and Evolution

Shell scripting originated in the early Unix systems (1970s) with the Bourne shell (`sh`). Over time, more feature-rich shells emerged:

- **Bash** (Bourne Again Shell): Default on most Linux distributions
- **Zsh**: Extended features with better user interaction
- **Ksh**: AIX default shell with advanced scripting capabilities

---

## Why Shell Scripts Are Important for SRE and DevOps

!!! tip
Shell scripts remain a **core tool for SRE and DevOps**.
\- They are **simple**: use plain Linux commands.
\- They are **powerful**: integrate system utilities, APIs, and services.
\- They are **universal**: available by default on nearly every Unix/Linux system.
\- They allow **conditions, loops, functions, and modularity** to make tasks reusable.

Examples of usage:

- Daily health checks
- Disk and memory monitoring
- Service management
- Deployment pipelines
- Cron-based automation

---

## Shell Interpreter and Location

- The interpreter is the program that executes shell scripts.
- Common locations:

```bash
/bin/sh
/bin/bash
/usr/bin/zsh
```

- **Default interpreter**: `/bin/bash` in most Linux systems.
- **Speed**: Shell scripts are slower than compiled languages (C, Go), but fast enough for automation.

!!! note
Always define interpreter at the top of scripts with **shebang**:
`bash     #!/bin/bash
    `

---

## Core Components of Shell Scripts

## Shebang Directive

```bash
#!/bin/bash
#!/bin/sh     # POSIX-compliant
#!/usr/bin/zsh
#!/usr/bin/env bash  # Portable
```

## Comments and Documentation

```bash
# Single-line comment

: '
Multi-line comment
'

<<EOF
Here-document style comment
EOF
```

## Variables and Data Types

```bash
NAME="value"          # String
COUNT=42              # Integer
FILES=(*.txt)         # Array
readonly CONST=100    # Constant
export GLOBAL_VAR     # Env variable
```

## Special Variables

```bash
$0    # Script name
$1    # First argument
$#    # Number of args
$@    # All arguments
$?    # Exit status
$$    # PID
$!    # Background PID
```

---

## How to Write Shell Scripts

## 1. Conditions

```bash
if [ -f /etc/passwd ]; then
  echo "File exists"
else
  echo "File missing"
fi
```

## 2. Loops

```bash
for i in {1..5}; do
  echo "Iteration $i"
done
```

## 3. Functions

```bash
greet() { echo "Hello $1"; }
greet "Admin"
```

## 4. Case (Switch)

```bash
case $1 in
  start) echo "Starting service" ;;
  stop)  echo "Stopping service" ;;
  *)     echo "Usage: $0 {start|stop}" ;;
esac
```

## 5. Modular Scripts

```bash
source ./utils.sh
say_hello "DevOps"
```

---

## Advanced Scripting Techniques

## Parameter Expansion

```bash
${VAR:-default}    # Use default if unset
${VAR:=default}    # Set default if unset
${#VAR}            # Length
${VAR#pattern}     # Remove prefix
${VAR%pattern}     # Remove suffix
```

## Arrays and Associative Arrays

```bash
FILES=("f1" "f2")
declare -A CONFIG
CONFIG["host"]="example.com"
```

## Input/Output Handling

```bash
read -p "Enter: " INPUT
cat <<END > file.txt
multi-line
END
```

## Error Handling and Debugging

```bash
set -euo pipefail
trap 'echo "Error at line $LINENO"' ERR
set -x   # debug on
set +x   # debug off
```

---

## Benefits of Shell Scripting

- **Fast prototyping** of automation.
- **Integration** with system tools (`systemctl`, `docker`, `kubectl`, `rsync`).
- **Portability** across Linux distributions.
- **Low dependency**: no need for extra runtimes.

---

## Advanced Examples for Production Environments

## 1. Comprehensive System Health Check

(Full script with disk and memory checks, logging, colors.)

## 2. Advanced Log Analyzer

(Grep-based log analysis with report generation.)

## 3. Kubernetes Deployment Helper

(Validates YAML, applies deployment, waits for rollout.)

## 4. Secure Configuration Manager

(Encrypt/decrypt configs with OpenSSL.)

## 5. Advanced Backup System

(Database backups, retention, verification.)

---

## Best Practices for Production Scripts

## Security

- Avoid command injection.
- Use `mktemp` for temp files.

## Performance

- Prefer shell built-ins over external commands.
- Process large files with `while read`.

## Portability

- Prefer POSIX-compliant syntax when possible.

## Documentation

- Include script headers (purpose, author, usage).
- Document functions with parameters and return codes.

---

## Integration with Modern DevOps Tools

## CI/CD Pipelines

(Shell stages for Jenkins, rollback, Slack alerts.)

## Cloud Integration

- AWS: `aws s3 cp`
- GCP: `gsutil cp`
- Azure: `az storage blob upload`

---

## Monitoring and Logging

## Performance Monitoring

- Track script execution time with `$SECONDS`.
- Send metrics to monitoring systems.

## Structured Logging

- JSON logging with `jq` for easy integration.

---
