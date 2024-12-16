# Caminho Padrão para Backup dos Drivers
$DefaultBackupPath = "C:\BackupDrivers"

# Verificação de permissões administrativas
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
    exit
}

# Função: Restaurar Drivers
function Restore-Drivers {
    param (
        [string]$BackupPath = $DefaultBackupPath
    )
    try {
        Write-Host "`n==== Verificação do Caminho de Backup ====" -ForegroundColor Cyan

        # Verifica se o caminho do backup existe
        if (!(Test-Path -Path $BackupPath)) {
            Write-Host "Erro: A pasta de backup não foi encontrada em: $BackupPath" -ForegroundColor Red
            return
        }

        # Verifica se o pnputil está disponível
        if (-not (Get-Command pnputil -ErrorAction SilentlyContinue)) {
            Write-Host "Erro: O comando 'pnputil' não está disponível neste sistema." -ForegroundColor Red
            return
        }

        Write-Host "Caminho de backup verificado: $BackupPath" -ForegroundColor Green

        # Iniciar a restauração
        Write-Host "`n==== Iniciando Restauração dos Drivers ====" -ForegroundColor Cyan
        pnputil /add-driver "$BackupPath\*.inf" /subdirs /install

        # Validar o resultado
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Drivers restaurados com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "Falha ao restaurar os drivers. Código de erro: $LASTEXITCODE" -ForegroundColor Red
        }
    } catch {
        Write-Host "Erro ao restaurar os drivers: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Chamar a função de restaurar
Write-Host "`n==== Iniciando Script de Restauração de Drivers ====" -ForegroundColor Magenta
Restore-Drivers
