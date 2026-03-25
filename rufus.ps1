# ===============================
# USB Bootable Maker (Stable Version)
# ===============================

# Force TLS 1.2 (fix network issues)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Function: Pause
function Pause {
    Write-Host ""
    Write-Host "Press Enter to continue..." -ForegroundColor DarkGray
    Read-Host
}

# Step 1: List drives
Write-Host "Detected drives:" -ForegroundColor Green
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    Write-Host "$($_.Name):  $($_.Root)"
}

# Step 2: Ask for drive
$driveLetter = Read-Host "Enter the drive letter (e.g., E)"

# Step 3: Validate drive
if (-not (Test-Path "${driveLetter}:\")) {
    Write-Host "Drive ${driveLetter}: not found!" -ForegroundColor Red
    Pause
    return
}

Write-Host "You selected drive ${driveLetter}:" -ForegroundColor Cyan

# Step 4: Rufus path (TEMP instead of local folder)
$rufusPath = "$env:TEMP\Rufus.exe"

# Step 5: Download Rufus if needed
if (-not (Test-Path $rufusPath)) {
    Write-Host "Downloading Rufus..." -ForegroundColor Yellow

    $rufusUrl = "https://github.com/pbatard/rufus/releases/latest/download/Rufus-x64.exe"

    try {
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($rufusUrl, $rufusPath)
        Write-Host "Download completed." -ForegroundColor Green
    }
    catch {
        Write-Host "Download failed. Check internet connection." -ForegroundColor Red
        Pause
        return
    }
}

# Step 6: Confirmation
$confirm = Read-Host "The script will run Rufus to make drive ${driveLetter}: bootable. Continue? (y/n)"

if ($confirm -ne "y") {
    Write-Host "Aborted by user." -ForegroundColor Red
    Pause
    return
}

# Step 7: Start Rufus
try {
    Start-Process $rufusPath -ArgumentList "/DEVICE=${driveLetter}"
    Write-Host "Rufus started successfully." -ForegroundColor Green
}
catch {
    Write-Host "Failed to start Rufus." -ForegroundColor Red
    Pause
    return
}

# Step 8: End (manual close only)
Write-Host ""
Write-Host "Script finished. You can close this window manually." -ForegroundColor DarkGray
Pause
