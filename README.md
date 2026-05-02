# ASUS TUF Hibernate Guard
A failsafe script to force hibernation on ASUS TUF laptops after 30 mins of physical idleness, bypassing Windows Modern Standby issues.

## Setup
1. Place `HibernateGuard.ps1` in `C:\Scripts\`.
2. Run this in Admin PowerShell to register the background task:
```powershell
$path = "C:\Scripts\HibernateGuard.ps1"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$path`""
Register-ScheduledTask -TaskName "AbsoluteHibernateGuard" -Action $action -Trigger (New-ScheduledTaskTrigger -AtLogon) -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable) -RunLevel Highest -Force
Start-ScheduledTask -TaskName "AbsoluteHibernateGuard"
```

## Stop (Emergency Kill)
Run in Admin PowerShell:
```powershell
Stop-ScheduledTask -TaskName "AbsoluteHibernateGuard"
Stop-Process -Id (Get-ScheduledTaskInfo -TaskName "AbsoluteHibernateGuard").LastRunTime
```
Or if you know the PID:
```powershell
Stop-Process -Id  -Force
```
To find the PID:
```powershell
Get-Process -Name powershell | Select-Object Id, StartTime, CPU
```

## Disable Permanently
```powershell
Unregister-ScheduledTask -TaskName "AbsoluteHibernateGuard" -Confirm:$false
```
