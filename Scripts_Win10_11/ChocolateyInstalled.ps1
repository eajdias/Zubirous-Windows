# Função para definir a política de execução temporária
function Set-ExecutionPolicyTemporary {
    param (
        [string]$Policy = "Bypass"
    )
    Set-ExecutionPolicy -ExecutionPolicy $Policy -Scope Process -Force
    Write-Output "Política de execução ajustada para: $Policy"
}

# Função para instalar o Chocolatey de forma segura
function Install-Chocolatey {
    # Verifica se o Chocolatey já está instalado
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Output "Chocolatey já está instalado."
        return
    }

    try {
        Write-Output "Iniciando instalação do Chocolatey..."

        # Define um caminho temporário para o script de instalação
        $tempScript = "$env:TEMP\choco-install.ps1"

        # Baixa o script de instalação usando Invoke-WebRequest
        Invoke-WebRequest -Uri "https://community.chocolatey.org/install.ps1" -OutFile $tempScript

        # Executa o script baixado em um processo separado
        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $tempScript" -Wait

        # Verifica se a instalação foi concluída com sucesso
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Output "Chocolatey instalado com sucesso."
        } else {
            Write-Output "Falha na instalação do Chocolatey."
        }

    } catch {
        Write-Output "Erro ao instalar o Chocolatey: $($_.Exception.Message)"
    }
}

# Configurar a política de execução para ter certeza
Set-ExecutionPolicyTemporary -Policy "Bypass"

# Verifica e instala o Chocolatey se não estiver instalado
Install-Chocolatey
