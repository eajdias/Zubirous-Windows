# Função para executar comandos com descrição e tratamento de erros
function Invoke-CommandCustom {
    param (
        [string]$Command,
        [string]$Description
    )
    try {
        Write-Output "Executando: $Description..."
        Invoke-Expression $Command
        Write-Output "Concluído: $Description"
    } catch {
        Write-Output "Erro ao executar: $Description. Detalhes: $_"
    }
}

# Função para atualizar pacotes do sistema
function Update-SystemPackages {
    # Verificar se o Chocolatey está disponível
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Invoke-CommandCustom -Command "choco upgrade all -y" -Description "Atualizar todos os pacotes instalados com Chocolatey"
    } else {
        Write-Output "Chocolatey não está instalado ou não foi encontrado."
    }

    # Verificar se o Winget está disponível
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Invoke-CommandCustom -Command "winget upgrade --all -u --disable-interactivity --ignore-security-hash --accept-package-agreements --accept-source-agreements -h" -Description "Atualizar todos os pacotes instalados com Winget"
    } else {
        Write-Output "Winget não está instalado ou não foi encontrado."
    }
}


# Tarefas de otimização do Sistema
function PerformSystemOptimizations {
    Invoke-CommandCustom -Command "Add-MpPreference -ExclusionPath 'G:\'" -Description "Adicionar exceção no antivírus para 'G:\'"
    Invoke-CommandCustom -Command "Get-MpPreference | Select-Object -ExpandProperty ExclusionPath" -Description "Verificar exceções do antivírus"
    Invoke-CommandCustom -Command "ipconfig /flushdns" -Description "Limpeza do cache DNS"
    Invoke-CommandCustom -Command "Set-Service -Name 'WSearch' -StartupType Disabled" -Description "Desativar o serviço de busca do Windows"
    Invoke-CommandCustom -Command "cleanmgr /sagerun:1" -Description "Limpeza de disco"
    Invoke-CommandCustom -Command "reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v MenuShowDelay /t REG_DWORD /d 0 /f" -Description "Acelerar o menu Iniciar"
    Invoke-CommandCustom -Command "powercfg /setactive ba0f3a46-aed8-4278-a7fc-eaff6ede6d8f" -Description "Ativar plano de energia Desempenho Máximo"
    Invoke-CommandCustom -Command "powercfg /h on" -Description "Habilitar a inicialização rápida"
    Invoke-CommandCustom -Command "reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' /v EnableTransparency /t REG_DWORD /d 0 /f" -Description "Desativar efeitos de transparência"
    Invoke-CommandCustom -Command "bcdedit /timeout 0" -Description "Desativar o tempo limite do menu de inicialização"
    Invoke-CommandCustom -Command "Remove-Item -Path $env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db -Force" -Description "Limpar arquivos de cache de miniaturas"
}

# Função para otimizar assemblies - bibliotecas do .NET
function Optimize-DotNetAssemblies {
    try {
        Write-Output "Iniciando otimização dos assemblies do .NET..."
        
        # Executar itens em fila para todos os ngen_exe encontrados
        Get-ChildItem -Directory -Path "C:\Windows\winsxs" -Filter "*ngen_exe*" | ForEach-Object {
            & "$($_.FullName)\ngen.exe" executeQueuedItems
        }

        # Atualizar os assemblies do .NET
        & "$env:windir\Microsoft.NET\Framework64\v4.0.30319\ngen.exe" update

        Write-Output "Otimização dos assemblies do .NET concluída com sucesso."
    } catch {
        Write-Output "Erro durante a otimização dos assemblies do .NET: $_"
    }
}

# Função para instalar atualizações do Windows Update
function Update-General {
    # Verificar se o script está sendo executado como administrador
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "Este script deve ser executado com permissões administrativas."
        return
    }

    # Verificar e instalar o módulo PSWindowsUpdate se necessário
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "Instalando o módulo PSWindowsUpdate..."
        Install-Module PSWindowsUpdate -Force -ErrorAction Stop
    } else {
        Write-Host "Módulo PSWindowsUpdate já está instalado."
    }

    # Obter atualizações disponíveis
    Write-Host "Buscando atualizações disponíveis..."
    $updates = Get-WindowsUpdate -ErrorAction Stop

    # Verificar se há atualizações disponíveis
    if ($updates.Count -eq 0) {
        Write-Host "Não há atualizações disponíveis. O sistema já está atualizado."
        return
    }

    # Confirmar instalação das atualizações
    $confirmation = Read-Host "Foram encontradas $($updates.Count) atualizações. Deseja instalá-las? (S/N)"
    if ($confirmation -ne 'S') {
        Write-Host "Instalação de atualizações cancelada."
        return
    }

    # Instalar atualizações
    Write-Host "Instalando atualizações..."
    Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose -ErrorAction Stop

    # Mensagem final
    Write-Host "Todas as atualizações foram instaladas com sucesso!"
}


Update-SystemPackages
PerformSystemOptimizations
Optimize-DotNetAssemblies
Update-General
