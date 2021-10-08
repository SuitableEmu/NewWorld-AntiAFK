# Made by https://github.com/SuitableEmu/
param($minutes = 9999999)
$Game = "steam://rungameid/1063730"
$Cursor = [system.windows.forms.cursor]::clip
Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32 -Namespace W;


$wsh = New-Object -ComObject Wscript.Shell

function Set-WindowStyle {
param(
    [Parameter()]
    [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
                 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
                 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
    $Style = 'SHOW',
    [Parameter()]
    $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
)
    $WindowStates = @{
        FORCEMINIMIZE   = 11; HIDE            = 0
        MAXIMIZE        = 3;  MINIMIZE        = 6
        RESTORE         = 9;  SHOW            = 5
        SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
        SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
        SHOWNA          = 8;  SHOWNOACTIVATE  = 4
        SHOWNORMAL      = 1
    }
    Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

    $Win32ShowWindowAsync = Add-Type –memberDefinition @” 
    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}
function Start-Sleep($seconds) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(10)
    }
   Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}

function Start-Loop {
for ($i = 0; $i -lt $minutes; $i++) {
(Get-Process -Name NewWorld).MainWindowHandle | foreach { Set-WindowStyle MAXIMIZE $_ }
(New-Object -ComObject WScript.Shell).AppActivate((get-process NewWorld).MainWindowTitle)
[W.U32]::mouse_event(6,0,0,0,0);
Start-Sleep 2
(Get-Process -Name NewWorld).MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ }
#Change this for different time interval, it is now set for 15 minutes (60*15=900)
Start-Sleep 900
    }
}

$NewWorld = Get-Process NewWorld -ErrorAction SilentlyContinue
if ($NewWorld){
Write-Host "New World is running..."
Start-Loop
    }
  else {
    Write-Host "Starting New World..."
        Start-Process $Game 

Start-Sleep 70
#Replace the coordiantes X:2500 and Y:1400 with your own from Coordinates-getter.ps1
[system.windows.forms.cursor]::position = New-Object System.Drawing.Point(2500,1400)
Start-Sleep 5
[W.U32]::mouse_event(6,0,0,0,0);
Start-Sleep 5
#Replace the coordiantes X:3000 and Y:1400 with your own from Coordinates-getter.ps1
[system.windows.forms.cursor]::position = New-Object System.Drawing.Point(3000,1400)
Start-Sleep 2
[W.U32]::mouse_event(6,0,0,0,0);
Start-Sleep 5
#Replace the coordiantes X:3000 and Y:1400 with your own from Coordinates-getter.ps1
[system.windows.forms.cursor]::position = New-Object System.Drawing.Point(3000,1400)
Start-Sleep 2
[W.U32]::mouse_event(6,0,0,0,0);
Start-Sleep 120
#Replace the coordiantes X:1700 and Y:800 with your own from Coordinates-getter.ps1
[system.windows.forms.cursor]::position = New-Object System.Drawing.Point(1700,800)
Start-Loop
    }
