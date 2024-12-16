# Função para descompactar o Windows
function DecompactWindows {
    Write-Host "`nVerificando o estado da compactação do Windows..." -ForegroundColor Cyan

    try {
        # Captura a saída do comando de verificação
        $queryOutput = & compact /compactOS:query 2>&1

        if ($queryOutput -match "The system is not in the Compact state") {
            Write-Host "O Windows já está descompactado. Nenhuma ação é necessária." -ForegroundColor Yellow
        } else {
            Write-Host "O Windows está compactado. Iniciando descompactação..." -ForegroundColor Green

            # Executa o comando para descompactar o Windows
            $process = Start-Process -FilePath "compact.exe" -ArgumentList "/compactOS:never" -NoNewWindow -Wait -PassThru

            # Verifica o código de saída do comando
            if ($process.ExitCode -eq 0) {
                Write-Host "Descompactação do Windows concluída com sucesso!" -ForegroundColor Green
            } else {
                Write-Host "Falha ao descompactar o Windows. Código de saída: $($process.ExitCode)" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "Ocorreu um erro ao descompactar o Windows: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Executar a função para descompactar o Windows
DecompactWindows
