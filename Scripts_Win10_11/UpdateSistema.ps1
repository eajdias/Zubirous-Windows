# Função para executar comandos com descrição e tratamento de erros
function Invoke-CommandCustom {
    param (
        [string]$Command,
        [string]$Description
    )
    try {
        Write-Host "Executando: $Description..." -ForegroundColor Cyan
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c $Command" -NoNewWindow -Wait
        Write-Host "Concluído: $Description" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao executar: $Description. Detalhes: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Função para verificar permissões administrativas
function Test-AdminPrivileges {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
        exit
    }
}

# Função para instalar atualizações do Windows Update
function Update-General {
    Test-AdminPrivileges

    # Verificar e instalar o módulo PSWindowsUpdate se necessário
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "Instalando o módulo PSWindowsUpdate..." -ForegroundColor Yellow
        try {
            Install-Module -Name PSWindowsUpdate -Force -ErrorAction Stop
            Import-Module -Name PSWindowsUpdate
        } catch {
            Write-Host "Erro ao instalar o módulo PSWindowsUpdate: $($_.Exception.Message)" -ForegroundColor Red
            return
        }
    } else {
        Import-Module -Name PSWindowsUpdate
        Write-Host "Módulo PSWindowsUpdate já está instalado." -ForegroundColor Green
    }

    # Obter atualizações disponíveis
    Write-Host "Buscando atualizações disponíveis..." -ForegroundColor Cyan
    try {
        $updates = Get-WindowsUpdate -ErrorAction Stop
    } catch {
        Write-Host "Erro ao buscar atualizações: $($_.Exception.Message)" -ForegroundColor Red
        return
    }

    if (-not $updates) {
        Write-Host "Não há atualizações disponíveis. O sistema já está atualizado." -ForegroundColor Green
        return
    }

    # Confirmar instalação das atualizações
    Write-Host "Foram encontradas $($updates.Count) atualizações." -ForegroundColor Yellow
    $confirmation = Read-Host "Deseja instalá-las? (S/N)"
    if ($confirmation -ne 'S') {
        Write-Host "Instalação de atualizações cancelada." -ForegroundColor Red
        return
    }

    # Instalar atualizações
    Write-Host "Instalando atualizações..." -ForegroundColor Cyan
    try {
        Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose -ErrorAction Stop
        Write-Host "Todas as atualizações foram instaladas com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao instalar atualizações: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Função para atualizar pacotes do sistema
function Update-SystemPackages {
    Test-AdminPrivileges

    # Verificar se o Chocolatey está disponível
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Invoke-CommandCustom -Command "choco upgrade all -y" -Description "Atualizar todos os pacotes instalados com Chocolatey"
    } else {
        Write-Host "Chocolatey não está instalado ou não foi encontrado." -ForegroundColor Yellow
    }

    # Verificar se o Winget está disponível
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Invoke-CommandCustom -Command "winget upgrade --all --accept-package-agreements --accept-source-agreements --disable-interactivity" -Description "Atualizar todos os pacotes instalados com Winget"
    } else {
        Write-Host "Winget não está instalado ou não foi encontrado." -ForegroundColor Yellow
    }
}

# Atualizações no geral do sistema
Write-Host "==== Iniciando Atualizações do Sistema ====" -ForegroundColor Magenta
Update-General
Update-SystemPackages
