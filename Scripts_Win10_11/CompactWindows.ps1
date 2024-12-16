# Função para compactar o Windows
function CompactWindows {
    Write-Host "Verificando estado da compactação do Windows..." -ForegroundColor Cyan
    $status = compact /compactOS:query
    if ($status -match "System is already in the requested state") {
        Write-Host "O Windows já está compactado." -ForegroundColor Yellow
    } else {
        Write-Host "Compactando o Windows..." -ForegroundColor Green
        try {
            compact /compactOS:always
            Write-Host "Processo de compactação concluído." -ForegroundColor Green
        } catch {
            Write-Host "Falha ao compactar o Windows: $_" -ForegroundColor Red
        }
    }
}

CompactWindows
