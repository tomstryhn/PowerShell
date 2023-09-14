<#PSScriptInfo

.DESCRIPTION A Simple logging function to incorporate in to scripts and automations

.VERSION 1.0.0.0

.GUID 8967535b-7bf2-471d-ad6a-b0802b513ed4

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2023 (c) Tom Stryhn

.TAGS PowerShell Log

.LICENSEURI https://github.com/tomstryhn/PowerShell/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell/Universal/Write-Log/

#>

function Write-Log {
    [CmdletBinding()]
    param (
        # The Message to be written to the LogFile
        [Parameter(
            Position                        = 0,
            Mandatory                       = $true,
            ValueFromPipeline               = $true
        )]
        [string]
        $Message,

        # The Path to the actual LogFile
        [Parameter(
            Mandatory                       = $true,
            Position                        = 1
        )]
        [ValidateScript(
            {
                if ($_){  Test-Path $_}
            })]
        [string]
        $LogPath,

        # The Log Type, which can be either Information, Warning or an Error
        [Parameter(
            Position                        = 2
        )]
        [ValidateSet('Information', 'Warning', 'Error')]
        [string]
        $LogLevel = 'Information'
    )
    
    process {
        # TimeStamp according the ISO 8601 Format
        $timeStamp  = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'

        # The String to be added for the Log
        $logEntry   = $timeStamp + "`t" + '[ ' + $LogLevel + ' ]' + "`t" + $Message

        # Writing the LogFile
        $logEntry | Out-File -Append -FilePath $LogPath
    }
}
