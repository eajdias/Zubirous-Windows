# Função para desfragmentar discos e otimizar SSDs
function Optimize-Disks {
    $physicalDisks = Get-PhysicalDisk

    foreach ($disk in $physicalDisks) {
        $mediaType = $disk.MediaType
        $deviceId = $disk.DeviceId

        $partitions = Get-Partition | Where-Object { $_.DiskNumber -eq $deviceId }
        $driveLetters = $partitions.DriveLetter

        foreach ($letter in $driveLetters) {
            if ($mediaType -eq 'SSD') {
                Invoke-Expression "Optimize-Volume -DriveLetter $letter -ReTrim -Verbose"
                Write-Output "TRIM executado na unidade $letter."
            } elseif ($mediaType -eq 'HDD') {
                Invoke-Expression "Optimize-Volume -DriveLetter $letter -Defrag -Verbose"
                Write-Output "Desfragmentação executada na unidade $letter."
            } else {
                Write-Output "Tipo de mídia desconhecido para a unidade $letter."
            }
        }
    }
}

Optimize-Disks
