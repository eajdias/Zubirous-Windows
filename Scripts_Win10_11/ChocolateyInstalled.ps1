# Função para definir a política de execução temporária
function Set-ExecutionPolicyTemporary {
    param (
        [string]$Policy = "Bypass"
    )
    Set-ExecutionPolicy -ExecutionPolicy $Policy -Scope Process -Force
    Write-Output "Política de execução ajustada para: $Policy"
}

# Instalação do Chocolatey
function Install-Chocolatey {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Output "Chocolatey já está instalado."
        return
    }
    try {
        Write-Output "Iniciando instalação do Chocolatey..."
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Output "Chocolatey instalado com sucesso."
    } catch {
        Write-Output "Erro ao instalar o Chocolatey: $_"
    }
}

# Configurar a política de execução
Set-ExecutionPolicyTemporary -Policy "Bypass"

# Instalar o Chocolatey
Install-Chocolatey
