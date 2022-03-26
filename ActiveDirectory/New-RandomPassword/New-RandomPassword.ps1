<#PSScriptInfo

.DESCRIPTION Generates a random password

.VERSION 1.0.0.0

.GUID 1dc890ef-1cb2-4522-8da3-6c352eeeb7bd

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2022 (c) Tom Stryhn

.TAGS Random Password Generator

.LICENSEURI https://github.com/tomstryhn/PowerShell/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell/ActiveDirectory/New-RandomPassword/

#>

function New-RandomPassword {

<#
.SYNOPSIS
    New-RandomPassword
    
.DESCRIPTION
    Generate a random password between 12-48 characters, consisting of at least 2 special
    characters, 2 capital letters, 2 small letters and two numbers.
    
.PARAMETER PwdLength
    Optional, Int32, between 12 and 48.
    
.EXAMPLE
    PS C:\> New-RandomPassword
    TaSnMR^q07<*n$%3KD!?
    
.EXAMPLE
    New-RandomPassword -PwdLength 12
    R@aaz!xd<H16
    
.NOTES
    FUNCTION: New-RandomPassword
    AUTHOR:   Tom Stryhn
    GITHUB:   https://github.com/tomstryhn/
    
.INPUTS
    System.Int32
    
.OUTPUTS
    System.String

#>    
    
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateRange(12,48)]
        [int]$PwdLength = 24
    )

    process {

      $specChars        = (33,35) + (36..38) + (42..44) + (60..64) + (91..94)       # Special Characters    ! # $ % & * + , < = > ? @ [ \ ] ^
      $numbers          = (48..57)                                                  # Numbers               [0-9]
      $capitalLetters   = (65..90)                                                  # Capital Letters       [A-Z]
      $smallLetters     = (97..122)                                                 # Small Letters         [a-z]

        try {
        
            $spCh   = ( $specChars      | Get-Random -Count 2 | ForEach-Object { [char]$_ })
            $numb   = ( $numbers        | Get-Random -Count 2 | ForEach-Object { [char]$_ })
            $caLe   = ( $capitalLetters | Get-Random -Count 2 | ForEach-Object { [char]$_ })
            $smLe   = ( $smallLetters   | Get-Random -Count 2 | ForEach-Object { [char]$_ })
            $rand   = ( $specChars + $numbers + $capitalLetters + $smallLetters | Get-Random -Count ($PwdLength - 8) | ForEach-Object {[char]$_})
            $newPwd = -join ($spCh + $numb + $caLe + $smLe + $rand | Sort-Object { Get-Random })
            
        }
        catch {
        
            Write-Error $_.Exception.Message
            
        }
        
      $newPwd
    }
}
