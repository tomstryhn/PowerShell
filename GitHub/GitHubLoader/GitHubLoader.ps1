$sourceUrl  = 'https://raw.githubusercontent.com/tomstryhn/PowerShell/main/GitHub/sources.json'
$sourceList = (Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing).Content | ConvertFrom-Json

foreach($script in $sourceList) {

    Invoke-Expression -Command ((Invoke-WebRequest -Uri $script.sourcecode -UseBasicParsing).Content)
}
