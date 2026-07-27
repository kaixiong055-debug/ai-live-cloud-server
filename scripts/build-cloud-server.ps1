<#
.SYNOPSIS
    安全构建 AI 伴播云端后端项目。

.DESCRIPTION
    流程：
    1. 调用 stop-ai-live-server.ps1 停止后台进程
    2. 等待 target 目录中的文件句柄释放
    3. 确认无占用后执行 mvn clean install -DskipTests

.EXAMPLE
    .\scripts\build-cloud-server.ps1
#>

$ErrorActionPreference = "Stop"
$ProjectPath = "E:\github\ai-live-cloud-server"
$TargetFile = Join-Path $ProjectPath "yudao-server\target\application.stdout.log"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================"
Write-Host "  AI Live Server - Build Script"
Write-Host "========================================"

# Step 1: Stop any running AI Live server
Write-Host ""
Write-Host "[STEP 1/4] Stopping AI Live server..."
$stopScript = Join-Path $ScriptDir "stop-ai-live-server.ps1"
if (Test-Path $stopScript) {
    & $stopScript
} else {
    Write-Host "[WARN] stop-ai-live-server.ps1 not found, skipping stop step." -ForegroundColor Yellow
}

# Step 2: Wait for file handle release
Write-Host ""
Write-Host "[STEP 2/4] Checking for file handle release..."

$released = $false
for ($i = 1; $i -le 10; $i++) {
    if (Test-Path $TargetFile) {
        try {
            # 尝试以写模式打开文件来测试是否被占用
            $stream = [System.IO.File]::Open($TargetFile, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
            $stream.Dispose()
            $released = $true
            Write-Host "[OK] File handle released: $TargetFile" -ForegroundColor Green
            break
        } catch {
            Write-Host "[WAIT] File still locked, waiting... ($i/10s)"
            Start-Sleep -Seconds 1
        }
    } else {
        $released = $true
        Write-Host "[OK] Target file does not exist, no lock to worry about." -ForegroundColor Green
        break
    }
}

if (-not $released) {
    Write-Host "[ERROR] File handle NOT released after 10 seconds." -ForegroundColor Red
    Write-Host "[ERROR] File: $TargetFile" -ForegroundColor Red
    Write-Host "[HINT] Manually check which process is locking the file (e.g., using Process Explorer or 'handle' tool)." -ForegroundColor Yellow
    exit 1
}

# Step 3: Run Maven clean install
Write-Host ""
Write-Host "[STEP 3/4] Running: mvn clean install -DskipTests"
Write-Host ""
Push-Location $ProjectPath
try {
    mvn clean install -DskipTests
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "[FAIL] Maven build failed with exit code: $LASTEXITCODE" -ForegroundColor Red
        exit $LASTEXITCODE
    }
} finally {
    Pop-Location
}

Write-Host ""
Write-Host "[STEP 4/4] Build completed successfully!" -ForegroundColor Green
exit 0
