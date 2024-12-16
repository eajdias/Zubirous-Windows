# Função para instalar pacotes via Chocolatey
function Install-ChocoPackages {
    param (
        [array]$Packages
    )
    foreach ($package in $Packages) {
        try {
            # Obtém a lista de pacotes instalados
            $installedPackages = choco list --local-only | ForEach-Object { ($_ -split '\|')[0].Trim() }

            # Verifica se o pacote já está instalado
            if (-not ($installedPackages -contains $package)) {
                Write-Output "Instalando o pacote: ${package}..."
                choco install $package -y --ignore-checksums | Out-File -Append $LogFile
                Write-Output "Pacote ${package} instalado com sucesso."
            } else {
                Write-Output "Pacote já instalado: ${package}"
            }
        } catch {
            Write-Output "Erro ao instalar o pacote ${package}: $_"
        }
    }
}

# Lista de pacotes para instalação via Chocolatey
$ChocoPackages = @(
    "chocolatey-core.extension",
    "microsoft-ui-xaml-2-7",
    "webview2-runtime",
    "powershell-core",
    "curl",
    "wget",
    "python",
    "vcredist2005",
    "vcredist2008",
    "vcredist2010",
    "vcredist2012",
    "vcredist2013",
    "vcredist2015",
    "vcredist2017",
    "vcredist140",
    "dotnet3.5",
    "dotnet4.5.2",
    "dotnet4.6.1",
    "dotnetfx",
    "dotnet-desktopruntime",
    "dotnet-runtime",
    "jre8",
    "xna",
    "directx",
    "ffmpeg",
    "nuget.commandline",
    "awscli",
    "nvm",
    "yarn",
    "nodejs",
    "jq",
    "git",
    "gh",
    "github-desktop",
    "vscode",
    "dotnet-sdk",
    "correttojdk",
    "mysql.workbench",
    "fastfetch",
    "7zip",
    "lockhunter",
    "bleachbit",
    "googledrive",
    "everything",
    "eartrumpet",
    "brave-nightly",
    "bulk-crap-uninstaller",
    "lightshot",
    "meld",
    "file-converter",
    "notepadplusplus",
    "localsend",
    "yt-dlp",
    "vlc",
    "rustdesk",
    "anydesk",
    "thunderbird",
    "keepass",
    "obs-studio",
    "audacity",
    "treesizefree",
    "windhawk"
)

# Ajuste para criar arquivo de log, caso ainda não exista
$LogFile = "$env:TEMP\choco_install_log.txt"
if (-not (Test-Path $LogFile)) {
    New-Item -Path $LogFile -ItemType File | Out-Null
}

Install-ChocoPackages -Packages $ChocoPackages
