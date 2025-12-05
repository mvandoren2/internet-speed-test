$startTime = Get-Date -Format "yyyy-MM-dd_HH-mm"
$destinationStageFile = Join-Path -Path $PWD -ChildPath "speed-tests_$startTime.csv"
$destinationFile = Join-Path -Path $PWD -ChildPath "speed-tests-converted_$startTime.csv"
$exePath = Join-Path -Path $PWD -ChildPath "speedtest.exe"
$zipUrl = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"   # URL of the zip file
$zipPath = Join-Path -Path $PWD -ChildPath "ookla-speedtest-1.2.0-win64.zip"

if (-Not (Test-Path $exePath)) {
    Write-Host "File not found. Taking action..."
    
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $PWD -Force
    Remove-Item -Path $zipPath -Force

    
    # Or run any other command you want here
    # e.g., Send-MailMessage, log entry, etc.
} else {
    Write-Output "File exists. No action needed."
}



$headerOutput = & $exePath "-f" "csv" "--output-header"

$headerOutput | Out-File -FilePath $destinationStageFile -Append -Encoding utf8

for ($i = 1; $i -le 2; $i++) {

    Start-Sleep -Seconds 30

    Write-Output "Running step #$i..."

    $furtherOutput = & $exePath "-f" "csv"

    $furtherOutput | Out-File -FilePath $destinationStageFile -Append -Encoding utf8
}

$data = Import-Csv -Path $destinationStageFile

# Process each row
foreach ($row in $data) {
    # Divide download and upload by 125000
    $row.download = [math]::Round(($row.download / 125000), 2)
    $row.upload   = [math]::Round(($row.upload   / 125000), 2)
}

# Export the modified data back to CSV
$data | Export-Csv -Path $destinationFile -NoTypeInformation