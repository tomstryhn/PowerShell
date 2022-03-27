# Defines the source of the script sources
$sourceUrl  = 'https://raw.githubusercontent.com/tomstryhn/PowerShell/main/GitHub/GitHubLoader/sources.json'

# Loads the list directly from GitHub and converts it from Json
$sourceList = (Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing).Content | ConvertFrom-Json

# For each of the functions in the sourcelist
foreach($script in $sourceList) {

    # Get the code directly form the sourcecode url using the Invoke-WebRequest and then 'loads' the function into the session using Invoke-Expression
    Invoke-Expression -Command ((Invoke-WebRequest -Uri $script.sourcecode -UseBasicParsing).Content)
}
