# ===============================
# USB Bootable Maker with automatic Rufus download
# ===============================

# Funktion: USB-Laufwerke auflisten
function Get-USBDrives {
    Get-WmiObject Win32_DiskDrive | Where-Object { $_.InterfaceType -eq "USB" }
}

# Schritt 1: USB einstecken Hinweis
Write-Host "Bitte USB-Stick einstecken. Wenn bereits eingesteckt, kurz aus- und wieder einstecken." -ForegroundColor Yellow
Read-Host "Drücke Enter, wenn bereit"

# Schritt 2: Liste der USB-Laufwerke anzeigen
$usbDrives = Get-USBDrives
if ($usbDrives.Count -eq 0) {
    Write-Host "Kein USB-Stick erkannt. Script wird beendet." -ForegroundColor Red
    exit
}

Write-Host "Gefundene USB-Laufwerke:" -ForegroundColor Green
$counter = 1
foreach ($drive in $usbDrives) {
    Write-Host "$counter. $($drive.Model) - $($drive.DeviceID)"
    $counter++
}

# Schritt 3: Laufwerk auswählen
$selection = Read-Host "Wähle die Nummer des USB-Sticks aus"
$selectedDrive = $usbDrives[$selection - 1]

Write-Host "Du hast folgendes Laufwerk ausgewählt: $($selectedDrive.Model) - $($selectedDrive.DeviceID)" -ForegroundColor Cyan

# Schritt 4: Rufus herunterladen, falls nicht vorhanden
$rufusPath = "$PSScriptRoot\Rufus.exe"
if (-Not (Test-Path $rufusPath)) {
    Write-Host "Rufus.exe wird heruntergeladen..." -ForegroundColor Yellow
    $rufusUrl = "https://github.com/pbatard/rufus/releases/latest/download/Rufus-x64.exe"
    Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath
    Write-Host "Rufus wurde heruntergeladen." -ForegroundColor Green
}

# Schritt 5: Bestätigung Rufus starten
$confirm = Read-Host "Das Script kann Rufus automatisch starten und den Stick bootfähig machen. Fortfahren? (j/n)"
if ($confirm -ne "j") {
    Write-Host "Abgebrochen." -ForegroundColor Red
    exit
}

# Schritt 6: Rufus starten mit ausgewähltem Laufwerk
Start-Process $rufusPath -ArgumentList "/DEVICE=$($selectedDrive.DeviceID)" 
Write-Host "Rufus wird gestartet. Bitte den Rest im Programm bestätigen." -ForegroundColor Green
