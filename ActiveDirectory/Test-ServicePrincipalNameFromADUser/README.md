# Test-ServicePrincipalNameFromADUser

 Gets the ServicePrincipalName from ADUser Objects, and validates this.

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
  - [Examples](#examples)
  - [BuiltIn Help](#builtin-help)


## Version Changes

##### 1.0.0.0
- First version published on GitHub

## Background

From time to time you will meet the good old 'ServiceAccounts' which basically are UserObjects used as Service Accounts. These will often be easily identifiable by their ServicePrincipalNames. But to make sure that they are still 'valid' you can use this fairly simple function to validate if the syntax is correct and the FQDN is actually resolveable.  

## Examples

```PowerShell

    PS C:\> Get-ServicePrincipalNameFromADUser -DistinguishedName "CN=ServiceAccountA,OU=UserAccounts,DC=Domain,DC=local"
    
    DistinguishedName        : CN=ServiceAccountA,OU=UserAccounts,DC=Domain,DC=local
    ServicePrincipalName     : http/webserver-a.domain.local:80
    ServiceName              : http
    FullyQualifiedDomainName : webserver-a.domain.local
    Resolvable               : True
    
    DistinguishedName        : CN=ServiceAccountA,OU=UserAccounts,DC=Domain,DC=local
    ServicePrincipalName     : http/webserver-b.domain.local
    ServiceName              : http
    FullyQualifiedDomainName : webserver-b.domain.local
    Resolvable               : True

```

## Builtin Help

```PowerShell

<#
.SYNOPSIS
    Gets the ServicePrincipalName from ADUser Objects, and validates this.
    
.DESCRIPTION
    Gets the ServicePrincipalNames from a given ADUser Object, and will try and resolve the FQDN, assuming the SPN is in
    the correct syntax, for the User Objects, which only should consist of Service Accounts, there are som requirements
    for the SPNs, which differ a little from the SPNs found on the Computer Objects:
    ServiceName/Fully.Qualified.Domain.Name(:Port)
    The ServiceName is mandatory, and so is the FQDN, not saying it wont work with the ComputerName alone, but the correct
    definition is with FQDN, which is why this function will flag nonFQDN's as invalid. The Port number on the other hand,
    is optional.
    
.PARAMETER DistinguishedName
    The DistinguishedName of the ADUser Object you want to test the ServicePrincipalName(s) on.
    
.EXAMPLE
    PS C:\> Get-ServicePrincipalNameFromADUser -DistinguishedName "CN=ServiceAccountA,OU=UserAccounts,DC=Domain,DC=local"
    DistinguishedName        : CN=ServiceAccountA,OU=UserAccounts,DC=Domain,DC=local
    ServicePrincipalName     : http/webserver-a.domain.local:80
    ServiceName              : http
    FullyQualifiedDomainName : webserver-a.domain.local
    Resolvable               : True
    DistinguishedName        : CN=ServiceAccountA,OU=UserAccounts,DC=Domain,DC=local
    ServicePrincipalName     : http/webserver-b.domain.local
    ServiceName              : http
    FullyQualifiedDomainName : webserver-b.domain.local
    Resolvable               : True
    
.NOTES
    FUNCTION: Test-ServicePrincipalNameFromADUser
    AUTHOR:   Tom Stryhn
    GITHUB:   https://github.com/tomstryhn/
    
.INPUTS
    [string]
    
.OUTPUTS
    [PSCustomObject]
    
#>
```
