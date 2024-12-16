Set-ExecutionPolicy RemoteSigned -Scope Process

function Optimize-NetworkSettings {
    # Exibe os adaptadores de rede disponíveis
    Get-NetAdapter

    # Configura os servidores DNS do Google para IPv4
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8","8.8.4.4")

    # Configura os servidores DNS do Google para IPv6
    Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("2001:4860:4860::8888","2001:4860:4860::8844")

    # Limpa o cache DNS
    Clear-DnsClientCache

    # Libera o endereço IP atual
    ipconfig /release

    # Renova o endereço IP
    ipconfig /renew

    # Redefine as configurações de TCP/IP
    netsh int ip reset

    # Redefine o catálogo Winsock
    netsh winsock reset

    # Limpa e recarrega a tabela de nomes NetBIOS
    nbtstat -R

    # Exibe as configurações atuais dos servidores DNS
    Get-DnsClientServerAddress -InterfaceAlias "Ethernet"
}

Optimize-NetworkSettings
