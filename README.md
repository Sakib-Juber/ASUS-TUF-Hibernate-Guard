# ASUS TUF Hibernate Guard
A failsafe script to force hibernation on ASUS TUF laptops after 30 mins of physical idleness, bypassing Windows Modern Standby issues.

## Why this exists
Windows Modern Standby (S0) often fails to enter deep sleep on ASUS TUF series laptops, leading to battery drain and heat while in a bag. This script monitors raw user input and forces a hardware hibernation (S4) after 30 minutes of true inactivity.

## Setup
1. Create the folder `C:\Scripts\` and place `HibernateGuard.ps1` inside it.
2. Open **PowerShell (Admin)** (Win+X > A).
3. Run the following block to register the task as a silent background service:

```powershell
$path = "C:\Scripts\HibernateGuard.ps1"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$path`""

$trigger = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Runs as SYSTEM to ensure the script is 100% invisible (no blue window flash)
Register-ScheduledTask -TaskName "AbsoluteHibernateGuard" `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -User "SYSTEM" `
    -RunLevel Highest `
    -Force

Start-ScheduledTask -TaskName "AbsoluteHibernateGuard"

### Updated README Section: Maintenance
You can add this to the bottom of your GitHub `README.md`:

```markdown
## Maintenance & Controls

If you need to manage the guard (e.g., while watching a long movie or during a system update), use these Admin PowerShell commands:

**1. Stop the guard immediately (Current session only):**
```powershell
Stop-ScheduledTask -TaskName "AbsoluteHibernateGuard"
```

**2. Disable the guard (Prevents it from starting on next boot):**
```powershell
Disable-ScheduledTask -TaskName "AbsoluteHibernateGuard"
```

**3. Re-enable the guard:**
```powershell
Enable-ScheduledTask -TaskName "AbsoluteHibernateGuard"
```

**4. Completely Uninstall / Remove the guard:**
```powershell
Unregister-ScheduledTask -TaskName "AbsoluteHibernateGuard" -Confirm:$false
```
```

### Pro-Tip for your ASUS TUF
Since you're using this to solve **Modern Standby** issues—which are notorious on the TUF series—keeping these commands in your README is a great way to ensure you don't forget the task name months from now when you might need to troubleshoot a different power issue.

