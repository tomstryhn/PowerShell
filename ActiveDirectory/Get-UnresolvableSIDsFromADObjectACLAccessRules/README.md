# Get-UnresolvableSIDsFromADObjectACLAccessRules

Lists all the unique Unresolvable SID(s) in the ACL Access Rules from an ADObject, using -Verbose will additionally output statistics, usefull when using pipeline input.

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
  - [Examples](#examples)
  - [Builtin Help](#builtin-help)

## Version Changes

##### 1.0.0.0
- First version published on GitHub

## Background

'Housekeeping' in the Active Directory can often be somewhat of tiresome task to do, this funtion will help when it comes to identifying ADObjects with Unknown SIDs, SIDs that can not be resolved. These are mostly a result of old users or objects no longer residing in the Active Directory. What happens when you delete an User or any other ADObject for that matter, is that the Object itself is removed, but a lot of the references will remain. This is often a result of delegating rights and permissions directly to users and not groups, and are often seen in older or larger Active Directories.

## Examples

The `Get-UnresolvableSIDsFromADObjectACLAccessRules` can be used with single ADObjects, but it's really designed to take input directly from the pipeline, which is also why the 'statistics' in `-Verbose`-mode have been added. In the below example you can see one way to use it. A little note, you _can_ pipe all your ADObjects into the function at once, but you really __shouldn't__, since it can take ages, and since the function is not perfect yet, it will not tell you where it failed. 

```PowerShell

PS C:\> Get-ADObject -SearchBase 'OU=TestOU,DC=Dev,DC=local' -Filter * | Get-UnresolvableSIDsFromADObjectACLAccessRules -Verbose

DistinguishedName                              UnresolvableSIDs                              
-----------------                              ----------------                              
CN=TestUser,OU=Users,OU=TestOU,DC=dev,DC=local S-1-5-21-1234567890-1234567890-1234567890-12345
CN=UserTest,OU=Users,OU=TestOU,DC=dev,DC=local S-1-5-21-1234567890-1234567890-1234567890-12543

VERBOSE: Total ADObject(s) processed:               [              174 ]
VERBOSE: ACL Access Rules Processed:                [            26358 ]
VERBOSE: ACL Access Rules with Unresolvable SID(s): [               23 ]

```

## Builtin Help

```PowerShell

<#
.SYNOPSIS
    Lists all the unique Unresolvable SID(s) in the ACL Access Rules from an ADObject.

.DESCRIPTION
    Lists all the unique Unresolvable SID(s) in the ACL Access Rules from an ADObject,
    using -Verbose will additionally output statistics, usefull when using pipeline 
    input to the function.
 
.PARAMETER DistinguishedName
    The DistinguishedName of the targeted ADObject

.EXAMPLE
    PS C:\> Get-UnresolvableSIDsFromADObjectACLAccessRules -DistinguishedName 'OU=TestOU,DC=Dev,DC=local'

    DistinguishedName         UnresolvableSIDs                              
    -----------------         ----------------                              
    OU=TestOU,DC=Dev,DC=local S-1-5-21-1234567890-1234567890-1234567890-12345

.EXAMPLE
    PS C:\> Get-UnresolvableSIDsFromADObjectACLAccessRules -DistinguishedName 'OU=TestOU,DC=Dev,DC=local' -Verbose

    VERBOSE: Total ADObject(s) processed:               [                1 ]
    VERBOSE: ACL Access Rules Processed:                [               25 ]
    VERBOSE: ACL Access Rules with Unresolvable SID(s): [                2 ]

    DistinguishedName         UnresolvableSIDs                              
    -----------------         ----------------                              
    OU=TestOU,DC=Dev,DC=local S-1-5-21-1234567890-1234567890-1234567890-12345

.NOTES
    FUNCTION: Get-UnresolvableSIDsFromADObjectACLAccessRules
    AUTHOR:   Tom Stryhn
    GITHUB:   https://github.com/tomstryhn/

.INPUTS
    System.String

.OUTPUTS
    System.Management.Automation.PSCustomObject

#>

```
