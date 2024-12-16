# Verificar permissões administrativas
function Test-AdminPrivileges {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
        exit
    }
}

# Função para verificar se o Winget está instalado
function WingetInstalled {
    try {
        $wingetVersion = winget --version
        if ($wingetVersion) {
            Write-Host "Winget já está instalado. Versão: $wingetVersion" -ForegroundColor Green
            return $true
        }
    } catch {
        Write-Host "Winget não encontrado no sistema." -ForegroundColor Yellow
        return $false
    }
}

# Função para instalar o Winget
function Install-Winget {
    if (-not (WingetInstalled)) {
        try {
            Write-Host "Baixando e instalando o Winget..." -ForegroundColor Cyan
            $WingetInstaller = "$env:TEMP\winget.appxbundle"
            Invoke-WebRequest -Uri "https://aka.ms/get-winget" -OutFile $WingetInstaller -UseBasicParsing
            Add-AppxPackage -Path $WingetInstaller
            Write-Host "Winget instalado com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "Erro ao instalar o Winget: $($_.Exception.Message)" -ForegroundColor Red
            exit
        }
    }
}

# Função para verificar e instalar programas via Winget
function Install-WingetPrograms {
    param (
        [array]$Programs
    )
    foreach ($program in $Programs) {
        try {
            # Verifica se o programa já está instalado
            $isInstalled = winget list | Select-String -Pattern $program
            if (-not $isInstalled) {
                Write-Host "Instalando: ${program}..." -ForegroundColor Cyan
                winget install --id ${program} --accept-package-agreements --accept-source-agreements --silent
                Write-Host "Programa instalado: ${program}" -ForegroundColor Green
            } else {
                Write-Host "Programa já instalado: ${program}" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Erro ao instalar o programa ${program}: $($_.Exception.Message)" -ForegroundColor Red
        }
    }    
}

# Função para definir o Terminal e PowerShell como padrão
function Set-TerminalAsDefault {
    Write-Host "Definindo Windows Terminal e PowerShell Preview como padrões..." -ForegroundColor Cyan
    try {
        # Comando para definir Windows Terminal como padrão
        $terminalJson = "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
        if (Test-Path $terminalJson) {
            Write-Host "Windows Terminal já está configurado como padrão." -ForegroundColor Yellow
        } else {
            # Define Windows Terminal como padrão via registro
            New-ItemProperty -Path "HKCU:\Console" -Name "WindowsTerminal" -Value "true" -PropertyType String -Force | Out-Null
            Write-Host "Windows Terminal definido como padrão." -ForegroundColor Green
        }
    } catch {
        Write-Host "Erro ao definir o Terminal como padrão: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Lista de programas para instalação via Winget
$WingetPrograms = @(
    "OBSProject.OBSStudio",
    "Microsoft.WindowsTerminal",
    "Microsoft.PowerShell.Preview"
)

# Execução das funções
Test-AdminPrivileges
Install-Winget
Write-Host "`n==== Iniciando Instalação de Programas ====" -ForegroundColor Magenta
Install-WingetPrograms -Programs $WingetPrograms
Set-TerminalAsDefault
