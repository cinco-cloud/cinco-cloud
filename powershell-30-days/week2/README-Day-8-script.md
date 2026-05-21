# Day-8-script.ps1

## Description
Finds stale user accounts that have not logged in for a specified number of days.
Imports user data from a CSV file, filters by last logon date, and exports results to a CSV report.

## Requirements
- PowerShell 7+
- Input CSV file with columns: Username, LastLogonDate, Department

## Usage
```powershell
# Run with defaults
. './Day-8-script.ps1'

# Run with custom threshold
. './Day-8-script.ps1' -DaysInactive 60

# Run with custom CSV and export path
. './Day-8-script.ps1' -CsvPath "./audit.csv" -ExportPath "./output.csv"
```

## Parameters
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| DaysInactive | int | 90 | Number of days before account is considered stale |
| CsvPath | string | ./users.csv | Path to the input CSV file |
| ExportPath | string | ./stale-users.csv | Path to the output CSV file |

## Output
- Console output showing each stale user with username, last logon date, and department
- Exported CSV file with stale user details
- CRITICAL warning if more than 1 stale user found

## Author
Desmi Lewis
