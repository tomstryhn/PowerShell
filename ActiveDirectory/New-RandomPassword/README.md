
# New-RandomPassword

Returns a random password

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
  - [Examples](#examples)
  - [Builtin Help](#builtin-help)

## Version Changes

##### 1.0.0.0
- First version published on GitHub

## Background

When creating new users or 'legacy' Service Accounts you often need to generate a new and random password.

## Loading the script

By far the easiest way is currently just to use in-memory-execution by copy pasting the below code into your session, which basically will load the script directly from this GitHub repo, and make the command `New-RandomPassword` available in the session to which you paste the code:

```PowerShell

$remoteURL = 'https://raw.githubusercontent.com/tomstryhn/PowerShell/main/ActiveDirectory/New-RandomPassword/New-RandomPassword.ps1'       
$remoteCode = (Invoke-WebRequest -Uri $remoteURL -UseBasicParsing).Content
Invoke-Expression -Command $remoteCode

```

Alternatively you can download the .ps1 file and simply dotsource it into your active session by using the below snippet, at the location to which you have saved the file.

```PowerShell

  . .\New-RandomPassword.ps1

```

## Examples

```PowerShell

  PS C:\> New-RandomPassword
  
  =^n066i+Nq$gd?8aA&NKDOpk

```

## Builtin Help

```PowerShell

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

```
