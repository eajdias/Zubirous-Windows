# Verificação de permissões administrativas
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
    exit
}

# Função para carregar o Script de Debloat
function ChrisTitusDebloat {
    Write-Host "Iniciando script de debloat do Chris Titus..." -ForegroundColor Cyan

    # URL do script externo
    $scriptUrl = "https://christitus.com/windev"

    # Obtém o caminho do executável do PowerShell
    $powershellPath = (Get-Command powershell.exe).Source

    # Abre uma nova janela do PowerShell e executa o script
    Start-Process -FilePath $powershellPath `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"Invoke-RestMethod -Uri '$scriptUrl' | Invoke-Expression`"" `
        -Verb RunAs

    Write-Host "Uma nova janela do PowerShell foi aberta para executar o script." -ForegroundColor Green
}

# Executar a função
ChrisTitusDebloat
