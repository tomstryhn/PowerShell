#Requires -Modules ActiveDirectory

<#PSScriptInfo

.DESCRIPTION Sets the Default Discretionary Access Control List

.VERSION 0.1.1.0

.GUID 9ee392e9-5c94-4dfc-abe8-899b5002482e

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2023 (c) Tom Stryhn

.LICENSEURI https://github.com/tomstryhn/PowerShell/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell

#>

function Set-DefaultDACL {

    [CmdletBinding()]
    param (
        # DistinguishedName
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory                       = $true
        )]
        [string]
        $DistinguishedName
    )
    
    begin {
        $rootDSE                    = [adsi]"LDAP://RootDSE"
        $computerString             = (Get-ADObject -Filter { (lDAPDisplayName -eq 'computer') }               -SearchBase ($RootDSE.schemaNamingContext[0]) -Properties defaultSecurityDescriptor).defaultSecurityDescriptor
        $containerString            = (Get-ADObject -Filter { (lDAPDisplayName -eq 'container') }              -SearchBase ($RootDSE.schemaNamingContext[0]) -Properties defaultSecurityDescriptor).defaultSecurityDescriptor
        $groupString                = (Get-ADObject -Filter { (lDAPDisplayName -eq 'group') }                  -SearchBase ($RootDSE.schemaNamingContext[0]) -Properties defaultSecurityDescriptor).defaultSecurityDescriptor
        $organizationalUnitString   = (Get-ADObject -Filter { (lDAPDisplayName -eq 'organizationalUnit') }    -SearchBase ($RootDSE.schemaNamingContext[0]) -Properties defaultSecurityDescriptor).defaultSecurityDescriptor
        $userString                 = (Get-ADObject -Filter { (lDAPDisplayName -eq 'user') }                   -SearchBase ($RootDSE.schemaNamingContext[0]) -Properties defaultSecurityDescriptor).defaultSecurityDescriptor
    }
    
    process {
        try {
            $adObject = Get-ADObject -Identity $DistinguishedName -Properties ObjectClass
        }
        catch {
            Write-Error -Message "Error retrieving ADObject: [$DistinguishedName]"
        }
        switch ($adObject.ObjectClass) {
            computer            { $sddlString = $computerString }
            container           { $sddlString = $containerString }
            group               { $sddlString = $groupString }
            organizationalUnit  { $sddlString = $organizationalUnitString }
            user                { $sddlString = $userString }
            Default             { $sddlString = $false }
        }
        if($sddlString) {
            try {
                $objectPath = "ActiveDirectory:://RootDSE/" + $DistinguishedName
                $objectACL = Get-Acl -Path $objectPath -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Error retrieving ACL: [$objectPath]"
            }
            try {
                $objectACL.SetSecurityDescriptorSddlForm($sddlString)
                Set-Acl -Path $objectPath -AclObject $objectACL -ErrorAction Stop
            }
            catch {
                Write-Error -Message "Error setting ACL: [$DistinguishedName]" -ErrorAction Stop
            }
        } else {
            Write-Verbose -Message "ObjectType [ $($adObject.ObjectClass) ] not supported"
        }
    }
    
    end {
        
    }
}
