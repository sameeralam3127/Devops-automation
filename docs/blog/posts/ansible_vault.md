---
date:
  created: 2024-04-11
---

# Securing Secrets with Ansible Vault

Automation is a cornerstone of modern IT operations, but automation often involves sensitive data such as passwords, API keys, and certificates. Storing these secrets in plain text within playbooks or configuration files poses a serious security risk. Ansible Vault provides a built-in solution to encrypt and manage such information securely.

<!-- more -->

## What Is Ansible Vault?

Ansible Vault is a feature that allows you to encrypt variables, files, or even entire playbooks. Encrypted content remains unreadable to anyone without the correct decryption password or key. This ensures sensitive information is protected, even if your code repository is public or compromised.

## Why Use Vault?

1. **Protect Sensitive Data**  
   Secrets like SSH keys, database credentials, and cloud access tokens can be stored securely without exposing them in playbooks.

2. **Enable Secure Collaboration**  
   Teams can share encrypted files through version control without risking leaks of confidential information.

3. **Compliance and Auditing**  
   Encrypting sensitive values helps organizations meet security compliance requirements by ensuring proper handling of credentials.

4. **Seamless Integration**  
   Vault works directly with playbooks, roles, and variables, requiring minimal changes to existing automation workflows.

## How Vault Works

- Encrypt a file:
  ```bash
  ansible-vault create secrets.yml
  ```

* Edit an encrypted file:

  ```bash
  ansible-vault edit secrets.yml
  ```

* Encrypt an existing file:

  ```bash
  ansible-vault encrypt vars.yml
  ```

* Run a playbook with Vault password:

  ```bash
  ansible-playbook site.yml --ask-vault-pass
  ```

## Best Practices with Ansible Vault

- Store Vault passwords securely (e.g., use Ansible Tower, AWX, or a password manager).
- Separate sensitive data into dedicated encrypted files rather than mixing them into large playbooks.
- Limit access to the Vault password to only authorized personnel.
- Rotate Vault passwords periodically.
