# ===============================
# USB Bootable Maker - Select Drive by Letter (Corrected for direct iex)
# ===============================

# Function: Pause script for user
function Pause {
    Write-Host "Press Enter to continue..."
    Read-Host
}

# Step 1: List all drives
Write-Host "Detected drives:" -ForegroundColor Green
Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object { Write-Host "$($_.Name):  $($_.Root)" }

# Step 2: Ask user to enter drive letter
$driveLetter = Read-Host "Enter the drive letter of the USB stick (e.g., E)"

# Step 3: Validate drive exists
if (-Not (Test-Path "${driveLetter}:\\")) {
    Write-Host "Drive $driveLetter not found!" -ForegroundColor Red
    Pause
    exit
}

# ✅ Problematische Zeile korrigiert:
Write-Host "You selected drive ${driveLetter}:" -ForegroundColor Cyan

# Step 4: Download Rufus if not present
$rufusPath = "$PSScriptRoot\Rufus.exe"
if (-Not (Test-Path $rufusPath)) {
    Write-Host "Rufus not found. Downloading..." -ForegroundColor Yellow
    $rufusUrl = "https://github.com/pbatard/rufus/releases/latest/download/Rufus-x64.exe"
    try {
        Invoke-WebRequest -Uri $rufusUrl -OutFile $rufusPath -ErrorAction Stop
        Write-Host "Rufus downloaded." -ForegroundColor Green
    } catch {
        Write-Host "Failed to download Rufus. Check your internet connection." -ForegroundColor Red
        Pause
        exit
    }
}

# ✅ Problematische Zeile korrigiert:
$confirm = Read-Host "The script will run Rufus to make drive ${driveLetter}: bootable. Continue? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Aborted." -ForegroundColor Red
    Pause
    exit
}

# Step 6: Start Rufus with selected drive
try {
    Start-Process $rufusPath -ArgumentList "/DEVICE=${driveLetter}" 
    Write-Host "Rufus is starting. Please confirm the rest in the program." -ForegroundColor Green
} catch {
    Write-Host "Failed to start Rufus. Check if Rufus.exe exists and try again." -ForegroundColor Red
    Pause
    exit
}
