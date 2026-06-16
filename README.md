# Wheelie Bin Calendar

Automatically generates an iCal (.ics) calendar for bin collections using North Yorkshire Council data.

---

## Quick Start

### 1. Fork or download this repository

Click **Fork** on GitHub or clone locally:

```bash
git clone https://github.com/robboUnplugged/wheelie-bin-calendar.git
```

---

### 2. Get your bin collection URL

1. Open your council bin calendar page
2. Press **F12** (Developer Tools)
3. Go to the **Network** tab
4. Refresh the page
5. Look for a request containing:

```
/ajax?_wrapper_format=drupal_ajax
```

6. Copy the full URL

---

### 3. Set your URL

```powershell
$env:BIN_URL = "your-url-here"
```

---

### 4. Run the script

```powershell
.\Get-WheelieBinCalendar.ps1
```

This will generate:

```
bins.ics
```

---

### 5. (Optional) Automate with GitHub

1. Fork this repo
2. Go to **Settings → Secrets → Actions**
3. Add a new secret:
   - Name: `BIN_URL`
   - Value: your URL
4. Enable **GitHub Pages**
5. Wait for the workflow to run

Your calendar will be available at:

```
https://YOURUSERNAME.github.io/wheelie-bin-calendar/bins.ics
```

---

### 6. Add to Google Calendar

1. Open Google Calendar
2. Click **+ → From URL**
3. Paste your `.ics` link

Your bin calendar will now update automatically.

---

## How it works

- Pulls bin collection data from the council website
- Parses upcoming collection dates
- Generates a calendar file (`bins.ics`)
- Includes reminder notifications (6pm the day before)
