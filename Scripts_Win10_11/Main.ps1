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
            Update-General
        }
        7 { 
            Write-Output "Instalando pacotes do sistema via Chocolatey..."
            Install-ChocoPackages -Packages $ChocoPackages
        }
        8 { 
            Write-Output "Instalando Winget..."
            Install-Winget
        }
        9 { 
            Write-Output "Atualizando pacotes do sistema..."
            Update-SystemPackages
        }
        10 { 
            Write-Output "Otimizando assemblies do .NET..."
            Optimize-DotNetAssemblies
        }
        11 { 
            Write-Output "Otimizando conexação de internet e DNS..."
            Optimize-NetworkSettings
        }
        12 { 
            Write-Output "Realizando Backup de Drivers instalados..."
            Backup-Drivers
        }
        13 { 
            Write-Output "Compactar Sistema Operacional (Windows)..."
            CompactWindows
        }
        14 { 
            Write-Output "Criar usuario WinAdmin no Windows..."
            CreateAdminUser
        }
        15 { 
            Write-Output "Detectando e atualizando GPUs ..."
            Update-GPUDrivers
        }
        16 { 
            Write-Output "Ativar o Windows ou Office..."
            ActivateWindowsOffice
        }
        17 { 
            Write-Output "Restaurando Drivers apartir de Backup..."
            Restore-Drivers
        }
        18 { 
            Write-Output "Ferramenta - ChrisTitus Debloat..."
            ChrisTitusDebloat
        }
        19 {
            CreateRestorePoint -Description "Ponto de Restauração - Pos-Formatação (Zubirous)"
            Write-Output "Executando todas as tarefas (1 - 16)..."
            foreach ($service in $servicesToConfigure.GetEnumerator()) {
                Set-ServiceState -ServiceNamePattern $service.Key -StartupType $service.Value
            }
            Clear-TemporaryFiles
            Remove-AppxPackages -Packages $packagesToRemove
            Optimize-Disks
            CheckAndRepairWindows
            PerformSystemOptimizations
            Update-General
            Install-ChocoPackages -Packages $ChocoPackages
            Install-Winget
            Update-SystemPackages
            Optimize-DotNetAssemblies
            Optimize-NetworkSettings
            Backup-Drivers
            CompactWindows
            CreateAdminUser
            Update-GPUDrivers
            ActivateWindowsOffice
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
    Write-Host "1. Configuração Geral dos serviços do Windows" -ForegroundColor Green
    Write-Host "2. Limpar arquivos temporários do Sistema" -ForegroundColor Green
    Write-Host "3. Remover Bloatware (Programas inuteis do Windows)" -ForegroundColor Green
    Write-Host "4. Otimizar discos (HD, SSD, NVme2)" -ForegroundColor Green
    Write-Host "5. Verificar e reparar erros do Windows" -ForegroundColor Green
    Write-Host "6. Executar otimizações do sistema" -ForegroundColor Green
    Write-Host "7. Instalar pacotes e programas essenciais do Sistema" -ForegroundColor Green
    Write-Host "8. Instalar Winget (se necessário)" -ForegroundColor Green
    Write-Host "9. Atualizar pacotes e programas do sistema" -ForegroundColor Green
    Write-Host "10. Otimizar assemblies do .NET" -ForegroundColor Green
    Write-Host "11. Otimizar conexão de Internet e DNS" -ForegroundColor Green
    Write-Host "12. Realizar Backup de todos Drivers" -ForegroundColor Green
    Write-Host "13. Compactar o Sistema Operacional " -ForegroundColor Green
    Write-Host "14. Criar usuario WinAdmin (senha 123) " -ForegroundColor Green
    Write-Host "15. Detectar e atualizar GPUs" -ForegroundColor Green
    Write-Host "16. Ativar o Windows ou Office" -ForegroundColor Green
    Write-Host "17. Restaurar Drivers apartir de Backup" -ForegroundColor Green
    Write-Host "18. Ferramenta - ChrisTitus Windows Debloat " -ForegroundColor Green
    Write-Host "19. Pós-Formatação (Executar todas tarefas 1 - 16)" -ForegroundColor Magenta
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

