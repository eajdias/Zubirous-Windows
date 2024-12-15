# Função para limpar arquivos temporários
function Clear-TemporaryFiles {
    Write-Output "Limpando arquivos temporários..."
    $paths = @("$env:TEMP\*", "C:\Windows\Temp")

    foreach ($path in $paths) {
        try {
            # Verifica se o diretório existe antes de tentar remover
            if (Test-Path $path) {
                Get-ChildItem -Path $path -Recurse -Force | ForEach-Object {
                    try {
                        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction Stop
                        Write-Output "Removido: $($_.FullName)"
                    } catch {
                        Write-Output "Não foi possível remover: $($_.FullName)"
                    }
                }
                Write-Output "Arquivos em $path removidos."
            } else {
                Write-Output "O caminho $path não existe."
            }
        } catch {
            Write-Output "Erro ao limpar $path. Detalhes: $_"
        }
    }
}

# Função para remover bloatware
function Remove-AppxPackages {
    param (
        [array]$Packages
    )
    foreach ($package in $Packages) {
        try {
            $result = Get-AppxPackage -Name $package -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction Stop
            if ($result) {
                Write-Output "Pacote removido: $package"
            } else {
                Write-Output "Pacote não encontrado: $package"
            }
        } catch {
            Write-Output "Erro ao remover o pacote: $package"
        }
    }
}

# Lista de pacotes do Windows a serem removidos (bloatware)
$packagesToRemove = @(
    # Jogos e Xbox
    "Microsoft.XboxApp",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.GamingApp",

    # Ferramentas e Experiências
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsSoundRecorder",

    # Realidade Mista
    "Microsoft.MixedReality.Portal",

    # Mídia e Notícias
    "Microsoft.News",
    "Microsoft.HEIFImageExtension",
    "Microsoft.WebMediaExtensions",
    "Microsoft.WebpImageExtension",
    "Microsoft.ShoppingApp",

    # Widgets
    "MicrosoftWindows.Client.WebExperience",

    # Suporte e Demonstração
    "Microsoft.GetHelp",
    "Microsoft.WindowsMaps",

    # Outros
    "Microsoft.OneConnect",
    "Microsoft.People"
)

Clear-TemporaryFiles
Remove-AppxPackages -Packages $packagesToRemove

