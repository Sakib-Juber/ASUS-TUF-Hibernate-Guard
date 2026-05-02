# ASUS TUF Hibernate Guard

A background script that forces hibernation after 30 minutes of physical idleness, fixing the broken Modern Standby sleep on ASUS TUF laptops.

---

## Setup

**Step 1:** Save `HibernateGuard.ps1` to `C:\Scripts\`

**Step 2:** Open PowerShell as Administrator and run:

```powershell
$path = "C:\Scripts\HibernateGuard.ps1"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$path`""
Register-ScheduledTask -TaskName "AbsoluteHibernateGuard" -Action $action -Trigger (New-ScheduledTaskTrigger -AtLogon) -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable) -RunLevel Highest -Force
Start-ScheduledTask -TaskName "AbsoluteHibernateGuard"
```

The script will now run silently in the background and auto-start on every login.

---

## Change the Idle Timeout

1. Open `C:\Scripts\HibernateGuard.ps1`
2. Change this line to however many minutes you want:
```powershell
   $IdleLimitMinutes = 30
```
3. Restart the task in Admin PowerShell:
```powershell
   Stop-ScheduledTask -TaskName "AbsoluteHibernateGuard"
   Start-ScheduledTask -TaskName "AbsoluteHibernateGuard"
```

---

## Emergency Stop

**Step 1:** Find the script's process ID (PID):
```powershell
Get-Process -Name powershell | Select-Object Id, StartTime, CPU
```
Look for the process whose `StartTime` matches when you last started the task.

**Step 2:** Kill it using that PID:
```powershell
Stop-ScheduledTask -TaskName "AbsoluteHibernateGuard"
Stop-Process -Id <PID> -Force
```
Replace `<PID>` with the actual number from Step 1.

---

## Disable Permanently

Removes the task completely so it no longer runs on login:
```powershell
Unregister-ScheduledTask -TaskName "AbsoluteHibernateGuard" -Confirm:$false
```
