# Active Directory Attack Simulation Lab

## Project Overview
This project demonstrates a **simplified Active Directory (AD) lab** for cybersecurity learning and resume purposes. The lab simulates a small enterprise environment where an attacker performs **enumeration, privilege escalation, and Kerberos attack simulations** on an AD domain.  

The goal is to **understand Active Directory security architecture**, simulate common attack techniques safely in a lab, and document findings for mitigation.

---

## Lab Architecture
          Virtual Network
       (VirtualBox Internal Network)

    +-----------------------------+
    |        Windows 10 VM        |
    |   Domain Controller + AD    |
    |  Users / Groups / Services  |
    +-------------+---------------+
                  |
                  |
          Internal Network
                  |
                  |
    +-------------+---------------+
    |          Kali Linux         |
    |        Attacker Machine     |
    | Enumeration & Attacks       |
    +-----------------------------+

    
### VM Roles
| Machine | Purpose |
|---------|---------|
| Kali Linux | Attacker machine for enumeration and attacks |
| Windows 10 | Domain Controller with Active Directory services |

---

## Tools & Technologies

### Operating Systems
- Kali Linux
- Windows 10 (Domain Controller)

### Active Directory Components
- Microsoft Active Directory
- Kerberos authentication
- Domain users and groups

### Enumeration Tools
- **BloodHound** – visualize attack paths in AD  
- **SharpHound** – collect domain data  
- **PowerView** – PowerShell AD enumeration

### Attack Simulation Tools
- **Impacket** – Kerberos attacks and network exploitation  
- **Mimikatz** – credential extraction simulation  
- **CrackMapExec (CME)** – lateral movement and privilege escalation

---

## Project Phases

### 1. Environment Setup
- Installed Windows 10 VM as Domain Controller  
- Configured Active Directory domain `corp.local`  
- Created domain users and service accounts  

### 2. Initial Reconnaissance
- Performed network discovery using **Nmap**  
- Identified open ports and services (Kerberos, LDAP, SMB, DNS)

### 3. Active Directory Enumeration
- Collected users, groups, permissions, and trust relationships using PowerView and SharpHound  
- Imported data into BloodHound to visualize privilege escalation paths

### 4. Attack Simulation
- Simulated **Kerberoasting** to extract service account hashes  
- Simulated **AS-REP Roasting** for accounts without pre-authentication  
- Explored privilege escalation via misconfigured permissions

### 5. Persistence Simulation
- Demonstrated theoretical attacker persistence techniques (documented only)  
- Examples: creating a domain admin user, scheduled tasks, credential reuse

---

## Deliverables
- Architecture diagram of the lab environment  
- Screenshots of enumeration results and BloodHound attack paths  
- Step-by-step documentation of attack simulation and mitigation recommendations  
- Scripts used for enumeration and scanning  

---

## Learning Outcomes
After completing this project, you will be able to:
- Understand Active Directory security architecture  
- Perform network and AD enumeration  
- Identify privilege escalation paths  
- Simulate common Kerberos attacks in a lab environment  
- Document and report security findings professionally  

---
