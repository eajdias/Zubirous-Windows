# Função para limpar arquivos temporários
function Clear-TemporaryFiles {
    Write-Host "Iniciando limpeza de arquivos temporários..." -ForegroundColor Cyan
    $paths = @("$env:TEMP\*", "C:\Windows\Temp")

    foreach ($path in $paths) {
        try {
            # Verifica se o diretório existe antes de tentar remover
            if (Test-Path $path) {
                Write-Host "Limpando arquivos em: $path" -ForegroundColor Yellow
                Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
                Write-Host "Arquivos em $path removidos com sucesso." -ForegroundColor Green
            } else {
                Write-Host "O caminho $path não existe." -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Erro ao limpar $path. Detalhes: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}


# Função para remover bloatware
function Remove-AppxPackages {
    param (
        [array]$Packages
    )

    Write-Host "Iniciando remoção de pacotes desnecessários..." -ForegroundColor Cyan

    foreach ($package in $Packages) {
        try {
            $installedPackage = Get-AppxPackage -Name $package -ErrorAction SilentlyContinue
            if ($installedPackage) {
                Write-Host "Removendo pacote: $package" -ForegroundColor Yellow
                Remove-AppxPackage -Package $installedPackage.PackageFullName -ErrorAction Stop
                Write-Host "Pacote removido com sucesso: $package" -ForegroundColor Green
            } else {
                Write-Host "Pacote não encontrado ou já removido: $package" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Erro ao remover o pacote ${package}: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "Remoção de pacotes concluída." -ForegroundColor Cyan
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

# Executar a limpeza
Clear-TemporaryFiles
Remove-AppxPackages -Packages $packagesToRemove
