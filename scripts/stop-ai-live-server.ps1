<#
.SYNOPSIS
    安全停止 AI 伴播云端后端进程，不会误杀其他 Java 程序。

.DESCRIPTION
    通过 WMI 查询命令行中包含 AiLiveServerApplication 且路径属于当前项目的 Java 进程。
    先尝试正常停止（Ctrl+C 信号），等待最多 10 秒后仍未退出才强制终止。

.EXAMPLE
    .\scripts\stop-ai-live-server.ps1
#>

$ErrorActionPreference = "Stop"
$ProjectPath = "E:\github\ai-live-cloud-server"

Write-Host "========================================"
Write-Host "  AI Live Server - Stop Script"
Write-Host "========================================"

# 查找与当前项目相关的 Java 进程
$foundPids = @()

try {
    $processes = Get-WmiObject -Class Win32_Process -Filter "Name='java.exe'" -ErrorAction Stop
} catch {
    Write-Host "[ERROR] Cannot query WMI. Try running as Administrator." -ForegroundColor Red
    exit 1
}

foreach ($proc in $processes) {
    $cmdLine = $proc.CommandLine
    if (-not $cmdLine) { continue }

    # 严格匹配：命令行包含主类名且路径属于当前项目
    $matchesMain = $cmdLine -match "AiLiveServerApplication"
    $matchesProject = $cmdLine -match [regex]::Escape($ProjectPath)

    if ($matchesMain -and $matchesProject) {
        $foundPids += $proc.ProcessId
        Write-Host "[FOUND] PID: $($proc.ProcessId)  CommandLine: $($cmdLine.Substring(0, [Math]::Min(200, $cmdLine.Length)))..."
    }
}

if ($foundPids.Count -eq 0) {
    Write-Host "[INFO] AI Live server is not running." -ForegroundColor Green
    exit 0
}

Write-Host "[ACTION] Stopping $($foundPids.Count) process(es)..."

# 第一步：正常停止（taskkill 无 /F）
$stopped = @()
$pending = $foundPids

foreach ($pid in $pending) {
    taskkill /PID $pid 2>$null | Out-Null
}

# 等待最多 10 秒
$maxWait = 10
for ($i = 1; $i -le $maxWait; $i++) {
    $stillRunning = @()
    foreach ($pid in $pending) {
        $p = Get-Process -Id $pid -ErrorAction SilentlyContinue
        if ($p) {
            $stillRunning += $pid
        } else {
            if ($stopped -notcontains $pid) {
                $stopped += $pid
            }
        }
    }
    $pending = $stillRunning

    if ($pending.Count -eq 0) {
        Write-Host "[OK] All processes stopped gracefully: $($stopped -join ', ')" -ForegroundColor Green
        exit 0
    }
    Write-Host "[WAIT] $($pending.Count) process(es) still running... ($i/${maxWait}s)"
    Start-Sleep -Seconds 1
}

# 第二步：强制停止
if ($pending.Count -gt 0) {
    Write-Host "[WARN] Graceful shutdown timeout. Force killing remaining processes..." -ForegroundColor Yellow
    foreach ($pid in $pending) {
        taskkill /F /PID $pid 2>$null | Out-Null
        $stopped += $pid
        Write-Host "[KILLED] PID: $pid" -ForegroundColor Yellow
    }
}

Write-Host "[OK] All processes stopped: $($stopped -join ', ')" -ForegroundColor Green
exit 0
