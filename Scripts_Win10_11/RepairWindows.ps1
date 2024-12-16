# Função para verificar e reparar erros no Windows
function CheckAndRepairWindows {
    Write-Output "Iniciando verificação de integridade do sistema."
    Invoke-Expression "DISM /Online /Cleanup-Image /ScanHealth"
    Invoke-Expression "DISM /Online /Cleanup-Image /RestoreHealth"
    Invoke-Expression "sfc /scannow"
    Write-Output "Verificação e reparo concluídos."
}

CheckAndRepairWindows
