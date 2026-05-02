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
