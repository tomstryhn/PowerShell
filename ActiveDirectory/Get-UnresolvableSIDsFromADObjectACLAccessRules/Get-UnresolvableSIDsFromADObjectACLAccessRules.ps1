#Requires -Modules ActiveDirectory

<#PSScriptInfo

.DESCRIPTION Lists all the unique Unresolvable SID(s) in the ACL Access Rules from an ADObjec

.VERSION 1.0.0.0

.GUID f5dc7e97-143b-443e-afa1-e83ee1bc93ed

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2022 (c) Tom Stryhn

.TAGS Microsoft Active Directory ACL Access Rule Rules ADObject SID Unresolvable Unknown

.LICENSEURI https://github.com/tomstryhn/PowerShell/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell/ActiveDirectory/Get-UnresolvableSIDsFromADObjectACLAccessRules/

#>

function Get-UnresolvableSIDsFromADObjectACLAccessRules {

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

    [CmdletBinding()]
    param (
        # DistinguishedName of AD Object
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [String]
        $DistinguishedName
    )

    begin {
    
        $objectsProcessed = 0
        $aclRulesProcessed = 0
        $aclRulesWithUnresolvableSIDsFound = 0
  
    }

    process {

        try {
            $objectsProcessed++
            $objectPath = "ActiveDirectory:://RootDSE/" + $DistinguishedName
            $objectACL = Get-Acl -Path $objectPath
        }
        catch {
            "Error reading ACLs on: [$objectPath]" | Write-Verbose
        }
        $unresolvedSIDs = @()

        foreach($ACL in $objectACL.Access) {
            $aclRulesProcessed++
            if($ACL.IdentityReference -match "^(?'SID'S-1-5-21(-\d{1,10}){1,10})$") {
                $isUnresolved = {
                    $adObject = ''
                    try {
                        $adObject = [ADSI]"LDAP://<SID=$($Matches.SID)>"
                        if($adObject.DistinguishedName) {
                            $false
                        } else {
                            $true
                        }
                    }
                    catch {
                        $true
                    }
                }
                if($isUnresolved) {
                    $aclRulesWithUnresolvableSIDsFound++
                    $unresolvedSIDs += $ACL.IdentityReference
                }
            }
        }
        if($unresolvedSIDs) {
            $unresolvedSIDs = $unresolvedSIDs | Sort-Object Value -Unique
            $output = [PSCustomObject]@{
                DistinguishedName = $DistinguishedName
                UnresolvableSIDs = $unresolvedSIDs
            }

            $output
        }
    }
    
    end {

        "Total ADObject(s) processed:               [ $("{0,16}" -f $objectsProcessed) ]" | Write-Verbose
        "ACL Access Rules Processed:                [ $("{0,16}" -f $aclRulesProcessed) ]" | Write-Verbose
        "ACL Access Rules with Unresolvable SID(s): [ $("{0,16}" -f $aclRulesWithUnresolvableSIDsFound) ]`n" | Write-Verbose

    }
}
