# Função para desfragmentar discos e otimizar SSDs
function Optimize-Disks {
    try {
        # Verificar se o comando Get-PhysicalDisk está disponível
        if (-not (Get-Command Get-PhysicalDisk -ErrorAction SilentlyContinue)) {
            Write-Host "O comando 'Get-PhysicalDisk' não é suportado neste sistema." -ForegroundColor Red
            return
        }

        $physicalDisks = Get-PhysicalDisk
        if (-not $physicalDisks) {
            Write-Host "Nenhum disco físico encontrado." -ForegroundColor Yellow
            return
        }

        foreach ($disk in $physicalDisks) {
            $mediaType = $disk.MediaType
            $deviceId = $disk.DeviceId

            # Obter partições associadas ao disco
            $partitions = Get-Partition | Where-Object { $_.DiskNumber -eq $deviceId -and $_.DriveLetter }
            $driveLetters = $partitions.DriveLetter

            if (-not $driveLetters) {
                Write-Host "O disco $deviceId não possui partições atribuídas. Ignorando..." -ForegroundColor Yellow
                continue
            }

            foreach ($letter in $driveLetters) {
                try {
                    # Verifica o suporte ao comando Optimize-Volume
                    if (-not (Get-Command Optimize-Volume -ErrorAction SilentlyContinue)) {
                        Write-Host "O comando 'Optimize-Volume' não é suportado neste sistema. Ignorando..." -ForegroundColor Red
                        return
                    }

                    Write-Host "Otimizando a unidade $letter..." -ForegroundColor Cyan
                    if ($mediaType -eq 'SSD') {
                        # Executa TRIM para SSDs
                        Optimize-Volume -DriveLetter $letter -ReTrim 
                        Write-Host "TRIM executado com sucesso na unidade $letter." -ForegroundColor Green
                    } elseif ($mediaType -eq 'HDD') {
                        # Desfragmenta apenas arquivos em HDDs, sem consolidar o espaço livre
                        Optimize-Volume -DriveLetter $letter -DefragOnly
                        Write-Host "Desfragmentação (sem consolidação) executada com sucesso na unidade $letter." -ForegroundColor Green
                    } else {
                        Write-Host "Tipo de mídia desconhecido para a unidade $letter. Ignorando..." -ForegroundColor Yellow
                    }
                } catch {
                    Write-Host "Erro ao otimizar a unidade ${letter}: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }
    } catch {
        Write-Host "Erro ao obter discos físicos: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Chamar a função para otimizar os discos
Write-Host "==== Iniciando a otimização dos discos ====" -ForegroundColor Magenta
Optimize-Disks
