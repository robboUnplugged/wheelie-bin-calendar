# Wheelie Bin Calendar

Automatically generates an iCal (.ics) calendar for bin collections using North Yorkshire Council data.

## How it works

- Pulls bin collection data from the council website
- Parses upcoming collection dates
- Generates a calendar file (`bins.ics`)
- Includes reminder notifications (6pm the day before)

## Usage

Set your bin URL as an environment variable:

```powershell
$env:BIN_URL = "your-url-here"
