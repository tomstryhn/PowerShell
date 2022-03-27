# New-DummyComputerURAGPO

 Function which creates the files and directory structure needed to generate an User Rights Assignment group policy backup object.

## Table of Content

  - [Version Changes](#version-changes)
  - [Background](#background)
  - [Examples](#examples)
  - [BuiltIn Help](#builtin-help)


## Version Changes

##### 1.0.0.0
- First version published on GitHub

## Background

When deploying ie. a tiering model, you need some User Rights Assignments deployed through a Group Policy, this
function basically creates an empty Group Policy Template to use use with the GPMC or PowerShell.

## Examples

```PowerShell

PS C:\> New-DummyComputerURAGPO


PS C:\> _

```

This will create a backup GPO, which can be imported with the Group Policy Management Console, or using PowerShell.

## Builtin Help

```PowerShell

<#
.SYNOPSIS
Creates the files and directory structure needed to generate an User Rights Assignment group policy backup object.

.DESCRIPTION
Creates the files and directory structure needed to generate an User Rights Assignment group policy backup object.

.PARAMETER Path
The Path to where the structure should be created, defaults to your current location.

.EXAMPLE
PS C:\> New-DummyComputerURAGPO

.NOTES
FUNCTION: New-DummyComputerURAGPO
AUTHOR:   Tom Stryhn
GITHUB:   https://github.com/tomstryhn/

.INPUTS
[string]

.OUTPUTS

#>

```
