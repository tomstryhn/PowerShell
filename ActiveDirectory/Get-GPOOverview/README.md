# Get-GPOOverview
Retrieves information about Group Policy Objects (GPOs) and their links.
## Table of Content
  - [Version Changes](#version-changes)
  - [Purpose](#purpose)
  - [Key Benefits](#key-benefits)
  - [Examples](#examples)
  - [Builtin Help](#builtin-help)
## Version Changes
##### 1.0.0.0
- First version published on GitHub
## Purpose
The `Get-GPOOverview` PowerShell script provides a simple report on Group Policy Objects (GPOs) within your domain. By analyzing GPOs and their links, this script helps streamline administrative tasks and enhances efficiency.

## Key Benefits
1. **Time Savings**: Manually gathering information about GPOs and their links can be time-consuming. `Get-GPOOverview` automates this process, allowing administrators to quickly access essential details without navigating through multiple interfaces.

2. **Holistic View**: The script generates a consolidated report for all GPOs, including information on links, enabled links, and extension data (if available). This holistic view simplifies troubleshooting, auditing, and planning.

3. **Identifying Enabled Links**: With the `EnabledLinks` property, administrators can instantly identify which GPO links are active. This knowledge is crucial for maintaining a secure and efficient Active Directory environment.

4. **Extension Data Insights**: The `ComputerData` and `UserData` properties reveal whether extension data exists for computer or user settings. This insight helps administrators pinpoint areas that require further investigation or optimization.
## Examples
For the easiest overview:
```PowerShell
  PS C:\> Get-GPOOverview | Sort-Object Name | Format-Table -AutoSize
```
## Builtin Help
```PowerShell
<#
.SYNOPSIS
Retrieves information about Group Policy Objects (GPOs) and their links.

.DESCRIPTION
The Get-GPOOverview function generates a report for all GPOs in the domain, including details about links,
enabled links, and extension data (if available).

#>
```
