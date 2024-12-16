@echo off

:: Desativar segurança em geral no Windows Server 2019 Standard

echo. && echo DESABILITANDO CONFIGURAÇÕES DE SEGURANÇA...
:: Desabilitar a configuração de segurança aprimorada para administradores
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v EnableEnhancedSecurity /t REG_DWORD /d 0 /f

:: Desabilitar a configuração de segurança aprimorada para usuários
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v EnableEnhancedSecurity /t REG_DWORD /d 0 /f

:: Ajustar a zona de segurança da Internet para "Low"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap" /v Internet /t REG_DWORD /d 0 /f

:: Desabilitar o Enhanced Protected Mode
reg add "HKCU\Software\Microsoft\Internet Explorer\Main" /v EnableProtectedMode /t REG_DWORD /d 0 /f

echo. && echo DESABILITANDO WINDOWS DEFENDER...
:: Desabilitar o Windows Defender
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f

:: Parar os serviços do Windows Defender
sc stop WinDefend
sc config WinDefend start= disabled

:: Reiniciar o computador
echo. && echo REINICIANDO O SISTEMA...
shutdown /r /t 5

echo. && echo CONFIGURAÇÕES ALTERADAS COM SUCESSO!
pause
