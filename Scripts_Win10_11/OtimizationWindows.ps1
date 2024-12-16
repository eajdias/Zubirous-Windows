# Função para executar comandos com descrição e tratamento de erros
function Invoke-CommandCustom {
    param (
        [string]$Command,
        [string]$Description
    )
    try {
        Write-Host "Executando: $Description..." -ForegroundColor Cyan
        Invoke-Expression $Command
        Write-Host "Concluído: $Description" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao executar: $Description. Detalhes: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Tarefas de otimização do Sistema
function PerformSystemOptimizations {
    Write-Host "`nIniciando otimizações do sistema..." -ForegroundColor Magenta

    # Executar comandos PowerShell diretamente
    Invoke-CommandCustom -Command "Add-MpPreference -ExclusionPath 'G:\'" -Description "Adicionar exceção no antivírus para 'G:\'"
    Invoke-CommandCustom -Command "Get-MpPreference | Select-Object -ExpandProperty ExclusionPath" -Description "Verificar exceções do antivírus"
    Invoke-CommandCustom -Command "ipconfig /flushdns" -Description "Limpeza do cache DNS"
    Invoke-CommandCustom -Command "Set-Service -Name 'WSearch' -StartupType Disabled" -Description "Desativar o serviço de busca do Windows"
    Invoke-CommandCustom -Command "cleanmgr /sagerun:1" -Description "Limpeza de disco"
    Invoke-CommandCustom -Command "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v MenuShowDelay /t REG_DWORD /d 0 /f" -Description "Acelerar o menu Iniciar"
    Invoke-CommandCustom -Command "powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61" -Description "Adicionar plano de energia Desempenho Máximo"
    Invoke-CommandCustom -Command "powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61" -Description "Ativar plano de energia Desempenho Máximo"
    Invoke-CommandCustom -Command "powercfg /h on" -Description "Habilitar a inicialização rápida"
    Invoke-CommandCustom -Command "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' /v EnableTransparency /t REG_DWORD /d 0 /f" -Description "Desativar efeitos de transparência"
    Invoke-CommandCustom -Command "bcdedit /timeout 0" -Description "Desativar o tempo limite do menu de inicialização"
    Invoke-CommandCustom -Command "Remove-Item -Path $env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db -Force" -Description "Limpar arquivos de cache de miniaturas"

    Write-Host "Otimizações do sistema concluídas." -ForegroundColor Green
}

# Função para otimizar assemblies - bibliotecas do .NET
function Optimize-DotNetAssemblies {
    Write-Host "`nIniciando otimização dos assemblies do .NET..." -ForegroundColor Magenta

    try {
        $ngenPaths = @(
            "$env:windir\Microsoft.NET\Framework\v4.0.30319\ngen.exe",
            "$env:windir\Microsoft.NET\Framework64\v4.0.30319\ngen.exe"
        )

        foreach ($ngen in $ngenPaths) {
            if (Test-Path $ngen) {
                Write-Host "Atualizando assemblies usando: $ngen" -ForegroundColor Cyan
                & $ngen update
                Write-Host "Otimização concluída para: $ngen" -ForegroundColor Green
            } else {
                Write-Host "Caminho não encontrado: $ngen" -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "Erro durante a otimização dos assemblies do .NET: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Executar as otimizações
PerformSystemOptimizations
Optimize-DotNetAssemblies
