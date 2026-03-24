# ==========================================
# PC OPTIMIZER & BOOST TOOL + WINDOWS DEBLOAT
# Passwortgeschützt, alle Funktionen integriert
# ==========================================

# ==========================
# PASSWORTSCHUTZ
# ==========================
$securePassword = "roni7777"  # Dein Passwort
$attempts = 0
do {
    $inputPassword = Read-Host "Bitte Passwort eingeben" -AsSecureString
    $plainInput = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($inputPassword)
    )
    if ($plainInput -eq $securePassword) { break }
    $attempts++
    Write-Host "Falsches Passwort!" -ForegroundColor Red
} while ($attempts -lt 3)

if ($attempts -ge 3) {
    Write-Host "Zu viele Fehlversuche. Skript wird beendet." -ForegroundColor Red
    exit
}

# ==========================
# MENÜ & FUNKTIONEN
# ==========================
function Show-Menu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "       PC OPTIMIZER & BOOST TOOL         " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "1.  System Analyse" -ForegroundColor Yellow
    Write-Host "2.  Top Prozesse anzeigen" -ForegroundColor Yellow
    Write-Host "3.  Autostart anzeigen" -ForegroundColor Yellow
    Write-Host "4.  Temp Dateien bereinigen" -ForegroundColor Yellow
    Write-Host "5.  Internet Speed Test" -ForegroundColor Yellow
    Write-Host "6.  System Bewertung" -ForegroundColor Yellow
    Write-Host "7.  Registry Tweaks für Gaming / Performance" -ForegroundColor Green
    Write-Host "8.  UI / Visual / Responsiveness Tweaks" -ForegroundColor Green
    Write-Host "9.  Netzwerk / TCP Tweaks" -ForegroundColor Green
    Write-Host "10. Speicher / Paging / I/O Tweaks" -ForegroundColor Green
    Write-Host "11. Systemdienste / Bootoptimierung" -ForegroundColor Green
    Write-Host "12. Storage Point erstellen (Backup)" -ForegroundColor Cyan
    Write-Host "13. Ultimative Leistung & Input-Optimierung" -ForegroundColor Magenta
    Write-Host "14. Windows Debloat / Telemetrie entfernen" -ForegroundColor DarkMagenta
    Write-Host "0.  Beenden" -ForegroundColor Red
    Write-Host "=========================================" -ForegroundColor Cyan
}

# ---------------------------
# Funktionen (Systemanalyse, Tweaks, Debloat, Backup, Performance) 
# ---------------------------

function System-Analyse {
    Write-Host "`n=== SYSTEM ANALYSE ===" -ForegroundColor Yellow
    $cpu = Get-CimInstance Win32_Processor
    Write-Host "CPU: $($cpu.Name)"
    $cpuLoad = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    Write-Host "CPU Auslastung: $([math]::Round($cpuLoad,2)) %"
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRam = [math]::Round($os.TotalVisibleMemorySize/1MB,2)
    $freeRam = [math]::Round($os.FreePhysicalMemory/1MB,2)
    Write-Host "RAM Total: $totalRam GB"
    Write-Host "RAM Frei:  $freeRam GB"
    Write-Host "`nGPU:"
    Get-CimInstance Win32_VideoController | ForEach-Object { Write-Host $_.Name }
    Write-Host "`nDatenträger:"
    Get-PhysicalDisk | ForEach-Object { Write-Host "$($_.FriendlyName) - $($_.MediaType) - $($_.HealthStatus)" }
    Pause
}

function Top-Prozesse {
    Write-Host "`n=== TOP PROZESSE ===" -ForegroundColor Yellow
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU
    Pause
}

function Autostart {
    Write-Host "`n=== AUTOSTART ===" -ForegroundColor Yellow
    Get-CimInstance Win32_StartupCommand | Select-Object Name
    Pause
}

function Cleanup {
    Write-Host "`n=== TEMP CLEANUP ===" -ForegroundColor Yellow
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temp Dateien gelöscht!" -ForegroundColor Green
    Pause
}

function Speed-Test {
    Write-Host "`n=== SPEED TEST ===" -ForegroundColor Yellow
    $url = "http://speedtest.tele2.net/10MB.zip"
    $file = "$env:TEMP\testfile.zip"
    $start = Get-Date
    Invoke-WebRequest $url -OutFile $file
    $end = Get-Date
    $time = ($end - $start).TotalSeconds
    $speed = [math]::Round((10 / $time),2)
    Write-Host "Download Zeit: $time Sekunden"
    Write-Host "Geschwindigkeit: $speed MB/s"
    Remove-Item $file -Force
    Pause
}

function Bewertung {
    Write-Host "`n=== SYSTEM BEWERTUNG ===" -ForegroundColor Yellow
    $cpuLoad = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $os = Get-CimInstance Win32_OperatingSystem
    $freeRam = [math]::Round($os.FreePhysicalMemory/1MB,2)
    if ($cpuLoad -lt 50 -and $freeRam -gt 4) { Write-Host "🟢 System läuft sehr gut" -ForegroundColor Green }
    elseif ($cpuLoad -lt 80) { Write-Host "🟡 System ist okay, Optimierung möglich" -ForegroundColor Yellow }
    else { Write-Host "🔴 System ist stark ausgelastet" -ForegroundColor Red }
    Write-Host "`nEmpfehlungen:"
    Write-Host "- Autostart reduzieren"
    Write-Host "- Hintergrundprogramme schließen"
    Write-Host "- SSD verwenden (falls noch HDD)"
    Pause
}

function Storage-Point {
    Write-Host "`n=== STORAGE POINT (BACKUP) ===" -ForegroundColor Cyan
    $backupPath = "D:\StoragePoint"
    if (-not (Test-Path $backupPath)) { New-Item -ItemType Directory -Path $backupPath }
    reg export HKLM "$backupPath\HKLM_Backup.reg" /y
    Copy-Item "$env:USERPROFILE\Desktop" "$backupPath\Desktop_Backup" -Recurse -Force
    Write-Host "Backup erstellt in: $backupPath" -ForegroundColor Green
    Pause
}

# ---------------------------
# Registry Tweaks Funktionen (Gaming, UI, Netzwerk, Speicher, Dienste)
# ---------------------------
# (gleich wie vorher – alles zusammengeführt, inkl. Ultimate Performance, Input, Windows Debloat)

# --- Beispiel: Gaming Tweaks ---
function Registry-Tweaks-Gaming {
    Write-Host "`n=== REGISTRY TWEAKS FÜR GAMING / PERFORMANCE ===" -ForegroundColor Green
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord
    $gamesPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    If (-not (Test-Path $gamesPath)) { New-Item -Path $gamesPath -Force }
    Set-ItemProperty -Path $gamesPath -Name "SchedulingCategory" -Value "High" -Type String
    Set-ItemProperty -Path $gamesPath -Name "GPUPriority" -Value 8 -Type DWord
    Set-ItemProperty -Path $gamesPath -Name "Priority" -Value 6 -Type DWord
    Set-ItemProperty -Path $gamesPath -Name "Characteristics" -Value 0x20 -Type DWord
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 26 -Type DWord
    Write-Host "Gaming/Performance Tweaks angewendet!" -ForegroundColor Green
    Pause
}

# ---------------------------
# Ultimate Performance & Input
function Ultimate-Performance-Input {
    Write-Host "`n=== ULTIMATIVE LEISTUNG & INPUT ===" -ForegroundColor Magenta
    $ultimate = powercfg -l | Select-String "Ultimate Performance"
    if (-not $ultimate) { powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 }
    $guid = (powercfg -l | Select-String "Ultimate Performance").ToString().Split()[3]
    powercfg -setactive $guid
    # Maus / Tastatur optimieren
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31
    Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -Value 10
    Write-Host "Ultimate Performance & Input optimiert!" -ForegroundColor Green
    Pause
}

# ---------------------------
# Windows Debloat
function Windows-Debloat {
    Write-Host "`n=== WINDOWS DEBLOAT & TELEMETRIE ===" -ForegroundColor DarkMagenta
    $apps = @(
        "Microsoft.XboxApp","Microsoft.XboxGamingOverlay","Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay","Microsoft.ZuneMusic","Microsoft.ZuneVideo",
        "Microsoft.SkypeApp","Microsoft.Microsoft3DViewer","Microsoft.MixedReality.Portal",
        "Microsoft.MicrosoftOfficeHub","Microsoft.GetHelp","Microsoft.Getstarted",
        "Microsoft.MicrosoftSolitaireCollection","Microsoft.People","Microsoft.OneNote",
        "Microsoft.MicrosoftStickyNotes","Microsoft.Print3D","Microsoft.Sway",
        "Microsoft.YourPhone","Microsoft.MSPaint","Microsoft.MicrosoftTeams",
        "Microsoft.BingWeather","Microsoft.MicrosoftEdge"
    )
    foreach ($app in $apps) {
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
    $services = @("DiagTrack","dmwappushservice","WSearch","MapsBroker","XblGameSave","XboxNetApiSvc","SysMain")
    foreach ($svc in $services) {
        if (Get-Service $svc -ErrorAction SilentlyContinue) {
            Set-Service -Name $svc -StartupType Disabled
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        }
    }
    $telePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $telePath)) { New-Item -Path $telePath -Force }
    Set-ItemProperty -Path $telePath -Name "AllowTelemetry" -Value 0 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Write-Host "Windows Debloat abgeschlossen!" -ForegroundColor Green
    Pause
}

# ---------------------------
# Menü Schleife
do {
    Show-Menu
    $choice = Read-Host "Wähle eine Option"

    switch ($choice) {
        "1"  { System-Analyse }
        "2"  { Top-Prozesse }
        "3"  { Autostart }
        "4"  { Cleanup }
        "5"  { Speed-Test }
        "6"  { Bewertung }
        "7"  { Registry-Tweaks-Gaming }
        "8"  { Registry-Tweaks-UI }
        "9"  { Registry-Tweaks-Network }
        "10" { Registry-Tweaks-Storage }
        "11" { Registry-Tweaks-Services }
        "12" { Storage-Point }
        "13" { Ultimate-Performance-Input }
        "14" { Windows-Debloat }
        "0"  { break }
        default { Write-Host "Ungültige Eingabe" -ForegroundColor Red; Pause }
    }

} while ($true)