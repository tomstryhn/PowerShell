#Requires -Modules ActiveDirectory

<#PSScriptInfo

.DESCRIPTION Returns all unique groupmemberships of an object, also nested

.VERSION 1.0.0.0

.GUID 266e43f6-5117-47cb-b7d0-9321fc3739ce

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2022 (c) Tom Stryhn

.TAGS Microsoft Active Directory MemberOf ADObject Groups

.LICENSEURI https://github.com/tomstryhn/PowerShell/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell/ActiveDirectory/Get-ADObjectGroupMembership/

#>

function Get-ADObjectGroupMembership {

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

    [CmdletBinding()]
    param(
        # DistinguishedName
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $DistinguishedName
    )

    process  {
    
        try {

            $ADObject = Get-ADObject -Identity $DistinguishedName -Properties MemberOf -ErrorAction Stop
        }
        catch {

            Write-Verbose -Message "No such Object: $DistinguishedName"
            $ADObject = $null
        }

        if($ADObject) {

            $groupMemberships = @()
            $discoveredGroups = @()

            foreach($adGroup in $ADObject.MemberOf) {
                $discoveredGroups += $adGroup
            }

            while($discoveredGroups -ne $null) {
                
                $checkingGroups = $discoveredGroups
                $newDiscoveredGroups = @()

                foreach($cGroup in $checkingGroups) {
                
                    if($groupMemberships -notcontains $cGroup) {

                        $groupMemberships += $cGroup
                        $newGroups = $null
                        $newGroups = (Get-ADGroup -Identity $cGroup -Properties MemberOf).MemberOf
                        
                        if($newGroups) {

                            foreach($nGroup in $newGroups) {

                                if($groupMemberships -notcontains $nGroup) {

                                    $newDiscoveredGroups += $nGroup
                                }
                            }
                        }
                    }
                }

                $discoveredGroups = $newDiscoveredGroups
            }

            $groups = @()
            $groups = $groupMemberships | ForEach-Object { Get-ADGroup -Identity $_ }
            $groups
        }
    }
}
