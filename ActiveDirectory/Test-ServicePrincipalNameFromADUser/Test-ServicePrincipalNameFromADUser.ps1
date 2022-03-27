#Requires -Modules ActiveDirectory, DnsClient

<#PSScriptInfo

.DESCRIPTION Returns all unique groupmemberships of an object, also nested

.VERSION 1.0.0.0

.GUID c2a3cd35-7919-4455-89da-15bece2fb794

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2022 (c) Tom Stryhn

.TAGS Microsoft Active Directory ServicePrincipalName ADUser

.LICENSEURI https://github.com/tomstryhn/PowerShell/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell/ActiveDirectory/Test-ServicePrincipalNameFromADUser/

#>
function Test-ServicePrincipalNameFromADUser {

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

    [CmdletBinding()]
    param (
        # DistinguishedName of ADUser Object
        [Parameter(
            Mandatory                       = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $DistinguishedName
    )
    
    begin {}
    
    process {

        try{
            Write-Verbose -Message "Fetching: [$DistinguishedName]"
            $adUser = Get-ADUser -Identity $DistinguishedName -Properties ServicePrincipalName -ErrorAction Stop
        }
        catch {
            Write-Error -Message "UserObject not found: [$DistinguishedName]"
        }

        Write-Verbose -Message "SPN Count: [$(($adUser.ServicePrincipalName).Count)]"

        [regex]$spnRegex = "^(?'spnString'(?'serviceName'[A-Za-z0-9\-\.]{1,25})\/(?'fqdn'(?'computerName'[A-Za-z0-9\-]{1,63})(?:(?:\.[A-Za-z0-9\-]{1,63})){2,5})(?:\:(?'portNumber'[0-9]{1,5})){0,1})$"

        foreach($servicePrincipalName in $adUser.ServicePrincipalName) {

            $isValidSPN = $servicePrincipalName -match $spnRegex

            if($isValidSPN) {
                try {
                    $dnsResolve = Resolve-DnsName $Matches.fqdn -ErrorAction Stop
                    if($dnsResolve) {
                        $isResolvable = $true
                    }
                }
                catch {
                    $isResolvable = $false
                }
            }

            $output = [PSCustomObject]@{
                DistinguishedName           = $DistinguishedName
                ServicePrincipalName        = if($isValidSPN) { $Matches.spnString }    else { $servicePrincipalName }
                ServiceName                 = if($isValidSPN) { $Matches.serviceName }  else { 'N/A' }
                FullyQualifiedDomainName    = if($isValidSPN) { $Matches.fqdn }         else { 'N/A' }
                Resolvable                  = if($isValidSPN) { $isResolvable }         else { 'N/A' }
            }
            $output
        }
        Write-Verbose -Message "Complete: [$DistinguishedName]`n"
    }
    
    end {}
}
