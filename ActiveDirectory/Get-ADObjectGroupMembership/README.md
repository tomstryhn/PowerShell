# Get-ADObjectGroupMembership.ps1 PowerShell Script

Returns all unique groupmemberships of an object, also nested

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
  - [Examples](#examples)
  - [Builtin Help](#builtin-help)

## Version Changes

##### 1.0.0.0
- First version published on GitHub

## Background

More and more security is introduced into environments, and more and more often your access depends on the groupmemberships you have in the Active Direcory. But from time to time it can become very hard to determine which groups are nested into which, and in ie. a tiering model, the denyrights are often also defined by groupmemberships, so to make the backtracking a little easier I made this script help you get an overview of which groups an ADObject (Group, User or Computer-object) is directly or 'in-directly' (nested) member of.

## Examples

When using the `Get-ADObjectGroupMembership`, it often will require a few steps to find the group granting or denying a permission, which will often be done by first getting a complete list of groups, often by using the ` | Format-Table ` feature, or the ` | Sort-Object Name ` combined with the ` | Format-Table ` feature.

```PowerShell

    PS C:\> Get-ADObjectGroupMembership -DistinguishedName 'OU=TestOU,DC=Dev,DC=local'
    
    DistinguishedName : CN=TestGroup,OU=Groups,DC=Dev,DC=local
    GroupCategory     : Security
    GroupScope        : Global
    Name              : TestGroup
    ObjectClass       : group
    ObjectGUID        : ea5bffb0-e574-4176-a00d-a7bf7ad4fb8a
    SamAccountName    : TestGroup
    SID               : S-1-5-21-1234567890-1234567890-1234567890-12345
    
    DistinguishedName : CN=TestGroupNested,OU=Groups,DC=Dev,DC=local
    GroupCategory     : Security
    GroupScope        : Global
    Name              : TestGroupNested
    ObjectClass       : group
    ObjectGUID        : d22f2094-8f7f-4f4c-b953-6becc2f1c822
    SamAccountName    : TestGroup
    SID               : S-1-5-21-1234567890-1234567890-1234567890-23456

```

## Builtin Help

```PowerShell

<#
.SYNOPSIS
    Lists all the unique groupmemberships and nested groupmemberships of an ADObject
    
.DESCRIPTION
    Lists all the unique groupmemberships and nested groupmemberships of an ADObject
    and outputs them, builtin check to avoid loops.
 
.PARAMETER DistinguishedName
    The DistinguishedName of the Object, of which you want to list the memberships.
    
.EXAMPLE
    PS C:\> Get-ADObjectGroupMembership -DistinguishedName 'OU=TestOU,DC=Dev,DC=local'
    DistinguishedName : CN=TestGroup,OU=Groups,DC=Dev,DC=local
    GroupCategory     : Security
    GroupScope        : Global
    Name              : TestGroup
    ObjectClass       : group
    ObjectGUID        : ea5bffb0-e574-4176-a00d-a7bf7ad4fb8a
    SamAccountName    : TestGroup
    SID               : S-1-5-21-1234567890-1234567890-1234567890-12345
    DistinguishedName : CN=TestGroupNested,OU=Groups,DC=Dev,DC=local
    GroupCategory     : Security
    GroupScope        : Global
    Name              : TestGroupNested
    ObjectClass       : group
    ObjectGUID        : d22f2094-8f7f-4f4c-b953-6becc2f1c822
    SamAccountName    : TestGroup
    SID               : S-1-5-21-1234567890-1234567890-1234567890-23456
    
.NOTES
    FUNCTION: Get-ADObjectGroupMembership
    AUTHOR:   Tom Stryhn
    GITHUB:   https://github.com/tomstryhn/
    
.INPUTS
    System.String
    
.OUTPUTS
    Microsoft.ActiveDirectory.Management.ADGroup
    
#>

```
