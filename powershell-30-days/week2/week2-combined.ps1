<#
.SYNOPSIS
    Finds stale user accounts inactive for a specified number of days.
.DESCRIPTION
    Imports user data from a CSV file, filters accounts by last logon date,
    logs all activity with timestamps, and exports results to a report folder.
.AUTHOR
    Desmi Lewis
#>

[CmdletBinding()]
param (
    [Parameter()]
    [int]$DaysInactive = 90,

    [Parameter()]
    [string]$CsvPath = "./users.csv",

    [Parameter()]
    [string]$ReportPath = "./reports"
)

# Create reports folder if missing
If (-not (Test-Path $ReportPath)) {
    New-Item -ItemType Directory -Path $ReportPath
}

# Clear log at start
Clear-Content "$ReportPath/activity.log" -ErrorAction SilentlyContinue

# Check CSV exists
If (Test-Path $CsvPath) {
    Add-Content "$ReportPath/activity.log" -Value "$(Get-Date) — File found: $CsvPath"
} Else {
    Add-Content "$ReportPath/activity.log" -Value "$(Get-Date) — ERROR — File not found: $CsvPath"
    Return
}

# Import and filter stale users
Try {
    $StaleUsers = Import-Csv $CsvPath | Where-Object { [datetime]$_.LastLogonDate -lt (Get-Date).AddDays(-$DaysInactive) }
} Catch {
    Add-Content "$ReportPath/activity.log" -Value "$(Get-Date) — ERROR — $($_.Exception.Message)"
    Return
}

# Check if results are empty
If ($StaleUsers.Count -eq 0) {
    Write-Host "WARNING — No results returned. Check column names."
    Add-Content "$ReportPath/activity.log" -Value "$(Get-Date) — WARNING — No results returned"
    Return
}

# Log count
Add-Content "$ReportPath/activity.log" -Value "$(Get-Date) — Found $($StaleUsers.Count) stale users"

# Loop through each stale user and assign severity
ForEach ($user in $StaleUsers) {
    $DaysSinceLogon = (New-TimeSpan -Start ([datetime]$user.LastLogonDate) -End (Get-Date)).Days

    Switch ($true) {
        ($DaysSinceLogon -gt 180) { Write-Host "$($user.Username) — $($user.Department) — CRITICAL"; Break }
        ($DaysSinceLogon -gt 90)  { Write-Host "$($user.Username) — $($user.Department) — WARNING"; Break }
        Default                    { Write-Host "$($user.Username) — $($user.Department) — OK" }
    }
}

# Overall decision
If ($StaleUsers.Count -gt 0) {
    Write-Host "ACTION REQUIRED — $($StaleUsers.Count) stale users found"
} Else {
    Write-Host "All clear"
}

# Export results
$StaleUsers | Export-Csv -Path "$ReportPath/stale-users.csv" -NoTypeInformation
Add-Content "$ReportPath/activity.log" -Value "$(Get-Date) — Exported to stale-users.csv"
Add-Content "$ReportPath/activity.log" -Value "$(Get-Date) — Script completed"

# Show full log
Get-Content "$ReportPath/activity.log"