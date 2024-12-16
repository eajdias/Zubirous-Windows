# Função para verificar e reparar erros no Windows
function CheckAndRepairWindows {
    Write-Host "Iniciando verificação de integridade do sistema..." -ForegroundColor Cyan

    try {
        # Verificação rápida da imagem do sistema com DISM
        Write-Host "Verificando a integridade da imagem do sistema com DISM..." -ForegroundColor Yellow
        DISM /Online /Cleanup-Image /ScanHealth
        Write-Host "Verificação concluída com sucesso." -ForegroundColor Green

        # Reparação da imagem do sistema com DISM
        Write-Host "Reparando a imagem do sistema com DISM..." -ForegroundColor Yellow
        DISM /Online /Cleanup-Image /RestoreHealth
        Write-Host "Reparação concluída com sucesso." -ForegroundColor Green

        # Verificação e reparo dos arquivos do sistema com SFC
        Write-Host "Verificando e reparando arquivos do sistema com SFC..." -ForegroundColor Yellow
        sfc /scannow
        Write-Host "Verificação e reparo concluídos com sucesso." -ForegroundColor Green

    } catch {
        Write-Host "Ocorreu um erro durante a verificação ou reparo do sistema. Detalhes: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Chamar a função para verificar e reparar o sistema
CheckAndRepairWindows
