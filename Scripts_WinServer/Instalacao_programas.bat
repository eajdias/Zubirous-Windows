@echo off
:: Script para instalar Chocolatey e pacotes com PowerShell

echo ================================================
echo Instalando o Chocolatey e pacotes essenciais...
echo ================================================

:: Instalar Chocolatey
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
if %ERRORLEVEL% neq 0 (
    echo Falha ao instalar o Chocolatey. Saindo...
    exit /b 1
)

:: Instalar pacotes do Chocolatey
choco install netfx-4.8.1 -y
choco install vcredist-all -y
choco install microsoft.powershell -y
choco install microsoft.dotnet.desktopruntime.preview -y
choco install oracle.javaruntimeenvironment -y
choco install microsoft.dotnet.runtime.preview -y
choco install microsoft.xnaredist -y
choco install fastfetch-cli.fastfetch -y
choco install 7zip.7zip -y
choco install crystalrich.lockhunter -y
choco install bleachbit -y
choco install brave.brave.nightly -y
choco install klocman.bulkcrapuninstaller -y
choco install skillbrains.lightshot -y
choco install notepad++.notepad++ -y
choco install rustdesk.rustdesk -y

:: Atualizar o Windows (usando PowerShell)
echo ================================================
echo Instalando atualizações do Windows...
echo ================================================

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "Install-Module PSWindowsUpdate -Force; Get-WindowsUpdate; Install-WindowsUpdate -AcceptAll"

if %ERRORLEVEL% neq 0 (
    echo Falha ao instalar atualizações. Saindo...
    exit /b 1
)

echo ================================================
echo Instalação concluída com sucesso!
echo ================================================
pause
