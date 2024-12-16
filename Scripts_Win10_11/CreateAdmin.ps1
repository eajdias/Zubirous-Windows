# Função para criar usuário administrador
function CreateAdminUser {
    Write-Host "Criando usuário administrador 'WinAdmin'..." -ForegroundColor Cyan

    # Verifica se o usuário já existe
    if (Get-LocalUser -Name "WinAdmin" -ErrorAction SilentlyContinue) {
        Write-Host "O usuário 'WinAdmin' já existe." -ForegroundColor Yellow
        return
    }

    # Cria o usuário com a senha "123"
    net user WinAdmin 123 /add

    # Adiciona o usuário ao grupo de administradores
    net localgroup Administradores WinAdmin /add

    # Desativa a notificação de troca de senha obrigatória
    net user WinAdmin /logonpasswordchg:no

    # Desativa a expiração da senha
    $user = Get-CimInstance -ClassName Win32_UserAccount -Filter "Name='WinAdmin'"
    if ($user) {
        $user | Set-CimInstance -Property @{ PasswordExpires = $false }
        Write-Host "Configuração de expiração de senha desativada para 'WinAdmin'." -ForegroundColor Green
    } else {
        Write-Host "Não foi possível localizar o usuário 'WinAdmin' no WMI." -ForegroundColor Red
    }

    Write-Host "Usuário 'WinAdmin' criado com sucesso e configurado com senha 123." -ForegroundColor Green
}

# Chamda de função para criar usuario Administrador
CreateAdminUser
