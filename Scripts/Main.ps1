# Função para executar uma tarefa
function RunTask {
    param (
        [int]$TaskNumber
    )

    switch ($TaskNumber) {
        1 { 
            Write-Output "Configurando serviços do Windows..."
            foreach ($service in $servicesToConfigure.GetEnumerator()) {
                Set-ServiceState -ServiceNamePattern $service.Key -StartupType $service.Value
            }
        }
        2 { 
            Write-Output "Limpando arquivos temporários..."
            Clear-TemporaryFiles
        }
        3 { 
            Write-Output "Removendo bloatware..."
            Remove-AppxPackages -Packages $packagesToRemove
        }
        4 { 
            Write-Output "Otimizando discos..."
            Optimize-Disks
        }
        5 { 
            Write-Output "Verificando e reparando erros do Windows..."
            CheckAndRepairWindows
        }
        6 { 
            Write-Output "Executando otimizações do sistema..."
            PerformSystemOptimizations
        }
        7 { 
            Write-Output "Instalando ferramentas de desenvolvimento..."
            Install-DevTools
        }
        8 { 
            Write-Output "Instalando pacotes do sistema via Chocolatey..."
            Install-ChocoPackages -Packages $ChocoPackages
        }
        9 { 
            Write-Output "Instalando Winget..."
            Install-Winget
        }
        10 { 
            Write-Output "Atualizando pacotes do sistema..."
            Update-SystemPackages
        }
        11 { 
            Write-Output "Otimizando assemblies do .NET..."
            Optimize-DotNetAssemblies
        }
        12 {
            Write-Output "Executando todas as tarefas..."
            foreach ($service in $servicesToConfigure.GetEnumerator()) {
                Set-ServiceState -ServiceNamePattern $service.Key -StartupType $service.Value
            }
            Clear-TemporaryFiles
            Remove-AppxPackages -Packages $packagesToRemove
            Optimize-Disks
            CheckAndRepairWindows
            PerformSystemOptimizations
            Install-DevTools
            Install-ChocoPackages -Packages $ChocoPackages
            Install-Winget
            Update-SystemPackages
            Optimize-DotNetAssemblies
        }
        default { Write-Output "Opção inválida. Tente novamente." }
    }
}

# Função para exibir o menu
function Show-Menu {
    Clear-Host
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host "       MENU DE MANUTENÇÃO          " -ForegroundColor Yellow
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Configurar serviços do Windows" -ForegroundColor Green
    Write-Host "2. Limpar arquivos temporários" -ForegroundColor Green
    Write-Host "3. Remover bloatware" -ForegroundColor Green
    Write-Host "4. Otimizar discos" -ForegroundColor Green
    Write-Host "5. Verificar e reparar erros do Windows" -ForegroundColor Green
    Write-Host "6. Executar otimizações do sistema" -ForegroundColor Green
    Write-Host "7. Instalar ferramentas de desenvolvimento (Chocolatey)" -ForegroundColor Green
    Write-Host "8. Instalar pacotes do sistema (Chocolatey)" -ForegroundColor Green
    Write-Host "9. Instalar Winget" -ForegroundColor Green
    Write-Host "10. Atualizar pacotes e programas do sistema" -ForegroundColor Green
    Write-Host "11. Otimizar assemblies do .NET" -ForegroundColor Green
    Write-Host "12. Executar todas as tarefas" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "0. Sair" -ForegroundColor Red
    Write-Host "====================================" -ForegroundColor Cyan
}

# Loop do menu
do {
    Show-Menu
    $choice = Read-Host "Digite o número da opção desejada (ou '0' para sair)"
    
    # Validar entrada e executar a tarefa
    if ($choice -match '^\d+$') {
        $choice = [int]$choice
        if ($choice -eq 0) {
            Write-Host "Saindo do menu... Até logo!" -ForegroundColor Cyan
            break
        } elseif ($choice -ge 1 -and $choice -le 12) {
            RunTask -TaskNumber $choice
        } else {
            Write-Host "Opção fora do intervalo válido. Tente novamente." -ForegroundColor Red
        }
    } else {
        Write-Host "Entrada inválida. Por favor, insira um número." -ForegroundColor Red
    }
    Pause
} while ($true)
