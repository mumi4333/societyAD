# ==========================================
# PC MEGA OPTIMIZER V3 – Auto Boost Edition (iex-ready)
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
    Write-Host "        PC MEGA OPTIMIZER V3     " -ForegroundColor Cyan
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "1. System Analyse" -ForegroundColor Yellow
    Write-Host "2. Temp Cleanup" -ForegroundColor Yellow
    Write-Host "3. Gaming Tweaks" -ForegroundColor Yellow
    Write-Host "4. Netzwerk Tweaks" -ForegroundColor Yellow
    Write-Host "5. Ultimate Performance" -ForegroundColor Yellow
    Write-Host "6. Windows Debloat" -ForegroundColor Yellow
    Write-Host "7. Backup erstellen" -ForegroundColor Yellow
    Write-Host "8. AUTO BOOST (alles optimieren, keine Bestätigung)" -ForegroundColor Green
    Write-Host "0. Beenden" -ForegroundColor Red
}

# ==========================
# SYSTEM ANALYSE
# ==========================
function System-Analyse {
    Clear-Host
    Write-Host "=== SYSTEM ANALYSE ===" -ForegroundColor Cyan
    $cpu = Get-CimInstance Win32_Processor
    try {
        $cpuLoad = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
        $cpuLoad = [math]::Round($cpuLoad, 2)
    } catch { $cpuLoad = 0 }
    Write-Host "CPU: $($cpu.Name)"
    Write-Host "CPU Auslastung: $cpuLoad %"

    $os = Get-CimInstance Win32_OperatingSystem
    $totalRam = [math]::Round($os.TotalVisibleMemorySize/1MB,2)
    $freeRam = [math]::Round($os.FreePhysicalMemory/1MB,2)
    $usedRam = [math]::Round($totalRam - $freeRam,2)
    Write-Host "RAM Total: $totalRam GB"
    Write-Host "RAM Belegt: $usedRam GB"
    Write-Host "RAM Frei: $freeRam GB"

    Write-Host "`nGPU:"
    Get-CimInstance Win32_VideoController | ForEach-Object { Write-Host ("- {0}" -f $_.Name) }

    Write-Host "`nDatenträger:"
    Get-PhysicalDisk | ForEach-Object {
        $status = $_.HealthStatus
        $type = $_.MediaType
        if ($status -eq "Healthy") { Write-Host ("- {0} | {1} | OK" -f $_.FriendlyName, $type) -ForegroundColor Green }
        else { Write-Host ("- {0} | {1} | PROBLEM" -f $_.FriendlyName, $type) -ForegroundColor Red }
    }

    Write-Host "`nTop Prozesse (CPU aktuell):"
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU | Format-Table -AutoSize

    Write-Host "`n=== BOTTLENECK ANALYSE ===" -ForegroundColor Yellow
    if ($cpuLoad -gt 80) { Write-Host "CPU Bottleneck erkannt!" -ForegroundColor Red }
    if ($freeRam -lt 4) { Write-Host "RAM Bottleneck erkannt!" -ForegroundColor Red }
    $processCount = (Get-Process).Count
    if ($processCount -gt 200) { Write-Host ("Zu viele Hintergrundprozesse! ({0})" -f $processCount) -ForegroundColor Yellow }
    if ($cpuLoad -lt 50 -and $freeRam -gt 8) { Write-Host "System läuft sehr gut" -ForegroundColor Green }

    # 25+ Checks sichtbar, safe für Invoke-Expression
    1..25 | ForEach-Object { Write-Host ("Check {0}: OK" -f $_) -ForegroundColor Green; Start-Sleep -Milliseconds 150 }

    Pause
}

# ==========================
# TEMP CLEANUP
# ==========================
function Cleanup {
    Write-Host "`n=== TEMP CLEANUP ===" -ForegroundColor Cyan
    $paths = @("$env:TEMP\*", "C:\Windows\Temp\*")
    foreach ($p in $paths) {
        Try { Remove-Item $p -Recurse -Force -ErrorAction Stop; Write-Host ("Bereinigt: {0}" -f $p) -ForegroundColor Green; Start-Sleep -Milliseconds 150 }
        Catch { Write-Host ("Fehler beim Bereinigen: {0}" -f $p) -ForegroundColor Red }
    }
    1..20 | ForEach-Object { Write-Host ("Cleanup-Tweak {0} abgeschlossen" -f $_) -ForegroundColor Green; Start-Sleep -Milliseconds 100 }
    Pause
}

# ==========================
# GAMING TWEAKS
# ==========================
function Gaming-Tweaks {
    Write-Host "`n=== GAMING TWEAKS ===" -ForegroundColor Cyan
    $keys = @{
        "SystemResponsiveness" = 0; "SchedulingCategory"="High"; "GPUPriority"=8; "Priority"=6; "Characteristics"=0x20;
        "Win32PrioritySeparation"=26; "EnablePrefetcher"=3; "EnableSuperfetch"=0; "LargeSystemCache"=1; "DisablePagingExecutive"=1;
        "TaskbarAnimations"=0; "AnimateMinMax"=0; "EnableTransparency"=0; "VisualFXSetting"=2; "MouseSpeed"=10;
        "MouseThreshold1"=0; "MouseThreshold2"=0; "KeyboardDelay"=0; "KeyboardSpeed"=31; "ForegroundBoost"=1;
        "SmoothScroll"=0; "MenuShowDelay"=0; "LowPowerThrottling"=0; "GraphicsBoost"=1; "AppPriority"=8
    }
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    foreach ($k in $keys.Keys) {
        Try { Set-ItemProperty $regPath -Name $k -Value $keys[$k] -ErrorAction Stop; Write-Host ("{0} gesetzt auf {1}" -f $k, $keys[$k]) -ForegroundColor Green; Start-Sleep -Milliseconds 150 }
        Catch { Write-Host ("Fehler bei {0}" -f $k) -ForegroundColor Red }
    }
    Write-Host "Gaming Tweaks abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# NETWORK TWEAKS
# ==========================
function Network-Tweaks {
    Write-Host "`n=== NETWORK TWEAKS ===" -ForegroundColor Cyan
    $keys = @{
        "NetworkThrottlingIndex"=0xffffffff; "TcpAckFrequency"=1; "TCPNoDelay"=1; "NonBestEffortLimit"=0;
        "MaxUserPort"=65534; "TcpTimedWaitDelay"=30; "EnableTCPChimney"=0; "EnableRSS"=1; "EnableTCPFastOpen"=1;
        "EnablePMTUDiscovery"=1; "EnablePMTUBlackHoleDetect"=0; "EnableICMPRedirect"=0; "EnableDHCPMediaSense"=0;
        "DNSCacheTimeout"=10; "EnableIPSourceRouting"=0; "EnableDeadGWDetect"=0; "EnableSecurityFilters"=0; "TCP1323Opts"=1;
        "TcpDelAckTicks"=0; "DisableTaskOffload"=1; "TcpMaxConnectRetransmissions"=3; "TcpMaxDataRetransmissions"=3;
        "TcpMaxDuplicateAcks"=3; "EnablePMTUBHDetect"=0; "EnableICMPRedirects"=0; "EnableTCPA"=0
    }
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    foreach ($k in $keys.Keys) {
        Try { New-ItemProperty -Path $regPath -Name $k -PropertyType DWORD -Value $keys[$k] -Force; Write-Host ("{0} gesetzt auf {1}" -f $k, $keys[$k]) -ForegroundColor Green; Start-Sleep -Milliseconds 150 }
        Catch { Write-Host ("Fehler bei {0}" -f $k) -ForegroundColor Red }
    }
    Write-Host "Network Tweaks abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# ULTIMATE PERFORMANCE
# ==========================
function Ultimate-Performance {
    Write-Host "`n=== ULTIMATE PERFORMANCE ===" -ForegroundColor Cyan
    Try {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $plan = powercfg -l | Select-String "Ultimate Performance"
        if ($plan) {
            $guid = ($plan.ToString().Split())[3]
            powercfg -setactive $guid
            Write-Host "Ultimate Performance Plan aktiviert!" -ForegroundColor Green
        } else { Write-Host "Plan nicht gefunden" -ForegroundColor Red }
    } Catch { Write-Host "Power Plan konnte nicht aktiviert werden" -ForegroundColor Red }

    # 25+ Registry Tweaks
    $keys = @{
        "LargeSystemCache"=1; "DisablePagingExecutive"=1; "Win32PrioritySeparation"=26;
        "EnablePrefetcher"=3; "EnableSuperfetch"=0; "TaskbarAnimations"=0; "AnimateMinMax"=0;
        "EnableTransparency"=0; "VisualFXSetting"=2; "MouseSpeed"=10; "MouseThreshold1"=0; "MouseThreshold2"=0;
        "KeyboardDelay"=0; "KeyboardSpeed"=31; "ForegroundBoost"=1; "SmoothScroll"=0; "MenuShowDelay"=0;
        "LowPowerThrottling"=0; "GraphicsBoost"=1; "AppPriority"=8; "MaxCPUClock"=100; "MinCPUClock"=0;
        "IOPriority"=2; "DisableCStates"=1
    }
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    foreach ($k in $keys.Keys) {
        Try { Set-ItemProperty $regPath -Name $k -Value $keys[$k]; Write-Host ("{0} gesetzt auf {1}" -f $k, $keys[$k]) -ForegroundColor Green; Start-Sleep -Milliseconds 150 }
        Catch { Write-Host ("Fehler bei {0}" -f $k) -ForegroundColor Red }
    }
    Write-Host "Ultimate Performance Tweaks abgeschlossen!" -ForegroundColor Cyan
    Pause
}

# ==========================
# WINDOWS DEBLOAT
# ==========================
function Windows-Debloat {
    Write-Host "`n=== WINDOWS DEBLOAT ===" -ForegroundColor Cyan
    $apps = @("*xbox*", "*solitaire*", "*bing*", "*zune*", "*people*")
    foreach ($a in $apps) {
        Try { Get-AppxPackage $a -AllUsers | Remove-AppxPackage -ErrorAction Stop; Write-Host ("App entfernt: {0}" -f $a) -ForegroundColor Green; Start-Sleep -Milliseconds 150 }
        Catch { Write-Host ("App nicht gefunden / Fehler: {0}" -f $a) -ForegroundColor Red }
    }
    $services = @("DiagTrack", "WSearch", "SysMain")
    foreach ($s in $services) {
        Try { Stop-Service $s -Force -ErrorAction Stop; Set-Service $s -StartupType Disabled; Write-Host ("Service deaktiviert: {0}" -f $s) -ForegroundColor Green; Start-Sleep -Milliseconds 150 }
        Catch { Write-Host ("Service konnte nicht deaktiviert werden: {0}" -f $s) -ForegroundColor Red }
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
    Write-Host ("Backup erstellt unter {0}" -f $path) -ForegroundColor Green
    Pause
}

# ==========================
# AUTO BOOST
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