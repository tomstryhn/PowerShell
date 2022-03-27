# GitHubLoader.ps1

Simple way to load all the scripts in the PowerShell repo of my GitHub into the current PowerShell session

## Table of Content

  - [How it works](#how-it-works)

## How it works

Instead of downloading all the scripts from [PowerShell](https://github.com/tomstryhn/PowerShell/), and loading them one by one, it's possible to use 'in-memory-execution' to actually load all the scripts into the current PowerShell session simply by using the below codesnippet:

```PowerShell

$remoteURL = 'https://raw.githubusercontent.com/tomstryhn/PowerShell/main/GitHub/GitHubLoader/GitHubLoader.ps1'       
$remoteCode = (Invoke-WebRequest -Uri $remoteURL -UseBasicParsing).Content
Invoke-Expression -Command $remoteCode

```

This will load the somewhat simple PowerShell script GitHubLoader.ps1, and by using the [sources.json](https://raw.githubusercontent.com/tomstryhn/PowerShell/main/GitHub/GitHubLoader/sources.json) it will load all the functions one by one. (Assuming i remember to update the sources. :)
