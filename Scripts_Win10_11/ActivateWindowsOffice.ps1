# Verificação de permissões administrativas
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
    exit
}

# Função para ativar o Windows ou Office
function ActivateWindowsOffice {
    Write-Host "Iniciando processo de ativação do Windows ou Office..." -ForegroundColor Cyan

    $activationUrl = "https://get.activated.win"

    try {
        # Verifica se a URL está acessível
        Write-Host "Baixando script de ativação..." -ForegroundColor Yellow
        $scriptContent = Invoke-RestMethod -Uri $activationUrl -ErrorAction Stop

        # Executa o conteúdo baixado diretamente
        Write-Host "Executando script de ativação..." -ForegroundColor Yellow
        Invoke-Command -ScriptBlock ([ScriptBlock]::Create($scriptContent))

        Write-Host "Processo de ativação concluído com sucesso." -ForegroundColor Green
    } catch {
        Write-Host "Falha ao ativar o Windows ou Office: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Chamar a função diretamente
ActivateWindowsOffice

