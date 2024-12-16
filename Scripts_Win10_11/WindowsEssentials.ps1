# Caminho do arquivo de log
$LogFile = "$env:TEMP\choco_install_log.txt"

# Verificar permissões administrativas
function Test-AdminPrivileges {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
        exit
    }
}

# Verificar se o Chocolatey está disponível
function Test-Chocolatey {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey não está instalado ou não foi encontrado. Instale o Chocolatey antes de executar este script." -ForegroundColor Red
        exit
    }
}

# Função para obter pacotes instalados localmente
function Get-InstalledChocoPackages {
    Write-Host "Verificando pacotes instalados localmente..." -ForegroundColor Cyan
    $installed = choco list --local-only --limit-output | ForEach-Object { ($_ -split '\|')[0].Trim() }
    return $installed
}

# Função para instalar pacotes via Chocolatey
function Install-ChocoPackages {
    param (
        [array]$Packages
    )

    $installedPackages = Get-InstalledChocoPackages

    foreach ($package in $Packages) {
        if ($installedPackages -contains $package) {
            Write-Host "Pacote já instalado: ${package}" -ForegroundColor Yellow
        } else {
            try {
                Write-Host "Instalando o pacote: ${package}..." -ForegroundColor Cyan
                choco install $package -y --ignore-checksums | Out-File -Append -FilePath $LogFile -Encoding UTF8
                Write-Host "Pacote instalado com sucesso: ${package}" -ForegroundColor Green
            } catch {
                Write-Host "Erro ao instalar o pacote ${package}: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}

# Lista de pacotes para instalação via Chocolatey
$ChocoPackages = @(
    "chocolatey-core.extension", "webview2-runtime",
    "curl", "wget", "python", "vcredist2005", "vcredist2008", "vcredist2010",
    "vcredist2012", "vcredist2013", "vcredist2015", "vcredist2017", "vcredist140",
    "dotnet3.5", "dotnet4.5.2", "dotnet4.6.1", "dotnetfx", "dotnet-desktopruntime",
    "dotnet-runtime", "jre8", "xna", "directx", "ffmpeg", "nuget.commandline",
    "awscli", "nvm", "yarn", "nodejs", "jq", "git", "gh", "github-desktop",
    "vscode", "dotnet-sdk", "correttojdk", "mysql.workbench", "fastfetch",
    "7zip", "lockhunter", "bleachbit", "googledrive", "everything", "eartrumpet",
    "brave-nightly", "bulk-crap-uninstaller", "lightshot", "meld", "file-converter",
    "notepadplusplus", "localsend", "yt-dlp", "vlc", "rustdesk", "anydesk",
    "thunderbird", "keepass", "audacity", "treesizefree", "windhawk"
)

# Criar arquivo de log se não existir
if (-not (Test-Path $LogFile)) {
    New-Item -Path $LogFile -ItemType File | Out-Null
}

# Executar verificações e instalação
Test-AdminPrivileges
Test-Chocolatey
Write-Host "==== Iniciando Instalação de Pacotes via Chocolatey ====" -ForegroundColor Magenta
Install-ChocoPackages -Packages $ChocoPackages
