
# New-RandomPassword.ps1 PowerShell Script

Returns a random password

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
  - [Loading the script](#loading-the-script)
  - [Examples](#examples)

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
