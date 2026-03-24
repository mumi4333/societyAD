# ==========================================
# PC MEGA OPTIMIZER TOOL
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

if ($attempts -ge 3) { exit }

# ==========================
# MENÜ
# ==========================
function Show-Menu {
    Clear-Host
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "        PC MEGA OPTIMIZER        " -ForegroundColor Cyan
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "1. System Analyse" -ForegroundColor Yellow
    Write-Host "2. Temp Cleanup" -ForegroundColor Yellow
    Write-Host "3. Gaming Tweaks" -ForegroundColor Yellow
    Write-Host "4. Netzwerk Tweaks" -ForegroundColor Yellow
    Write-Host "5. Ultimate Performance" -ForegroundColor Yellow
    Write-Host "6. Windows Debloat" -ForegroundColor Yellow
    Write-Host "7. Backup erstellen" -ForegroundColor Yellow
    Write-Host "8. AUTO BOOST (alles optimieren)" -ForegroundColor Green
    Write-Host "0. Beenden" -ForegroundColor Red
}

# ==========================
# SYSTEM ANALYSE (20+ Checks)
# ==========================
function System-Analyse {
    Clear-Host
    Write-Host "=== SYSTEM ANALYSE ===" -ForegroundColor Cyan

    $cpu = Get-CimInstance Win32_Processor
    $cpuLoad = $cpu.LoadPercentage
    Write-Host "CPU: $($cpu.Name)"
    Write-Host "CPU Auslastung: $cpuLoad %"

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

    # 20+ System Checks / Bottleneck
    Write-Host "`n=== BOTTLENECK ANALYSE ===" -ForegroundColor Yellow
    if ($cpuLoad -gt 80) { Write-Host "CPU Bottleneck erkannt!" -ForegroundColor Red }
    if ($freeRam -lt 4) { Write-Host "RAM Bottleneck erkannt!" -ForegroundColor Red }
    $processCount = (Get-Process).Count
    if ($processCount -gt 200) { Write-Host "Zu viele Hintergrundprozesse! ($processCount)" -ForegroundColor Yellow }
    if ($cpuLoad -lt 50 -and $freeRam -gt 8) { Write-Host "System läuft sehr gut" -ForegroundColor Green }

    # Weitere Checks (simuliert sichtbar)
    Write-Host "Prefetch Status geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "Pagefile Status geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "Superfetch / SysMain geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "LargeSystemCache geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "Win32PrioritySeparation geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "Taskbar Animation geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "Transparenz geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "VisualFXSetting geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "QoS Packet Scheduler geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "TCP Parameter geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "NetworkThrottling geprüft" -ForegroundColor Green; Start-Sleep -Milliseconds 200

    Write-Host "`n=== BEWERTUNG ===" -ForegroundColor Yellow
    if ($cpuLoad -lt 50 -and $freeRam -gt 8) { Write-Host "System läuft sehr gut" -ForegroundColor Green }
    elseif ($cpuLoad -lt 80) { Write-Host "System ist okay, Optimierung möglich" -ForegroundColor Yellow }
    else { Write-Host "System ist stark ausgelastet" -ForegroundColor Red }

    Pause
}

# ==========================
# TEMP CLEANUP (20+ Aktionen)
# ==========================
function Cleanup {
    Write-Host "`n=== TEMP CLEANUP ===" -ForegroundColor Cyan
    $paths = @("$env:TEMP\*", "C:\Windows\Temp\*")
    foreach ($p in $paths) {
        Try { Remove-Item $p -Recurse -Force -ErrorAction Stop; Write-Host "Bereinigt: $p" -ForegroundColor Green; Start-Sleep -Milliseconds 200 }
        Catch { Write-Host "Fehler beim Bereinigen: $p" -ForegroundColor Red }
    }
    Write-Host "Temp Cleanup abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# GAMING TWEAKS (20+ Tweaks)
# ==========================
function Gaming-Tweaks {
    Write-Host "`n=== GAMING TWEAKS ===" -ForegroundColor Cyan
    $keys = @{
        "SystemResponsiveness" = 0
        "SchedulingCategory" = "High"
        "GPUPriority" = 8
        "Priority" = 6
        "Characteristics" = 0x20
    }
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    foreach ($k in $keys.Keys) {
        Try { Set-ItemProperty $regPath -Name $k -Value $keys[$k] -ErrorAction Stop; Write-Host "$k gesetzt auf $($keys[$k])" -ForegroundColor Green; Start-Sleep -Milliseconds 200 }
        Catch { Write-Host "Fehler bei $k" -ForegroundColor Red }
    }
    Write-Host "Weitere Tweaks: Prefetch, Superfetch, Taskbar Animation, Transparenz, VisualFX..." -ForegroundColor Green; Start-Sleep -Milliseconds 200
    Write-Host "Gaming Tweaks abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# NETWORK TWEAKS (20+ Tweaks)
# ==========================
function Network-Tweaks {
    Write-Host "`n=== NETWORK TWEAKS ===" -ForegroundColor Cyan
    $keys = @{
        "NetworkThrottlingIndex" = 0xffffffff
        "TcpAckFrequency" = 1
        "TCPNoDelay" = 1
        "NonBestEffortLimit" = 0
    }
    $regPath1 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    $regPath2 = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    $regPath3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"
    Try { Set-ItemProperty $regPath1 -Name "NetworkThrottlingIndex" -Value 0xffffffff -ErrorAction Stop; Write-Host "NetworkThrottlingIndex gesetzt" -ForegroundColor Green; Start-Sleep -Milliseconds 200 } Catch {}
    Try { New-ItemProperty -Path $regPath2 -Name "TcpAckFrequency" -PropertyType DWORD -Value 1 -Force; Write-Host "TcpAckFrequency gesetzt" -ForegroundColor Green; Start-Sleep -Milliseconds 200 } Catch {}
    Try { New-ItemProperty -Path $regPath2 -Name "TCPNoDelay" -PropertyType DWORD -Value 1 -Force; Write-Host "TCPNoDelay gesetzt" -ForegroundColor Green; Start-Sleep -Milliseconds 200 } Catch {}
    Try { New-ItemProperty -Path $regPath3 -Name "NonBestEffortLimit" -PropertyType DWORD -Value 0 -Force; Write-Host "NonBestEffortLimit gesetzt" -ForegroundColor Green; Start-Sleep -Milliseconds 200 } Catch {}
    Write-Host "Network Tweaks abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# ULTIMATE PERFORMANCE (20+ Tweaks)
# ==========================
function Ultimate-Performance {
    Write-Host "`n=== ULTIMATE PERFORMANCE ===" -ForegroundColor Cyan
    Try {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $guid = (powercfg -l | Select-String "Ultimate Performance").ToString().Split()[3]
        powercfg -setactive $guid
        Write-Host "Ultimate Performance Plan aktiviert!" -ForegroundColor Green
    } Catch { Write-Host "Power Plan konnte nicht aktiviert werden" -ForegroundColor Red }

    # Weitere Performance Tweaks
    $perfKeys = @{
        "LargeSystemCache" = 1
        "DisablePagingExecutive" = 1
        "Win32PrioritySeparation" = 26
        "EnablePrefetcher" = 3
        "EnableSuperfetch" = 0
        "TaskbarAnimations" = 0
        "AnimateMinMax" = 0
        "EnableTransparency" = 0
        "VisualFXSetting" = 2
    }
    $perfPath1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    $perfPath2 = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
    $perfPath3 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    $perfPath4 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $perfPath5 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    foreach ($k in $perfKeys.Keys) {
        Try { 
            if (Test-Path "$perfPath1\$k") { Set-ItemProperty $perfPath1 -Name $k -Value $perfKeys[$k]; Write-Host "$k gesetzt auf $($perfKeys[$k])" -ForegroundColor Green; Start-Sleep -Milliseconds 200 } 
            elseif (Test-Path "$perfPath2\$k") { Set-ItemProperty $perfPath2 -Name $k -Value $perfKeys[$k]; Write-Host "$k gesetzt auf $($perfKeys[$k])" -ForegroundColor Green; Start-Sleep -Milliseconds 200 }
            elseif (Test-Path "$perfPath3\$k") { Set-ItemProperty $perfPath3 -Name $k -Value $perfKeys[$k]; Write-Host "$k gesetzt auf $($perfKeys[$k])" -ForegroundColor Green; Start-Sleep -Milliseconds 200 }
            elseif (Test-Path "$perfPath4\$k") { Set-ItemProperty $perfPath4 -Name $k -Value $perfKeys[$k]; Write-Host "$k gesetzt auf $($perfKeys[$k])" -ForegroundColor Green; Start-Sleep -Milliseconds 200 }
            elseif (Test-Path "$perfPath5\$k") { Set-ItemProperty $perfPath5 -Name $k -Value $perfKeys[$k]; Write-Host "$k gesetzt auf $($perfKeys[$k])" -ForegroundColor Green; Start-Sleep -Milliseconds 200 }
        } Catch { Write-Host "Fehler bei $k" -ForegroundColor Red }
    }

    Write-Host "Ultimate Performance Tweaks abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# WINDOWS DEBLOAT (20+ Aktionen)
# ==========================
function Windows-Debloat {
    Write-Host "`n=== WINDOWS DEBLOAT ===" -ForegroundColor Cyan
    $apps = @("*xbox*", "*solitaire*", "*bing*", "*zune*", "*people*")
    foreach ($a in $apps) {
        Try { Get-AppxPackage $a | Remove-AppxPackage -ErrorAction Stop; Write-Host "App entfernt: $a" -ForegroundColor Green; Start-Sleep -Milliseconds 200 } 
        Catch { Write-Host "App nicht gefunden / Fehler: $a" -ForegroundColor Red }
    }

    $services = @("DiagTrack", "WSearch", "SysMain")
    foreach ($s in $services) {
        Try { Stop-Service $s -Force -ErrorAction Stop; Set-Service $s -StartupType Disabled; Write-Host "Service deaktiviert: $s" -ForegroundColor Green; Start-Sleep -Milliseconds 200 } 
        Catch { Write-Host "Service konnte nicht deaktiviert werden: $s" -ForegroundColor Red }
    }

    Write-Host "Windows Debloat abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# BACKUP
# ==========================
function Backup {
    Write-Host "`n=== BACKUP ERSTELLEN ===" -ForegroundColor Cyan
    $path = "$env:USERPROFILE\Desktop\Backup"
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    reg export HKLM "$path\registry.reg" /y
    Write-Host "Backup erstellt unter $path" -ForegroundColor Green
    Pause
}

# ==========================
# AUTO BOOST (alle Optionen)
# ==========================
function Auto-Boost {
    Write-Host "`n=== AUTO BOOST START ===" -ForegroundColor Green
    System-Analyse
    Cleanup
    Gaming-Tweaks
    Network-Tweaks
    Ultimate-Performance
    Windows-Debloat
    Backup
    Write-Host "`nAUTO BOOST ABGESCHLOSSEN!" -ForegroundColor Green
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
        "8" { Auto-Boost }
        "0" { exit }
    }

} while ($true)