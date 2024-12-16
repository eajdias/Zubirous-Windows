function Update-GPUDrivers {
    # Obtém informações sobre as GPUs instaladas
    $gpuInfo = Get-CimInstance -ClassName Win32_VideoController

    # Verifica se há GPUs instaladas
    if ($null -eq $gpuInfo) {
        Write-Output "Nenhuma GPU detectada no sistema."
        return
    }

    # Inicializa variáveis para rastrear fabricantes detectados
    $hasNvidia = $false
    $hasAMD = $false
    $hasIntel = $false

    # Identifica os fabricantes das GPUs instaladas
    foreach ($gpu in $gpuInfo) {
        if ($gpu.Name -match "NVIDIA") {
            $hasNvidia = $true
        } elseif ($gpu.Name -match "AMD" -or $gpu.Name -match "Radeon") {
            $hasAMD = $true
        } elseif ($gpu.Name -match "Intel") {
            $hasIntel = $true
        }
    }

    # Função para instalar drivers NVIDIA
    function Install-NvidiaDriver {
        Write-Output "Instalando drivers NVIDIA..."
        choco install nvidia-display-driver -y
    }

    # Função para instalar drivers AMD
    function Install-AMDDriver {
        Write-Output "Instalando drivers AMD..."
        # Baixa a ferramenta de detecção automática da AMD
        $amdToolUrl = "https://drivers.amd.com/drivers/installer/Auto-Detect-and-Install-Tool.exe"
        $amdToolPath = "$env:TEMP\AMD-Auto-Detect.exe"
        Invoke-WebRequest -Uri $amdToolUrl -OutFile $amdToolPath

        # Executa a ferramenta de detecção automática
        Start-Process -FilePath $amdToolPath -ArgumentList "/S" -Wait
    }

    # Função para instalar drivers Intel
    function Install-IntelDriver {
        Write-Output "Instalando drivers Intel..."
        # Baixa a ferramenta de atualização de drivers da Intel
        $intelToolUrl = "https://downloadmirror.intel.com/28425/a08/Intel-Driver-and-Support-Assistant-Installer.exe"
        $intelToolPath = "$env:TEMP\Intel-Driver-Assistant.exe"
        Invoke-WebRequest -Uri $intelToolUrl -OutFile $intelToolPath

        # Executa a ferramenta de atualização de drivers
        Start-Process -FilePath $intelToolPath -ArgumentList "/S" -Wait
    }

    # Instala os drivers correspondentes às GPUs detectadas
    if ($hasNvidia) {
        Install-NvidiaDriver
    }
    if ($hasAMD) {
        Install-AMDDriver
    }
    if ($hasIntel) {
        Install-IntelDriver
    }

    # Mensagem final
    Write-Output "Processo de atualização de drivers concluído."
}

Update-GPUDrivers
