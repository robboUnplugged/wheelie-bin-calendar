# Wheelie Bin Calendar

Automatically generates an iCal (.ics) calendar for bin collections using North Yorkshire Council data.

---

## Setup

Set your bin URL as an environment variable (do not commit this to GitHub):

```powershell
$env:BIN_URL = "your-url-here"
```

---

## Usage

Run the script:

```powershell
.\Get-WheelieBinCalendar.ps1
```

This will generate:

```
bins.ics
```

---

## How it works

- Pulls bin collection data from the council website
- Parses upcoming collection dates
- Generates a calendar file (`bins.ics`)
- Includes reminder notifications (6pm the day before)
