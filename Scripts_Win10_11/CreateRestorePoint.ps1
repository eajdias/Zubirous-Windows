function CreateRestorePoint {
    param (
        [string]$Description = "Ponto de Restauração Criado (Zubirous) - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    )

    # Verifica se o PowerShell está sendo executado como Administrador
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "Este script precisa ser executado como Administrador." -ForegroundColor Red
        exit
    }

    # Verifica se a Restauração do Sistema está habilitada
    Write-Host "Verificando se a Restauração do Sistema está habilitada..." -ForegroundColor Cyan
    $restoreEnabled = (Get-ComputerRestorePoint -ErrorAction SilentlyContinue).Count -ge 0
    if (-not $restoreEnabled) {
        Write-Host "Erro: A Restauração do Sistema não está habilitada neste computador." -ForegroundColor Red
        exit
    }

    try {
        Write-Host "Criando ponto de restauração: '$Description'..." -ForegroundColor Yellow

        # Cria o ponto de restauração diretamente
        Checkpoint-Computer -Description $Description -RestorePointType MODIFY_SETTINGS

        Write-Host "Ponto de restauração criado com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao criar o ponto de restauração: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Chamada de função para criar ponto de restauração
Write-Host "Iniciando criação de ponto de restauração..." -ForegroundColor Cyan
CreateRestorePoint -Description "Ponto de Restauração Zubirous"

