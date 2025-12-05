param(
    [Alias("i","interval")]
    [int]$intervalMinutes = 15,

    [Alias("h","hrs")]
    [double]$hours = 2,

    [Alias("f","file")]
    [string]$zipUrl = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"


)

$startTime = Get-Date -Format "yyyy-MM-dd_HH-mm"
$destinationStageFile = Join-Path -Path $PWD -ChildPath "speed-tests_$startTime.csv"
$destinationFile = Join-Path -Path $PWD -ChildPath "speed-tests-converted_$startTime.csv"
$exePath = Join-Path -Path $PWD -ChildPath "speedtest.exe"

$zipPath = Join-Path -Path $PWD -ChildPath "speed-test.zip"
$endTime = (Get-Date).AddHours($hours)

if (-Not (Test-Path $exePath)) {
    Write-Host "Speedtest.exe not found. Downloading and extracting..."
    
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $PWD -Force
    Remove-Item -Path $zipPath -Force
    Write-Host "Download and extraction complete."

    
    # Or run any other command you want here
    # e.g., Send-MailMessage, log entry, etc.
} else {
    Write-Output "Speedtest.exe found. Proceeding with tests..."
}



$headerOutput = "`"server name`",`"server id`",`"idle latency`",`"idle jitter`",`"packet loss`",`"download`",`"upload`",`"download bytes`",`"upload bytes`",`"share url`",`"download server count`",`"download latency`",`"download latency jitter`",`"download latency low`",`"download latency high`",`"upload latency`",`"upload latency jitter`",`"upload latency low`",`"upload latency high`",`"idle latency low`",`"idle latency high`",`"timestamp`""

Write-Output "Starting internet speed tests every $intervalMinutes minutes for $hours hours..."

$headerOutput | Out-File -FilePath $destinationStageFile -Append -Encoding utf8

while ((Get-Date) -lt $endTime) {

    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Write-Output "Testing Speed at $timestamp"

    $furtherOutput = & $exePath "-f" "csv"
    $furtherOutput += ",`"$timestamp`""


    $furtherOutput | Out-File -FilePath $destinationStageFile -Append -Encoding utf8


    Start-Sleep -Seconds ($intervalMinutes * 60)
}

Write-Output "Speed tests completed. Processing data for speeds to be readable in MB/s..."

$data = Import-Csv -Path $destinationStageFile

# Process each row
foreach ($row in $data) {
    # Divide download and upload by 125000
    $row.download = [math]::Round(($row.download / 125000), 2)
    $row.upload   = [math]::Round(($row.upload   / 125000), 2)
}

Write-Output "Data processing complete."

# Export the modified data back to CSV
$data | Export-Csv -Path $destinationFile -NoTypeInformation
Remove-Item -Path $destinationStageFile -Force

Write-Output "All done! Results saved in $destinationFile"