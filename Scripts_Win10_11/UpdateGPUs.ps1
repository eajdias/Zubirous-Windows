# Função: Instala drivers NVIDIA
function Install-NvidiaDriver {
    Write-Host "Instalando drivers NVIDIA..." -ForegroundColor Cyan
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Erro: Chocolatey não está instalado. Instale-o antes de continuar." -ForegroundColor Red
        return
    }
    choco install nvidia-display-driver -y
    Write-Host "Drivers NVIDIA instalados com sucesso!" -ForegroundColor Green
}

# Função: Instala drivers AMD
function Install-AMDDriver {
    Write-Host "Instalando drivers AMD..." -ForegroundColor Cyan
    try {
        $amdToolUrl = "https://drivers.amd.com/drivers/installer/Auto-Detect-and-Install-Tool.exe"
        $amdToolPath = "$env:TEMP\AMD-Auto-Detect.exe"

        Invoke-WebRequest -Uri $amdToolUrl -OutFile $amdToolPath -ErrorAction Stop
        Start-Process -FilePath $amdToolPath -ArgumentList "/S" -Wait -ErrorAction Stop
        Write-Host "Drivers AMD instalados com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao instalar drivers AMD: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Função: Instala drivers Intel
function Install-IntelDriver {
    Write-Host "Instalando drivers Intel..." -ForegroundColor Cyan
    try {
        $intelToolUrl = "https://downloadmirror.intel.com/28425/a08/Intel-Driver-and-Support-Assistant-Installer.exe"
        $intelToolPath = "$env:TEMP\Intel-Driver-Assistant.exe"

        Invoke-WebRequest -Uri $intelToolUrl -OutFile $intelToolPath -ErrorAction Stop
        Start-Process -FilePath $intelToolPath -ArgumentList "/S" -Wait -ErrorAction Stop
        Write-Host "Drivers Intel instalados com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "Erro ao instalar drivers Intel: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Função principal: Atualiza os drivers da GPU
function Update-GPUDrivers {
    Write-Host "`nVerificando GPUs instaladas..." -ForegroundColor Yellow
    $gpuInfo = Get-CimInstance -ClassName Win32_VideoController

    if (-not $gpuInfo) {
        Write-Host "Nenhuma GPU detectada no sistema." -ForegroundColor Red
        return
    }

    # Inicializa variáveis para rastrear fabricantes detectados
    $hasNvidia = $false
    $hasAMD = $false
    $hasIntel = $false

    # Identifica os fabricantes das GPUs instaladas
    foreach ($gpu in $gpuInfo) {
        if ($gpu.Name -match "NVIDIA") { $hasNvidia = $true }
        elseif ($gpu.Name -match "AMD" -or $gpu.Name -match "Radeon") { $hasAMD = $true }
        elseif ($gpu.Name -match "Intel") { $hasIntel = $true }
    }

    # Exibe GPUs detectadas
    if ($hasNvidia) { Write-Host "GPU NVIDIA detectada." -ForegroundColor Cyan }
    if ($hasAMD) { Write-Host "GPU AMD detectada." -ForegroundColor Cyan }
    if ($hasIntel) { Write-Host "GPU Intel detectada." -ForegroundColor Cyan }

    # Verifica se alguma GPU suportada foi detectada
    if (-not ($hasNvidia -or $hasAMD -or $hasIntel)) {
        Write-Host "Nenhuma GPU suportada detectada. Nada a fazer." -ForegroundColor Yellow
        return
    }

    # Instala os drivers correspondentes
    if ($hasNvidia) { Install-NvidiaDriver }
    if ($hasAMD) { Install-AMDDriver }
    if ($hasIntel) { Install-IntelDriver }

    Write-Host "`nProcesso de atualização de drivers concluído." -ForegroundColor Green
}

# Chamar a função principal
Update-GPUDrivers
