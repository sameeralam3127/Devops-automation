---
date:
  created: 2018-02-04
---

# Active Directory Domain Service (AD DS)

Active Directory Domain Services (AD DS) is a centralized database management system that stores information about users, computers, groups, printers, security settings, server configurations, and network infrastructure. By consolidating this information centrally, AD DS simplifies administration and enforces consistent policies across the enterprise.

<!-- more -->

## Directory Service (DS)

Directory Service, developed by the IETF, defines relationships between objects in a system. It uses the **Lightweight Directory Access Protocol (LDAP)**, which operates on port **389**, to query and manage directory information.

### Features of AD DS

- Manages user logon, authentication, and directory searches.
- Handles communication between users and domains.
- Stores directory data (the **directory store**) and provides mechanisms to locate and retrieve information.
- Implements centralized control of resources (users, computers, and data).
- Runs on servers known as **Domain Controllers**.

---

## Components of AD DS

### Forest

- Highest-level container in Active Directory.
- Represents a grouping of one or more independent domain trees.
- Defines the logical security boundary for an enterprise.
- Shares a single database and a single global address list.
- Contains objects like the **Directory Schema**, **Global Catalog**, and **Directory Structure**.
- The first domain created is the **Forest Root Domain**.
- By default, users or administrators of one forest cannot access another forest.

### Domain

- Logical boundary for storing information about users, groups, computers, and printers.
- Identified by a **Fully Qualified Domain Name (FQDN)**.
- Managed by a **Domain Controller**, which provides authentication and authorization.
- All domain controllers in a domain hold a synchronized copy of the domain database.

### Domain Tree

- A collection of domains organized in a hierarchical structure.
- Shares a common schema and global catalog.
- Supports a **parent–child** relationship (e.g., `enhanceofit.com` as the parent, `delhi.enhanceofit.com` as a child).
- Provides namespace organization and hierarchy for enterprises.

---
