---
date:
  created: 2025-08-24
---

# Password and System Hardening Best Practices

Securing user authentication and account management is a critical step in system hardening. Weak passwords, poorly managed accounts, or improper access controls can all lead to system compromise. This post covers practical measures such as enforcing strong passwords, using PAM modules, managing user details with GECOS, controlling root access, and enabling SSH key authentication.

<!-- more -->

## Enforce Strong Passwords

Ensure users create strong passwords that meet minimum complexity requirements. You can enforce these rules via **PAM (Pluggable Authentication Modules)**:

```bash
# /etc/pam.d/common-password
password requisite pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1
```

This configuration requires:

- At least 12 characters
- Uppercase, lowercase, numeric, and special characters
- 3 attempts before failure

## Control User Information with GECOS

The GECOS field in `/etc/passwd` helps document user accounts. Regularly review accounts to ensure:

- Each entry has clear identification.
- No stale or unused accounts remain.

Audit users with:

```bash
awk -F: '{print $1, $5}' /etc/passwd
```

## Restrict Root Access

Direct root login is dangerous. Instead:

1. **Disable root SSH login** in `/etc/ssh/sshd_config`:

   ```bash
   PermitRootLogin no
   ```

2. Add trusted administrators to the **sudo group**:

   ```bash
   usermod -aG sudo alice
   ```

This enforces accountability since all privileged commands are logged through `sudo`.

## Validate Active Users Early

Before deploying to production, validate the user list:

```bash
cut -d: -f1 /etc/passwd
```

Remove or disable unnecessary accounts:

```bash
usermod -L olduser     # lock account
```

## Use SSH Keys Instead of Passwords

Configure **public key authentication** for secure remote logins:

1. On client machine:

   ```bash
   ssh-keygen -t ed25519
   ssh-copy-id user@server
   ```

2. On server, update `/etc/ssh/sshd_config`:

   ```bash
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```

3. Restart SSH:

   ```bash
   systemctl restart sshd
   ```

This prevents brute-force password attacks and enforces stronger authentication.

## Example Script for User Hardening

```bash
#!/bin/bash
# Basic user hardening script

# Disable root SSH login
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Enforce password complexity
if ! grep -q "pam_pwquality.so" /etc/pam.d/common-password; then
  echo "password requisite pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1" >> /etc/pam.d/common-password
fi

# Lock old/stale accounts
for user in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd); do
  if [ "$user" != "admin" ] && [ "$user" != "alice" ]; then
    usermod -L $user
  fi
done

systemctl restart sshd
echo "System hardening applied."
```

---
