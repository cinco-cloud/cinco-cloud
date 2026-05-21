# week2-combined.ps1

## Description
Finds stale user accounts that have not logged in for a specified number of days. 
Filters accounts by last logon date, assigns severity levels (CRITICAL, WARNING, OK), 
logs all activity with timestamps, and exports results to a report folder.

## Requirements
- PowerShell 7+
- Input CSV file with columns: Username, LastLogonDate, Department

## Usage
```powershell
# Run with defaults (90 days, users.csv)
. './week2-combined.ps1'

# Run with custom threshold
. './week2-combined.ps1' -DaysInactive 60

# Run with custom CSV and report path
. './week2-combined.ps1' -CsvPath "./audit.csv" -ReportPath "./logs"
```

## Parameters
| Parameter | Type | Default | Description |
|---|---|---|---|
| DaysInactive | int | 90 | Number of days before account is considered stale |
| CsvPath | string | ./users.csv | Path to the input CSV file |
| ReportPath | string | ./reports | Folder where logs and exports are saved |

## Output
- Console output showing each stale user with severity level
- `stale-users.csv` exported to report folder
- `activity.log` with timestamped audit trail

## Author
Desmi Lewis
