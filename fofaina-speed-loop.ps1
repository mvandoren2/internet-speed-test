$startTime = Get-Date -Format "yyyy-MM-dd_HH-mm"
$destinationStageFile = Join-Path -Path $PWD -ChildPath "speed-tests_$startTime.csv"
$destinationFile = Join-Path -Path $PWD -ChildPath "speed-tests-converted_$startTime.csv"
$exePath = Join-Path -Path $PWD -ChildPath "speedtest.exe"

$headerOutput = & $exePath "-f" "csv" "--output-header"

$headerOutput | Out-File -FilePath $destinationStageFile -Append -Encoding utf8

for ($i = 1; $i -le 5; $i++) {

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