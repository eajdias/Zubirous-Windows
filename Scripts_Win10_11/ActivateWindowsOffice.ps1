# Verificação de permissões administrativas
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
    exit
}

# Função para ativar o Windows
function ActivateWindowsOffice {
    Write-Host "Ativando o Windows ou Office..." -ForegroundColor Green
    try {
        Invoke-RestMethod -Uri https://get.activated.win | Invoke-Expression
        Write-Host "Processo de ativação concluído." -ForegroundColor Green
    } catch {
        Write-Host "Falha ao ativar o Windows: $_" -ForegroundColor Red
    }
}

ActivateWindowsOffice
