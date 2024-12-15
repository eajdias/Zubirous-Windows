# Configuração do Caminho do Backup
$DefaultBackupPath = "C:\BackupDrivers"

# Função: Criar Backup dos Drivers
function Backup-Drivers {
    param (
        [string]$BackupPath = $DefaultBackupPath
    )
    try {
        Write-Host "Verificando pasta de destino para backup..." -ForegroundColor Yellow
        if (!(Test-Path -Path $BackupPath)) {
            New-Item -ItemType Directory -Path $BackupPath | Out-Null
            Write-Host "Pasta de backup criada em: $BackupPath" -ForegroundColor Green
        }
        Write-Host "Iniciando backup dos drivers..." -ForegroundColor Yellow
        dism /online /export-driver /destination:$BackupPath
        Write-Host "Backup concluído com sucesso! Drivers salvos em: $BackupPath" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao fazer backup dos drivers: $_" -ForegroundColor Red
    }
}

# Função: Restaurar Drivers
function Restore-Drivers {
    param (
        [string]$BackupPath = $DefaultBackupPath
    )
    try {
        Write-Host "Verificando pasta de backup..." -ForegroundColor Yellow
        if (!(Test-Path -Path $BackupPath)) {
            Write-Host "Erro: A pasta de backup não foi encontrada em: $BackupPath" -ForegroundColor Red
            return
        }
        Write-Host "Iniciando restauração dos drivers..." -ForegroundColor Yellow
        pnputil /add-driver "$BackupPath\*.inf" /sub
        Write-Host "Drivers restaurados com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao restaurar os drivers: $_" -ForegroundColor Red
    }
}

Backup-Drivers
Restore-Drivers
