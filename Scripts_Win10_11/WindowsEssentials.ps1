# Função para instalar pacotes via Chocolatey
function Install-ChocoPackages {
    param (
        [array]$Packages
    )
    foreach ($package in $Packages) {
        try {
            if (-not (choco list --local-only | Select-String -Pattern "^$package$")) {
                Write-Output "Instalando o pacote: ${package}..."
                choco install $package -y | Out-File -Append $LogFile
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
    "powershell-core --pre",
    "curl",
    "python",
    "vcredist2005",
    "vcredist2008",
    "vcredist2010",
    "vcredist2012",
    "vcredist2013",
    "vcredist2015",
    "vcredist2017",
    "vcredist140",
    "dotnet-desktopruntime",
    "dotnet-runtime",
    "javaruntime",
    "xna",
    "directx"
    "ffmpeg",
    "nuget.commandline",
    "awscli",
    "nvm",  
    "nodejs",                 
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
    "brave-nightly --pre",
    "bulk-crap-uninstaller",
    "lightshot",
    "meld",
    "file-converter",
    "notepadplusplus",
    "localsend",
    "yt-dlp",
    "vlc",
    "rustdesk",
    "obs-studio",
    "windhawk"
)

Install-ChocoPackages -Packages $ChocoPackages
