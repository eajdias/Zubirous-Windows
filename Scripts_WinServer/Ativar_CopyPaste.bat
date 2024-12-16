@echo off
:: Ativar copiar e colar na VM do Windows Server

:: Define a URL do instalador e o caminho de destino
set "SpiceToolsUrl=https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe"
set "DownloadPath=%USERPROFILE%\Downloads\spice-guest-tools-latest.exe"

echo ================================================
echo Baixando Spice Guest Tools...
echo ================================================

:: Baixar o instalador
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "try { Invoke-WebRequest -Uri '%SpiceToolsUrl%' -OutFile '%DownloadPath%' -ErrorAction Stop } catch { Write-Host 'Erro ao baixar o arquivo: $_'; exit 1 }"
if %ERRORLEVEL% neq 0 (
    echo Falha ao baixar o arquivo. Saindo...
    exit /b 1
)

echo ================================================
echo Instalando Spice Guest Tools...
echo ================================================

:: Executar o instalador em modo silencioso
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "try { Start-Process -FilePath '%DownloadPath%' -ArgumentList '/S' -Wait -ErrorAction Stop } catch { Write-Host 'Erro durante a instalação: $_'; exit 1 }"
if %ERRORLEVEL% neq 0 (
    echo Falha durante a instalação. Saindo...
    exit /b 1
)

echo ================================================
echo Reiniciando o computador para aplicar as alterações...
echo ================================================

:: Reiniciar o computador
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "try { Restart-Computer -Force -ErrorAction Stop } catch { Write-Host 'Erro ao reiniciar o computador: $_'; exit 1 }"
if %ERRORLEVEL% neq 0 (
    echo Falha ao reiniciar o computador. Saindo...
    exit /b 1
)

echo Operação concluída com sucesso!
pause
