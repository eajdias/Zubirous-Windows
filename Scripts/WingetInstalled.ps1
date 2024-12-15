# Função para verificar se o Winget está instalado
function WingetInstalled {
    try {
        $wingetVersion = winget -v
        if ($wingetVersion) {
            Write-Output "Winget já está instalado. Versão: $wingetVersion"
            return $true
        }
    } catch {
        Write-Output "Winget não encontrado no sistema."
        return $false
    }
}

# Configuração do Winget
function Install-Winget {
    if (-not (WingetInstalled)) {
        try {
            Write-Output "Baixando e instalando o Winget..."
            $WingetInstaller = "$env:Temp\winget.appxbundle"
            Invoke-WebRequest -Uri "https://aka.ms/get-winget" -OutFile $WingetInstaller
            Add-AppxPackage -Path $WingetInstaller
            Write-Output "Winget instalado com sucesso."
        } catch {
            Write-Output "Erro ao instalar o Winget: $_"
        }
    }
}