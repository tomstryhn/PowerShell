# Get-ADObjectGroupMembership.ps1 PowerShell Script

Returns all unique groupmemberships of an object, also nested

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
  - [Loading the script](#loading-the-script)
  - [Examples](#examples)

## Version Changes

##### 1.0.0.0
- First version published on GitHub

## Background

More and more security is introduced into environments, and more and more often your access depends on the groupmemberships you have in the Active Direcory. But from time to time it can become very hard to determine which groups are nested into which, and in ie. a tiering model, the denyrights are often also defined by groupmemberships, so to make the backtracking a little easier I made this script help you get an overview of which groups an ADObject (Group, User or Computer-object) is directly or 'in-directly' (nested) member of.

## Loading the script

By far the easiest way is currently just to use in-memory-execution by copy pasting the below code into your session, which basically will load the script directly from this GitHub repo, and make the command `Get-ADObjectGroupMembership` available in the session to which you paste the code:

```PowerShell

$remoteURL = 'https://raw.githubusercontent.com/tomstryhn/Get-ADObjectGroupMembership.ps1/main/Get-ADObjectGroupMembership.ps1'       
$remoteCode = (Invoke-WebRequest -Uri $remoteURL -UseBasicParsing).Content
Invoke-Expression -Command $remoteCode

```

Alternatively you can download the .ps1 file and simply dotsource it into your active session by using the below snippet, at the location to which you have saved the file.

```PowerShell

  . .\Get-ADObjectGroupMembership.ps1

```

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
