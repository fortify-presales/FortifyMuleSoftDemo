#
# Example script to perform Fortify static analysis
#

# Parameters
param (
    [Parameter(Mandatory=$false)]
    [switch]$SkipPDF,
    [Parameter(Mandatory=$false)]
    [switch]$SkipSSC
)

# Import some supporting functions
Import-Module $PSScriptRoot\modules\FortifyFunctions.psm1

# Import local environment specific settings
$EnvSettings = $(ConvertFrom-StringData -StringData (Get-Content ".\.env" | Where-Object {-not ($_.StartsWith('#'))} | Out-String))
$AppName = $EnvSettings['SSC_APP_NAME']
$AppVersion = $EnvSettings['SSC_APP_VER_NAME']
$SSCUrl = $EnvSettings['SSC_URL']
$SSCAuthToken = $EnvSettings['SSC_AUTH_TOKEN'] # CIToken
$ScanSwitches = ""

# Test we have Fortify installed successfully
Test-Environment
if ([string]::IsNullOrEmpty($AppName)) { throw "Application Name has not been set" }
if ([string]::IsNullOrEmpty($AppVersion)) { throw "Application Version has not been set" }

# Run the translation and scan
Write-Host Running translation and scan...

& sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" -clean
& sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" mule-domain/src/main mule-api-app/src/main
& sourceanalyzer '-Dcom.fortify.sca.ProjectRoot=.fortify' $ScanSwitches -b "$AppName" -verbose -build-project "$AppName" -build-version "$AppVersion" -build-label "SNAPSHOT" -scan -f "$($AppName).fpr"


# summarise issue count by analyzer
& fprutility -information -analyzerIssueCounts -listIssues -project "$($AppName).fpr"

if (-not $SkipPDF) {
	Write-Host Generating PDF report...
	& ReportGenerator '-Dcom.fortify.sca.ProjectRoot=.fortify' -user "Demo User" -format pdf -f "$($AppName).pdf" -source "$($AppName).fpr"
}	

if (-not $SkipSSC) {
    Write-Host Uploading results to SSC to $AppName version $AppVersion ...
    & fortifyclient uploadFPR -file "$($AppName).fpr" -url $SSCUrl -authtoken $SSCAuthToken -application $AppName -applicationVersion $AppVersion
}


Write-Host Done.
