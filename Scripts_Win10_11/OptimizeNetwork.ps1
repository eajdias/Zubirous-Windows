function Optimize-NetworkSettings {
    # Exibe os adaptadores de rede disponíveis
    Get-NetAdapter

    # Configura os servidores DNS do Google para IPv4
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8", "8.8.4.4")

    # Configura os servidores DNS do Google para IPv6
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("2001:4860:4860::8888", "2001:4860:4860::8844")

    # Limpa o cache DNS
    Clear-DnsClientCache

    # Libera o endereço IP atual
    Write-Host "Liberando o endereço IP atual..." -ForegroundColor Yellow
    cmd /c "ipconfig /release > nul 2>&1"

    # Renova o endereço IP
    Write-Host "Renovando o endereço IP..." -ForegroundColor Yellow
    cmd /c "ipconfig /renew > nul 2>&1"

    # Redefine as configurações de TCP/IP
    netsh int ip reset

    # Redefine o catálogo Winsock
    netsh winsock reset

    # Limpa e recarrega a tabela de nomes NetBIOS
    nbtstat -R

    # Exibe as configurações atuais dos servidores DNS (apenas as informações relevantes)
    Write-Host "Configurações de DNS atualizadas:" -ForegroundColor Cyan
    $dnsInfo = Get-DnsClientServerAddress -InterfaceAlias "Ethernet"
    foreach ($entry in $dnsInfo) {
        Write-Host "Interface: $($entry.InterfaceAlias)" -ForegroundColor Green
        Write-Host "Servidor DNS: $($entry.ServerAddresses -join ', ')" -ForegroundColor Yellow
    }
}

# Chamada de função para configuração geral da internet
Optimize-NetworkSettings
