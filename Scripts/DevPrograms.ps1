# Utilitários para desenvolvedores de programas
function Install-DevTools {
    $packagesToInstall = @(
        "nuget.commandline",
        "awscli",
        "dotnet-sdk",            
        "corretto11jdk",          
        "nodejs",                 
        "git",
        "gh",                     
        "github-desktop",
        "mysql.workbench",
        "vscode"
    )

    foreach ($package in $packagesToInstall) {
        try {
            # Verificar se o pacote já está instalado
            $isInstalled = choco list --local-only | Select-String -Pattern "^$package$"

            if (-not $isInstalled) {
                Write-Output "Instalando pacote: $package..."
                choco install $package -y | Out-File -Append $LogFile
                Write-Output "Pacote instalado com sucesso: $package"
            } else {
                Write-Output "Pacote já instalado: $package"
            }
        } catch {
            Write-Output "Erro ao verificar/instalar o pacote: $package. Detalhes: $_"
        }
    }
}

Install-DevTools

