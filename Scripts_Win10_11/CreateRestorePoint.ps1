function CreateRestorePoint {
    param (
        [string]$Description = "Ponto de Restauração Criado (Zubirous) - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    )

    # Verifica se o PowerShell está sendo executado como Administrador
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Output "Este script precisa ser executado como Administrador."
        return
    }

    try {
        Write-Output "Criando ponto de restauração: '$Description'..."

        # Cria o ponto de restauração diretamente
        Checkpoint-Computer -Description $Description -RestorePointType MODIFY_SETTINGS

        Write-Output "Ponto de restauração criado com sucesso."
    } catch {
        Write-Output "Erro ao criar o ponto de restauração: $($_.Exception.Message)"
    }
}

# Exemplo de uso
CreateRestorePoint -Description "Ponto de Restauração Zubirous"
