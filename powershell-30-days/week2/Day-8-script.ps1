<#
.SYNOPSIS
    Finds stale user accounts inactive for a specified number of days.
.DESCRIPTION
    Imports user data from a CSV file, filters by last logon date,
    and exports stale accounts to a report file.
.AUTHOR
    Cinco
#>

[CmdletBinding()]
param (
    [Parameter()]
    [int]$DaysInactive = 90,

    [Parameter()]
    [string]$CsvPath = "./users.csv",

    [Parameter()]
    [string]$ExportPath = "./stale-users.csv"
)

# Check CSV exists
If (-not (Test-Path $CsvPath)) {
    Write-Host "ERROR — File not found: $CsvPath"
    Return
}

# Import and filter stale users
Try {
    $StaleUsers = Import-Csv $CsvPath | Where-Object { [datetime]$_.LastLogonDate -lt (Get-Date).AddDays(-$DaysInactive) }
} Catch {
    Write-Host "ERROR — $($_.Exception.Message)"
    Return
}

# Loop through each stale user
ForEach ($user in $StaleUsers) {
    Write-Host "Username: $($user.Username) — Last Logon: $($user.LastLogonDate) — Department: $($user.Department)"
}

# Overall decision
If ($StaleUsers.Count -gt 1) {
    Write-Host "CRITICAL — $($StaleUsers.Count) stale users found"
} Else {
    Write-Host "All clear"
}

# Export results
$StaleUsers | Export-Csv -Path $ExportPath -NoTypeInformation
Write-Host "Stale users found: $($StaleUsers.Count)"