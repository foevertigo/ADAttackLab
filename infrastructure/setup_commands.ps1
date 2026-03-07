<#
.SYNOPSIS
This script configures the vulnerable users and service accounts for the Active Directory Lab.

.DESCRIPTION
It creates standard users, service accounts, registers an SPN to enable Kerberoasting, 
disables pre-authentication for a user to enable AS-REP Roasting, and adds a service 
account to the Backup Operators group to enable DCSync (secretsdump).

.NOTES
Run this script on the Windows Server (Domain Controller) as Administrator.
#>

# 1. Create Standard Users (Alice and Priya)
Write-Host "Creating Standard Users..."
New-ADUser -Name "Alice Johnson" -SamAccountName "alice" -UserPrincipalName "alice@corp.local" -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "Priya Sharma" -SamAccountName "priya" -UserPrincipalName "priya@corp.local" -AccountPassword (ConvertTo-SecureString "Password456!" -AsPlainText -Force) -Enabled $true

# 2. Create Service Accounts (Backup and SQL)
Write-Host "Creating Service Accounts..."
New-ADUser -Name "Backup Service" -SamAccountName "svc-backup" -UserPrincipalName "svc-backup@corp.local" -AccountPassword (ConvertTo-SecureString "Backup2024" -AsPlainText -Force) -Enabled $true
New-ADUser -Name "SQL Service" -SamAccountName "svc-sql" -UserPrincipalName "svc-sql@corp.local" -AccountPassword (ConvertTo-SecureString "SQLpass1" -AsPlainText -Force) -Enabled $true

# 3. Configure AS-REP Roasting Vulnerability (Priya)
Write-Host "Configuring AS-REP Roasting (Disabling Pre-Auth for Priya)..."
Set-ADAccountControl -Identity "priya" -DoesNotRequirePreAuth $true

# 4. Configure Kerberoasting Vulnerability (svc-sql)
Write-Host "Configuring Kerberoasting (Adding SPN for svc-sql)..."
setspn -A MSSQLSvc/DC01.corp.local:1433 CORP\svc-sql

# 5. Configure DCSync Vulnerability (svc-backup)
Write-Host "Configuring DCSync (Adding svc-backup to Backup Operators)..."
Add-ADGroupMember -Identity "Backup Operators" -Members "svc-backup"

Write-Host "Lab setup complete!"
