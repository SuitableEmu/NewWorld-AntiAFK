# Made by https://github.com/SuitableEmu
for ($i = 0; $i -lt $minutes; $i++) {
(New-Object -ComObject WScript.Shell).AppActivate((get-process NewWorld).MainWindowTitle)
Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32 -Namespace W;
[W.U32]::mouse_event(6,0,0,0,0);
Start-Sleep 2
#Change this for different time interval, it is now set for 15 minutes (60*15=900)
Start-Sleep 900
}
