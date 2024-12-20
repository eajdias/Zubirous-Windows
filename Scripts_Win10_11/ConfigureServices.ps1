# Verificação de permissões administrativas
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script deve ser executado com permissões administrativas." -ForegroundColor Red
    exit
}

# Função para configurar o estado de serviços
function Set-ServiceState {
    param (
        [string]$ServiceNamePattern, # Suporta nomes coringa com *
        [string]$StartupType         # Tipos: Automatic, Manual, Disabled
    )

    # Buscar serviços que correspondem ao padrão
    $services = Get-Service -Name $ServiceNamePattern -ErrorAction SilentlyContinue

    if ($services) {
        foreach ($service in $services) {
            try {
                # Obter o modo de inicialização atual usando Get-CimInstance
                $currentType = (Get-CimInstance -ClassName Win32_Service -Filter "Name='$($service.Name)'" -ErrorAction Stop).StartMode

                # Ignorar serviços gerenciados dinamicamente
                if ($service.Name -match ".*_.*") {
                    Write-Host "Serviço ignorado (gerenciado dinamicamente): $($service.Name)" -ForegroundColor Yellow
                    continue
                }

                # Alterar o modo de inicialização se necessário
                if ($currentType -ne $StartupType) {
                    # Alternativa usando 'sc.exe' para serviços que falham com Set-Service
                    sc.exe config $service.Name start= $StartupType | Out-Null
                    Write-Host "Configuração alterada: $($service.Name) -> $StartupType" -ForegroundColor Green
                } else {
                    Write-Host "Sem alteração necessária para: $($service.Name)" -ForegroundColor Cyan
                }
            } catch {
                Write-Host "Erro ao configurar o serviço: $($service.Name). Detalhes: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Nenhum serviço encontrado para o padrão: $ServiceNamePattern" -ForegroundColor Yellow
    }
}

# Lista de serviços e seus estados desejados
$servicesToConfigure = @{
    "CDPUserSvc_*"    = "Automatic"
    "COMSysApp"       = "Manual"
    "CaptureService_*"= "Manual"
    "CertPropSvc"     = "Manual"
    "ClipSVC" = "Manual"
    "ConsentUxUserSvc_*" = "Manual"
    "CoreMessagingRegistrar" = "Automatic"
    "CredentialEnrollmentManagerUserSvc_*" = "Manual"
    "CryptSvc" = "Automatic"
    "CscService" = "Manual"
    "DPS" = "Automatic"
    "DcomLaunch" = "Automatic"
    "DcpSvc" = "Manual"
    "DevQueryBroker" = "Manual"
    "DeviceAssociationBrokerSvc_*" = "Manual"
    "DeviceAssociationService" = "Manual"
    "DeviceInstall" = "Manual"
    "DevicePickerUserSvc_*" = "Manual"
    "DevicesFlowUserSvc_*" = "Manual"
    "Dhcp" = "Automatic"
    "DiagTrack" = "Disabled"
    "DialogBlockingService" = "Disabled"
    "DispBrokerDesktopSvc" = "Automatic"
    "DisplayEnhancementService" = "Manual"
    "DmEnrollmentSvc" = "Manual"
    "Dnscache" = "Automatic"
    "DoSvc" = "AutomaticDelayedStart"
    "DsSvc" = "Manual"
    "DsmSvc" = "Manual"
    "DusmSvc" = "Manual"
    "EFS" = "Manual"
    "EapHost" = "Manual"
    "EntAppSvc" = "Manual"
    "EventLog" = "Automatic"
    "EventSystem" = "Automatic"
    "FDResPub" = "Manual"
    "Fax" = "Manual"
    "FontCache" = "Manual"
    "FrameServer" = "Manual"
    "FrameServerMonitor" = "Manual"
    "GraphicsPerfSvc" = "Manual"
    "HomeGroupListener" = "Manual"
    "HomeGroupProvider" = "Manual"
    "HvHost" = "Manual"
    "IEEtwCollectorService" = "Manual"
    "IKEEXT" = "Manual"
    "InstallService" = "Manual"
    "InventorySvc" = "Manual"
    "IpxlatCfgSvc" = "Manual"
    "KeyIso" = "Automatic"
    "KtmRm" = "Manual"
    "LSM" = "Automatic"
    "LanmanServer" = "Automatic"
    "LanmanWorkstation" = "Automatic"
    "LicenseManager" = "Manual"
    "LxpSvc" = "Manual"
    "MSDTC" = "Manual"
    "MSiSCSI" = "Manual"
    "MapsBroker" = "Manual"
    "McpManagementService" = "Manual"
    "MessagingService_*" = "Manual"
    "MicrosoftEdgeElevationService" = "Manual"
    "MixedRealityOpenXRSvc" = "Manual"
    "MpsSvc" = "Automatic"
    "MsKeyboardFilter" = "Manual"
    "NPSMSvc_*" = "Manual"
    "NaturalAuthentication" = "Manual"
    "NcaSvc" = "Manual"
    "NcbService" = "Manual"
    "NcdAutoSetup" = "Manual"
    "NetSetupSvc" = "Manual"
    "NetTcpPortSharing" = "Disabled"
    "Netlogon" = "Automatic"
    "Netman" = "Manual"
    "NgcCtnrSvc" = "Manual"
    "NgcSvc" = "Manual"
    "NlaSvc" = "Manual"
    "OneSyncSvc_*" = "Automatic"
    "P9RdrService_*" = "Manual"
    "PNRPAutoReg" = "Manual"
    "PNRPsvc" = "Manual"
    "PcaSvc" = "Manual"
    "PeerDistSvc" = "Manual"
    "PenService_*" = "Manual"
    "PerfHost" = "Manual"
    "PhoneSvc" = "Manual"
    "PimIndexMaintenanceSvc_*" = "Manual"
    "PlugPlay" = "Manual"
    "PolicyAgent" = "Manual"
    "Power" = "Automatic"
    "PrintNotify" = "Manual"
    "PrintWorkflowUserSvc_*" = "Manual"
    "ProfSvc" = "Automatic"
    "PushToInstall" = "Manual"
    "QWAVE" = "Manual"
    "RasAuto" = "Manual"
    "RasMan" = "Manual"
    "RemoteAccess" = "Disabled"
    "RemoteRegistry" = "Disabled"
    "RetailDemo" = "Manual"
    "RmSvc" = "Manual"
    "RpcEptMapper" = "Automatic"
    "RpcLocator" = "Manual"
    "RpcSs" = "Automatic"
    "SCPolicySvc" = "Manual"
    "SCardSvr" = "Manual"
    "SDRSVC" = "Manual"
    "SEMgrSvc" = "Manual"
    "SENS" = "Automatic"
    "SNMPTRAP" = "Manual"
    "SSDPSRV" = "Manual"
    "SamSs" = "Automatic"
    "ScDeviceEnum" = "Manual"
    "Schedule" = "Automatic"
    "Sense" = "Manual"
    "SensorDataService" = "Manual"
    "SensorService" = "Manual"
    "SensrSvc" = "Manual"
    "SessionEnv" = "Manual"
    "SgrmBroker" = "Automatic"
    "SharedAccess" = "Manual"
    "SharedRealitySvc" = "Manual"
    "ShellHWDetection" = "Automatic"
    "SmsRouter" = "Manual"
    "Spooler" = "Manual"
    "SstpSvc" = "Manual"
    "StateRepository" = "Manual"
    "StiSvc" = "Manual"
    "StorSvc" = "Manual"
    "SysMain" = "Manual"
    "SystemEventsBroker" = "Automatic"
    "TabletInputService" = "Manual"
    "TapiSrv" = "Manual"
    "TermService" = "Automatic"
    "TextInputManagementService" = "Manual"
    "Themes" = "Manual"
    "TieringEngineService" = "Manual"
    "TimeBrokerSvc" = "Manual"
    "TokenBroker" = "Manual"
    "TrkWks" = "Manual"
    "TroubleshootingSvc" = "Manual"
    "TrustedInstaller" = "Manual"
    "UI0Detect" = "Manual"
    "UdkUserSvc_*" = "Manual"
    "UevAgentService" = "Disabled"
    "UmRdpService" = "Manual"
    "UnistoreSvc_*" = "Manual"
    "UserDataSvc_*" = "Manual"
    "UserManager" = "Automatic"
    "UsoSvc" = "Manual"
    "VGAuthService" = "Automatic"
    "VMTools" = "Automatic"
    "VSS" = "Manual"
    "VacSvc" = "Manual"
    "VaultSvc" = "Automatic"
    "W32Time" = "Manual"
    "WEPHOSTSVC" = "Manual"
    "WFDSConMgrSvc" = "Manual"
    "WMPNetworkSvc" = "Manual"
    "WManSvc" = "Manual"
    "WPDBusEnum" = "Manual"
    "WSService" = "Manual"
    "WSearch" = "Disabled"
    "WaaSMedicSvc" = "Manual"
    "WalletService" = "Manual"
    "WarpJITService" = "Manual"
    "WbioSrvc" = "Manual"
    "Wcmsvc" = "Automatic"
    "WcsPlugInService" = "Manual"
    "WdNisSvc" = "Manual"
    "WdiServiceHost" = "Manual"
    "WdiSystemHost" = "Manual"
    "WebClient" = "Manual"
    "Wecsvc" = "Manual"
    "WerSvc" = "Manual"
    "WiaRpc" = "Manual"
    "WinDefend" = "Automatic"
    "WinHttpAutoProxySvc" = "Manual"
    "WinRM" = "Manual"
    "Winmgmt" = "Automatic"
    "WlanSvc" = "Automatic"
    "WpcMonSvc" = "Manual"
    "WpnService" = "Manual"
    "WpnUserService_*" = "Automatic"
    "XblAuthManager" = "Manual"
    "XblGameSave" = "Manual"
    "XboxGipSvc" = "Manual"
    "XboxNetApiSvc" = "Manual"
    "autotimesvc" = "Manual"
    "bthserv" = "Manual"
    "camsvc" = "Manual"
    "cbdhsvc_*" = "Manual"
    "cloudidsvc" = "Manual"
    "dcsvc" = "Manual"
    "defragsvc" = "Manual"
    "diagnosticshub.standardcollector.service" = "Manual"
    "cplspcon" = "Disabled"
    "cphs" = "Disabled"
    "lfsvc" = "Manual"
    "ndu" = "Manual"
    "fhsvc" = "Manual"
    "AJRouter" = "Manual"
    "ALG" = "Manual"
    "iphlpsvc" = "Manual"
    "vmickvpexchange" = "Manual"
    "vmicguestinterface" = "Manual"
    "vmicshutdown" = "Manual"
    "vmicheartbeat" = "Manual"
    "vmicvmsession" = "Manual"
    "vmicrdv" = "Manual"
    "vmictimesync" = "Manual"
    "ClickToRunSvc" = "Manual"
}

# Ativar a função de configuração dos serviços
Write-Host "Configurando serviços do Windows..." -ForegroundColor Cyan
foreach ($service in $servicesToConfigure.GetEnumerator()) {
    Set-ServiceState -ServiceNamePattern $service.Key -StartupType $service.Value
}

