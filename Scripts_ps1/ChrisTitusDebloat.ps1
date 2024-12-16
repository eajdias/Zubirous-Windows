# Verificação de permissões administrativas
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
    exit
}

# Função para otimizar o Windows
function ChrisTitusDebloat {
    Write-Host "Carregando Script de Debloat..." -ForegroundColor Green

    # Obtém o caminho do executável do PowerShell
    $powershellPath = (Get-Command powershell.exe).Source

    # Inicia uma nova janela do PowerShell para executar o comando
    Start-Process -FilePath $powershellPath -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "Invoke-RestMethod -Uri https://christitus.com/windev | Invoke-Expression"' -Verb RunAs
}

ChrisTitusDebloat
