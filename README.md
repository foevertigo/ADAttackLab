# Active Directory Attack Simulation Lab

![Lab Architecture](https://img.shields.io/badge/Architecture-Active%20Directory-blue)
![Platform](https://img.shields.io/badge/Platform-Windows%20Server%202022-brightgreen)
![Attacker](https://img.shields.io/badge/Attacker-Kali%20Linux-red)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Project Overview
This project involves the complete setup and exploitation of a custom Active Directory environment. The lab was designed to simulate realistic corporate network vulnerabilities and demonstrate the attack paths an adversary could take to escalate privileges from a standard unauthenticated network position to full Domain Administrator compromise.

**Goal:** To practically demonstrate AD enumeration, credential theft, privilege escalation, and lateral movement techniques.

## 🏗️ Architecture & Setup
The lab environment consists of two virtual machines communicating over an isolated virtual network:
- **Target:** Windows Server 2022 (Domain Controller)
  - **Domain:** `corp.local`
  - **IP:** `192.168.56.10`
  - **Vulnerabilities Configured:** Pre-authentication disabled (AS-REP Roasting), vulnerable Service Principal Names (Kerberoasting), misconfigured Backup Operators group.
- **Attacker:** Kali Linux
  - **IP:** `192.168.56.20`
  - **Tools Utilized:** Nmap, Impacket (`GetNPUsers`, `GetUserSPNs`, `secretsdump`, `wmiexec`), John the Ripper.

## ⚔️ Attack Chain Execution

### 1. Initial Reconnaissance
Performed network scanning to identify the Domain Controller and pinpoint critical Active Directory services (Kerberos, LDAP, SMB, DNS).
- **Tool:** Nmap (`nmap -Pn -p 88,389,445 192.168.56.10`)
- **Finding:** Confirmed Kerberos (88) and SMB (445) ports were open, verifying the identity of the Domain Controller.

### 2. AS-REP Roasting (Credential Access)
Identified a user account (`priya`) configured with "Do not require Kerberos preauthentication" and extracted their Kerberos AS-REP ticket.
- **Tool:** Impacket `GetNPUsers`
- **Action:** Extracted the TGT ticket hash for `priya` without requiring any initial authentication to the domain.
- **Cracking:** Utilized **John the Ripper** with the `rockyou.txt` wordlist to crack the hash offline, revealing the cleartext password.

### 3. Kerberoasting (Privilege Escalation)
Used the compromised standard user credentials to request Kerberos Service Tickets (TGS) for accounts with registered Service Principal Names (SPNs).
- **Tool:** Impacket `GetUserSPNs`
- **Action:** Extracted the TGS ticket hash for the `svc-sql` service account. Overcame a realistic `KRB_AP_ERR_SKEW` (Clock skew) defense mechanism by practically mapping and synchronizing NTP timestamps between the attacker machine and the Domain Controller.
- **Cracking:** Cracked the Kerberos ticket offline using John the Ripper to acquire the `svc-sql` password.

### 4. DCSync / Credential Dumping
Leveraged compromised administrative-tier credentials to replicate the Domain Controller's behavior and extract the NTDS.dit password database.
- **Tool:** Impacket `secretsdump`
- **Action:** Bypassed standard access controls to dump the NTLM hashes for all users in the domain, including the `Administrator` account.

### 5. Pass-the-Hash (Total Compromise)
Utilized the extracted Domain Administrator's NTLM hash to authenticate directly to the Domain Controller's SMB service without needing the plaintext password.
- **Tool:** Impacket `wmiexec`
- **Action:** Bypassed Windows Defender AV constraints to spawn a direct, semi-interactive command shell on the DC.
- **Result:** Successfully executed commands as `NT AUTHORITY\SYSTEM` and `corp\administrator`, achieving complete domain compromise.

## 🚀 Key Learnings & Skills Demonstrated
- **Infrastructure:** Provisioning and configuring Windows Server 2022 as a Domain Controller.
- **Networking:** Troubleshooting complex VM networking (VirtualBox Host-only/Internal networks), firewall rules, and Kerberos time-sync requirements (`KRB_AP_ERR_SKEW`).
- **Exploitation:** Executing the Impacket suite for complex AD attacks.
- **Cryptography:** Offline password cracking of Kerberos tickets (AS-REP and TGS).
- **Defense Evasion:** Executing Pass-the-Hash (PtH) attacks to bypass traditional authentication and EDR constraints.

---
*Disclaimer: This repository and lab were created strictly for educational purposes and authorized security research.*
