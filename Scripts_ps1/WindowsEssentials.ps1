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
    "microsoft.powershell",
    "microsoft.vcredist.2005.x64",
    "microsoft.vcredist.2005.x86",
    "microsoft.vcredist.2008.x64",
    "microsoft.vcredist.2008.x86",
    "microsoft.vcredist.2010.x64",
    "microsoft.vcredist.2010.x86",
    "microsoft.vcredist.2012.x64",
    "microsoft.vcredist.2012.x86",
    "microsoft.vcredist.2013.x64",
    "microsoft.vcredist.2013.x86",
    "microsoft.vcredist.2015+.x64",
    "microsoft.vcredist.2015+.x86",
    "microsoft.dotnet.desktopruntime.preview",
    "oracle.javaruntimeenvironment",
    "microsoft.dotnet.runtime.preview",
    "microsoft.xnaredist",
    "directx"
    "gyan.ffmpeg",
    "fastfetch-cli.fastfetch",
    "7zip.7zip",
    "crystalrich.lockhunter",
    "bleachbit",
    "google.googledrive",
    "zeussoftware.nglide",
    "voidtools.everything",
    "file-new-project.eartrumpet",
    "brave.brave.nightly",
    "klocman.bulkcrapuninstaller",
    "skillbrains.lightshot",
    "meld.meld",
    "adrienallard.fileconverter",
    "notepad++.notepad++",
    "localsend.localsend",
    "yt-dlp.yt-dlp",
    "videolan.vlc",
    "rustdesk.rustdesk",
    "obsproject.obsstudio",
    "ramensoftware.windhawk"
)

Install-ChocoPackages -Packages $ChocoPackages
