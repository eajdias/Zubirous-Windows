# Função para verificar e compactar o Windows
function CompactWindows {
    Write-Host "`nVerificando o estado da compactação do Windows..." -ForegroundColor Cyan
    try {
        # Captura a saída do comando de verificação
        $queryOutput = & compact /compactOS:query 2>&1

        if ($queryOutput -match "The system is already in the requested state") {
            Write-Host "O Windows já está compactado." -ForegroundColor Yellow
        } else {
            Write-Host "O Windows não está compactado. Iniciando compactação..." -ForegroundColor Green
            # Compacta o Windows
            $process = Start-Process -FilePath "compact.exe" -ArgumentList "/compactOS:always" -NoNewWindow -Wait -PassThru

            # Verifica o código de saída
            if ($process.ExitCode -eq 0) {
                Write-Host "Processo de compactação concluído com sucesso." -ForegroundColor Green
            } else {
                Write-Host "Falha ao compactar o Windows. Código de saída: $($process.ExitCode)" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "Ocorreu um erro ao executar a compactação: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Executar a função de compactação do Windows
CompactWindows
