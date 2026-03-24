# ==========================================
# PC OPTIMIZER TOOL (IMPROVED VERSION)
# ==========================================

# ==========================
# PASSWORTSCHUTZ
# ==========================
$securePassword = "roni7777"
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
    Write-Host "Zu viele Fehlversuche." -ForegroundColor Red
    exit
}

# ==========================
# MENÜ
# ==========================
function Show-Menu {
    Clear-Host
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "        PC OPTIMIZER TOOL        " -ForegroundColor Cyan
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "1. System Analyse" -ForegroundColor Yellow
    Write-Host "2. Temp Cleanup" -ForegroundColor Yellow
    Write-Host "3. Gaming Tweaks" -ForegroundColor Green
    Write-Host "4. Netzwerk Tweaks" -ForegroundColor Green
    Write-Host "5. Ultimate Performance" -ForegroundColor Magenta
    Write-Host "6. Windows Debloat" -ForegroundColor Magenta
    Write-Host "7. Backup erstellen" -ForegroundColor Cyan
    Write-Host "0. Beenden" -ForegroundColor Red
}

# ==========================
# FUNKTIONEN
# ==========================

function System-Analyse {
    Clear-Host
    Write-Host "=== SYSTEM ANALYSE ===" -ForegroundColor Cyan

    # CPU
    $cpu = Get-CimInstance Win32_Processor
    $cpuLoad = $cpu.LoadPercentage
    Write-Host "CPU: $($cpu.Name)"
    Write-Host "CPU Auslastung: $cpuLoad %"

    # RAM
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRam = [math]::Round($os.TotalVisibleMemorySize/1MB,2)
    $freeRam = [math]::Round($os.FreePhysicalMemory/1MB,2)
    $usedRam = [math]::Round($totalRam - $freeRam,2)

    Write-Host "RAM Total: $totalRam GB"
    Write-Host "RAM Belegt: $usedRam GB"
    Write-Host "RAM Frei: $freeRam GB"

    # GPU
    Write-Host "`nGPU:"
    Get-CimInstance Win32_VideoController | ForEach-Object {
        Write-Host "- $($_.Name)"
    }

    # Disk
    Write-Host "`nDatenträger:"
    Get-PhysicalDisk | ForEach-Object {
        $status = $_.HealthStatus
        $type = $_.MediaType

        if ($status -eq "Healthy") {
            Write-Host "- $($_.FriendlyName) | $type | OK" -ForegroundColor Green
        } else {
            Write-Host "- $($_.FriendlyName) | $type | PROBLEM" -ForegroundColor Red
        }
    }

    # Top Prozesse
    Write-Host "`nTop Prozesse (CPU aktuell):"
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU | Format-Table -AutoSize

    # =====================
    # BOTTLENECK ANALYSE
    # =====================
    Write-Host "`n=== BOTTLENECK ANALYSE ===" -ForegroundColor Yellow

    if ($cpuLoad -gt 80) {
        Write-Host "CPU Bottleneck erkannt!" -ForegroundColor Red
    }

    if ($freeRam -lt 4) {
        Write-Host "RAM Bottleneck erkannt!" -ForegroundColor Red
    }

    $processCount = (Get-Process).Count
    if ($processCount -gt 200) {
        Write-Host "Zu viele Hintergrundprozesse! ($processCount)" -ForegroundColor Yellow
    }

    # =====================
    # BEWERTUNG
    # =====================
    Write-Host "`n=== BEWERTUNG ===" -ForegroundColor Yellow

    if ($cpuLoad -lt 50 -and $freeRam -gt 8) {
        Write-Host "System läuft sehr gut" -ForegroundColor Green
    }
    elseif ($cpuLoad -lt 80) {
        Write-Host "System ist okay, Optimierung möglich" -ForegroundColor Yellow
    }
    else {
        Write-Host "System ist stark ausgelastet" -ForegroundColor Red
    }

    Pause
}

function Cleanup {
    Write-Host "`nCLEANUP..." -ForegroundColor Yellow

    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Temp Dateien gelöscht!" -ForegroundColor Green
    Pause
}

function Gaming-Tweaks {
    Write-Host "`nGAMING TWEAKS..." -ForegroundColor Green

    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
    -Name "SystemResponsiveness" -Value 0

    Write-Host "Gaming Tweaks angewendet!" -ForegroundColor Green
    Pause
}

function Network-Tweaks {
    Write-Host "`nNETZWERK TWEAKS..." -ForegroundColor Green

    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
    -Name "NetworkThrottlingIndex" -Value 0xffffffff

    Write-Host "Netzwerk Tweaks angewendet!" -ForegroundColor Green
    Pause
}

function Ultimate-Performance {
    Write-Host "`nULTIMATE PERFORMANCE..." -ForegroundColor Magenta

    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    $guid = (powercfg -l | Select-String "Ultimate Performance").ToString().Split()[3]
    powercfg -setactive $guid

    # Input Optimierung
    Set-ItemProperty "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 31
    Set-ItemProperty "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0

    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0

    Write-Host "Ultimate Performance aktiviert!" -ForegroundColor Green
    Pause
}

function Windows-Debloat {
    Write-Host "`nWINDOWS DEBLOAT..." -ForegroundColor Magenta

    Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue

    Stop-Service "DiagTrack" -Force -ErrorAction SilentlyContinue
    Set-Service "DiagTrack" -StartupType Disabled

    Write-Host "Debloat abgeschlossen!" -ForegroundColor Green
    Pause
}

function Backup {
    Write-Host "`nBACKUP..." -ForegroundColor Cyan

    $path = "$env:USERPROFILE\Desktop\Backup"
    New-Item -ItemType Directory -Path $path -Force | Out-Null

    reg export HKLM "$path\registry.reg" /y

    Write-Host "Backup erstellt!" -ForegroundColor Green
    Pause
}

# ==========================
# LOOP
# ==========================
do {
    Show-Menu
    $choice = Read-Host "Option wählen"

    switch ($choice) {
        "1" { System-Analyse }
        "2" { Cleanup }
        "3" { Gaming-Tweaks }
        "4" { Network-Tweaks }
        "5" { Ultimate-Performance }
        "6" { Windows-Debloat }
        "7" { Backup }
        "0" { 
            Write-Host "Programm wird beendet..." -ForegroundColor Red
            Start-Sleep 1
            exit
        }
        default { Write-Host "Ungültige Eingabe" -ForegroundColor Red; Pause }
    }

} while ($true)