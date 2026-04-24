Add-Type @'
using System;
using System.Runtime.InteropServices;
public class UserInput {
    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);
    [StructLayout(LayoutKind.Sequential)]
    public struct LASTINPUTINFO {
        public uint cbSize;
        public uint dwTime;
    }
    public static DateTime LastInput {
        get {
            LASTINPUTINFO lii = new LASTINPUTINFO();
            lii.cbSize = (uint)Marshal.SizeOf(lii);
            if (GetLastInputInfo(ref lii)) {
                return DateTime.Now.AddMilliseconds(-(Environment.TickCount - lii.dwTime));
            }
            return DateTime.Now;
        }
    }
}
'@

$IdleLimitMinutes = 30 

while($true) {
    $last = [UserInput]::LastInput
    $idleTime = ([DateTime]::Now - $last).TotalMinutes
    if ($idleTime -ge $IdleLimitMinutes) {
        & shutdown.exe /h
    }
    Start-Sleep -Seconds 60
}

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

