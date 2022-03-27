<#PSScriptInfo

.DESCRIPTION Creates the files and directory structure needed to generate an User Rights Assignment group policy backup object.

.VERSION 1.0.0.0

.GUID 4ae1bda4-9faf-4ddd-80f6-f5d1a90df7ca

.AUTHOR Tom Stryhn

.COMPANYNAME Tom Stryhn

.COPYRIGHT 2021 (c) Tom Stryhn

.LICENSEURI https://github.com/tomstryhn/ActiveDirectory/blob/main/LICENSE

.PROJECTURI https://github.com/tomstryhn/PowerShell/ActiveDirectory/New-DummyComputerURAGPO

#>

function New-DummyComputerURAGPO {

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

    [CmdletBinding()]
    param (
        # Path
        [Parameter()]
        [string]
        $Path = (Get-Location).Path
    )
    
    $xmlParent        = Join-Path -Path $Path      -ChildPath 'DummyGPO\{12345678-1234-1234-1234-123456789012}'
    $secEditParent    = Join-Path -Path $xmlParent -ChildPath 'DomainSysvol\GPO\Machine\microsoft\windows nt\'
    $bkupInfoxmlPath  = Join-Path -Path $xmlParent -ChildPath 'bkupInfo.xml'
    $backupxmlPath    = Join-Path -Path $xmlParent -ChildPath 'Backup.xml'
    $gptTmplinfPath   = Join-Path -Path (Join-Path -Path $secEditParent -ChildPath 'SecEdit') -ChildPath 'GptTmpl.inf'

    if(-not (Test-Path -Path (Join-Path -Path $secEditParent -ChildPath 'secEdit') -PathType Container)) {

        try {

            Write-Verbose -Message "Creating GPO directory structure"
            New-Item -Path $secEditParent -Name 'SecEdit' -ItemType Directory -Force -ErrorAction Stop | Out-Null

        }
        catch {
            Write-Error -Message "Failed creating directory structure: $(Join-Path -Path $secEditParent -ChildPath 'SecEdit')"
        }

    } else {
        Write-Verbose -Message 'Directory structure already exists'
    }

    if(-not(Test-Path -Path $bkupInfoxmlPath -PathType Leaf)) {

        try{
            $bkupInfoxml = @"
<BackupInst xmlns="http://www.microsoft.com/GroupPolicy/GPOOperations/Manifest"><GPOGuid><![CDATA[{12345678-1234-1234-1234-123456789012}]]></GPOGuid><GPODomain><![CDATA[dummy.domain]]></GPODomain><GPODomainGuid><![CDATA[{12345678-1234-1234-1234-123456789012}]]></GPODomainGuid><GPODomainController><![CDATA[dc.dummy.domain]]></GPODomainController><BackupTime><![CDATA[2001-01-01T01:01:01]]></BackupTime><ID><![CDATA[{12345678-1234-1234-1234-123456789012}]]></ID><Comment><![CDATA[]]></Comment><GPODisplayName><![CDATA[DummyGPO]]></GPODisplayName></BackupInst>
"@
            Write-Verbose -Message "Writing file: [ $bkupInfoxmlPath ]"
            $bkupInfoxml | Out-File -FilePath $bkupInfoxmlPath -Encoding 'utf8' -ErrorAction Stop

        }
        catch{
            Write-Error -Message "Error writing file: [ $bkupInfoxmlPath ]"
        }

    } else {

        Write-Verbose -Message "[ $bkupInfoxmlPath ] - Already exists"
    }


    if(-not(Test-Path -Path $backupxmlPath -PathType Leaf)) {

        try {
            $backupxml  = @"
<?xml version="1.0" encoding="utf-8"?><!-- Copyright (c) Microsoft Corporation.  All rights reserved. --><GroupPolicyBackupScheme bkp:version="2.0" bkp:type="GroupPolicyBackupTemplate" xmlns:bkp="http://www.microsoft.com/GroupPolicy/GPOOperations" xmlns="http://www.microsoft.com/GroupPolicy/GPOOperations">
    <GroupPolicyObject><SecurityGroups><Group bkp:Source="FromDACL"><Sid><![CDATA[S-1-5-21-1234567890-123456789-1234567890-519]]></Sid><SamAccountName><![CDATA[Enterprise Admins]]></SamAccountName><Type><![CDATA[UniversalGroup]]></Type><NetBIOSDomainName><![CDATA[dummy]]></NetBIOSDomainName><DnsDomainName><![CDATA[dummy.domain]]></DnsDomainName><UPN><![CDATA[Enterprise Admins@dummy.domain]]></UPN></Group><Group bkp:Source="FromDACL"><Sid><![CDATA[S-1-5-21-1234567890-123456789-1234567890-512]]></Sid><SamAccountName><![CDATA[Domain Admins]]></SamAccountName><Type><![CDATA[GlobalGroup]]></Type><NetBIOSDomainName><![CDATA[dummy]]></NetBIOSDomainName><DnsDomainName><![CDATA[dummy.domain]]></DnsDomainName><UPN><![CDATA[Domain Admins@dummy.domain]]></UPN></Group></SecurityGroups><FilePaths/><GroupPolicyCoreSettings><ID><![CDATA[{12345678-1234-1234-1234-123456789012}]]></ID><Domain><![CDATA[dummy.domain]]></Domain><SecurityDescriptor>01 00 04 9c 00 00 00 00 00 00 00 00 00 00 00 00 14 00 00 00 04 00 ec 00 08 00 00 00 05 02 28 00 00 01 00 00 01 00 00 00 8f fd ac ed b3 ff d1 11 b4 1d 00 a0 c9 68 f9 39 01 01 00 00 00 00 00 05 0b 00 00 00 00 00 24 00 ff 00 0f 00 01 05 00 00 00 00 00 05 15 00 00 00 2a 55 76 e9 d9 13 42 2a 61 74 98 7d 00 02 00 00 00 02 24 00 ff 00 0f 00 01 05 00 00 00 00 00 05 15 00 00 00 2a 55 76 e9 d9 13 42 2a 61 74 98 7d 00 02 00 00 00 02 24 00 ff 00 0f 00 01 05 00 00 00 00 00 05 15 00 00 00 2a 55 76 e9 d9 13 42 2a 61 74 98 7d 07 02 00 00 00 02 14 00 94 00 02 00 01 01 00 00 00 00 00 05 09 00 00 00 00 02 14 00 94 00 02 00 01 01 00 00 00 00 00 05 0b 00 00 00 00 02 14 00 ff 00 0f 00 01 01 00 00 00 00 00 05 12 00 00 00 00 0a 14 00 ff 00 0f 00 01 01 00 00 00 00 00 03 00 00 00 00</SecurityDescriptor><DisplayName><![CDATA[DummyGPO]]></DisplayName><Options><![CDATA[1]]></Options><UserVersionNumber><![CDATA[0]]></UserVersionNumber><MachineVersionNumber><![CDATA[917518]]></MachineVersionNumber><MachineExtensionGuids><![CDATA[[{827D319E-6EAC-11D2-A4EA-00C04F79F83A}{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}]]]></MachineExtensionGuids><UserExtensionGuids/><WMIFilter/></GroupPolicyCoreSettings> 
        <GroupPolicyExtension bkp:ID="{35378EAC-683F-11D2-A89A-00C04FBBCFA2}" bkp:DescName="Registry">
            
            
            <FSObjectFile bkp:Path="%GPO_FSPATH%\Adm\*.*" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Adm\*.*"/>
        </GroupPolicyExtension>
        
        
        
        
        <GroupPolicyExtension bkp:ID="{827D319E-6EAC-11D2-A4EA-00C04F79F83A}" bkp:DescName="Security">
            <FSObjectFile bkp:Path="%GPO_MACH_FSPATH%\microsoft\windows nt\SecEdit\GptTmpl.inf" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Machine\microsoft\windows nt\SecEdit\GptTmpl.inf" bkp:ReEvaluateFunction="SecurityValidateSettings" bkp:Location="DomainSysvol\GPO\Machine\microsoft\windows nt\SecEdit\GptTmpl.inf"/>
        </GroupPolicyExtension>
        
        
        
        
    <GroupPolicyExtension bkp:ID="{F15C46CD-82A0-4C2D-A210-5D0D3182A418}" bkp:DescName="Unknown Extension"><FSObjectDir bkp:Path="%GPO_MACH_FSPATH%\Microsoft" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Machine\Microsoft" bkp:Location="DomainSysvol\GPO\Machine\Microsoft"/><FSObjectDir bkp:Path="%GPO_MACH_FSPATH%\Microsoft\Windows NT" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Machine\Microsoft\Windows NT" bkp:Location="DomainSysvol\GPO\Machine\Microsoft\Windows NT"/><FSObjectDir bkp:Path="%GPO_MACH_FSPATH%\Microsoft\Windows NT\SecEdit" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Machine\Microsoft\Windows NT\SecEdit" bkp:Location="DomainSysvol\GPO\Machine\Microsoft\Windows NT\SecEdit"/><FSObjectDir bkp:Path="%GPO_MACH_FSPATH%\Scripts" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Machine\Scripts" bkp:Location="DomainSysvol\GPO\Machine\Scripts"/><FSObjectDir bkp:Path="%GPO_MACH_FSPATH%\Scripts\Shutdown" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Machine\Scripts\Shutdown" bkp:Location="DomainSysvol\GPO\Machine\Scripts\Shutdown"/><FSObjectDir bkp:Path="%GPO_MACH_FSPATH%\Scripts\Startup" bkp:SourceExpandedPath="\\dc.dummy.domain\sysvol\dummy.domain\Policies\{12345678-1234-1234-1234-123456789012}\Machine\Scripts\Startup" bkp:Location="DomainSysvol\GPO\Machine\Scripts\Startup"/></GroupPolicyExtension></GroupPolicyObject>
</GroupPolicyBackupScheme>
"@
            Write-Verbose -Message "Writing file: [ $backupxmlPath ]"
            $backupxml | Out-File -FilePath $backupxmlPath -Encoding 'utf8' -ErrorAction Stop
        }

        catch {

            Write-Error -Message "Error writing file: [ $backupxmlPath ]"
        }

    } else {

        Write-Verbose -Message "[ $backupxmlPath ] - Already exists"
    }

    if(-not(Test-Path -Path $gptTmplinfPath -PathType Leaf)) {

        try{

            $gptTmpl = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO$"
Revision=1
"@
    
            Write-Verbose -Message "Writing file: [ $gptTmplinfPath ]"
            $gptTmpl | Out-File -FilePath $gptTmplinfPath -Encoding 'unicode' -ErrorAction Stop

        }

        catch {

            Write-Error -Message "Error writing file: [ $gptTmplinfPath ]"
        }

    } else {

        Write-Verbose -Message "[ $gptTmplinfPath ] - Already exists"
    }
}
