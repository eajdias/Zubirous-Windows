# Configuração do Caminho do Backup
$DefaultBackupPath = "C:\BackupDrivers"

# Verificação de permissões administrativas
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
    exit
}

# Função: Criar Backup dos Drivers
function Backup-Drivers {
    param (
        [string]$BackupPath = $DefaultBackupPath
    )

    try {
        Write-Host "Verificando pasta de destino para backup..." -ForegroundColor Cyan

        # Criação do diretório se não existir
        if (-not (Test-Path -Path $BackupPath)) {
            New-Item -ItemType Directory -Path $BackupPath | Out-Null
            Write-Host "Pasta de backup criada em: $BackupPath" -ForegroundColor Green
        } else {
            Write-Host "Pasta de destino já existe: $BackupPath" -ForegroundColor Yellow
        }

        # Execução do backup dos drivers com DISM
        Write-Host "Iniciando backup dos drivers. Aguarde..." -ForegroundColor Cyan
        dism /online /export-driver /destination:$BackupPath

        # Validação do resultado
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Backup concluído com sucesso! Drivers salvos em: $BackupPath" -ForegroundColor Green
        } else {
            Write-Host "Falha ao realizar o backup. Código de saída: $LASTEXITCODE" -ForegroundColor Red
        }
    } catch {
        Write-Host "Erro ao fazer backup dos drivers: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Chamada de função para Criar o Backup de Drivers
Write-Host "==== Iniciando Backup de Drivers ====" -ForegroundColor Cyan
Backup-Drivers
