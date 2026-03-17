<#
.SYNOPSIS
Generates an iCal (.ics) file for bin collection dates.

.DESCRIPTION
Fetches bin collection data from the North Yorkshire Council website,
parses upcoming collection dates, and generates a calendar file with
reminders (6pm the day before collection).

The bin data URL is provided via the BIN_URL environment variable
to avoid exposing address-specific information.

.PARAMETER None
This script uses the BIN_URL environment variable.

.EXAMPLE
$env:BIN_URL = "your-url-here"
.\Update-BinCalendar.ps1

.NOTES
Author: robboUnplugged
Created: 2026-03-17

Do not commit your BIN_URL to source control.
#>
# Get URL from environment (GitHub secret)
$url = $env:BIN_URL

if (-not $url) {
    throw "BIN_URL environment variable not set"
}

Write-Host "Fetching bin data..."

# Get AJAX data
$response = Invoke-RestMethod $url
$html = $response[1].data

# Decode HTML
Add-Type -AssemblyName System.Web
$html = [System.Web.HttpUtility]::HtmlDecode($html)

Write-Host "Parsing bin collection data..."

# Extract table rows
$rows = [regex]::Matches($html,'<tr.*?>(.*?)</tr>','Singleline')

$events = foreach ($row in $rows) {

    $cells = [regex]::Matches($row.Groups[1].Value,'<td.*?>(.*?)</td>','Singleline')

    if ($cells.Count -ge 3) {

        $date = ($cells[0].Groups[1].Value -replace '<.*?>','').Trim()
        $type = ($cells[2].Groups[1].Value -replace '<.*?>','')
        $type = ($type -replace '\s+',' ').Trim()

        if ($date -and $type) {
            [PSCustomObject]@{
                Date = $date
                Type = $type
            }
        }
    }
}

# Remove past dates
$today = Get-Date
$events = $events | Where-Object { (Get-Date $_.Date) -gt $today }

Write-Host "Found $($events.Count) upcoming collections"

# Build ICS
$ics = @()
$ics += "BEGIN:VCALENDAR"
$ics += "VERSION:2.0"
$ics += "PRODID:-//Wheelie Bin Calendar//EN"

foreach ($e in $events) {

    $date = (Get-Date $e.Date).ToString("yyyyMMdd")

    $ics += "BEGIN:VEVENT"
    $ics += "DTSTART;VALUE=DATE:$date"
    $ics += "DTEND;VALUE=DATE:$date"
    $ics += "SUMMARY:Bin collection – $($e.Type)"
    $ics += "BEGIN:VALARM"
    $ics += "TRIGGER:-PT18H"
    $ics += "ACTION:DISPLAY"
    $ics += "DESCRIPTION:Bin collection tomorrow – $($e.Type)"
    $ics += "END:VALARM"
    $ics += "END:VEVENT"
}

$ics += "END:VCALENDAR"

# Save file
$outFile = "bins.ics"
$ics | Out-File $outFile -Encoding utf8

Write-Host "Calendar generated: $outFile"
