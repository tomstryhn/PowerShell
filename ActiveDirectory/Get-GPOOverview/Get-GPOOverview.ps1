<#PSScriptInfo

.DESCRIPTION Retrieves information about Group Policy Objects (GPOs) and their links.

.VERSION 1.0.0.0

.GUID d1d76bac-ca9a-4c7d-b17c-8ee58ac960f9

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2024 (c) Tom Stryhn

.TAGS Microsoft Active Directory Group Policy Objects Overview Audit

.LICENSEURI https://github.com/tomstryhn/PowerShell/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell/ActiveDirectory/Get-GPOOverview/

#>

function Get-GPOOverview {

<#
.SYNOPSIS
Retrieves information about Group Policy Objects (GPOs) and their links.

.DESCRIPTION
The Get-GPOOverview function generates a report for all GPOs in the domain, including details about links,
enabled links, and extension data (if available).

#>

    # Generate the XML report for all GPOs
    [xml]$allGPOs = Get-GPOReport -All -ReportType Xml

    # Process each GPO
    $allGPOs.GPOS.GPO | Foreach-Object {
    
        $links = 0
        $eLinks = 0
    
        foreach($link in $PSItem.LinksTo) {
            $links++
            if(($link.Enabled -eq 'true') -or ($link.Enabled -eq 'True')) {
                $eLinks++
            }
        }
        
        # Creates PSCustom Output Object
        $output = [PSCustomObject]@{
            Name = $PSItem.Name
            Links = $links
            EnabledLinks = $eLinks
            Computer = $PSItem.Computer.Enabled
            ComputerData = if($PSItem.Computer.ExtensionData.Extension) { $true } else { $false }
            User = $PSItem.User.Enabled
            UserData = if($PSItem.User.ExtensionData.Extension) { $true } else { $false }
        }
        $output
    }
}
