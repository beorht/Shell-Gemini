# ShellGemini - Деинсталлятор для Windows
# Требует запуска от имени администратора

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║        Удаление ShellGemini CLI для Windows               ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

# [1/2] Удаление файлов программы
Write-Host "[1/2] Удаление исполняемых файлов..." -ForegroundColor Yellow

$InstallDir = "$env:ProgramFiles\ShellGemini"

if (Test-Path $InstallDir) {
    Remove-Item -Path $InstallDir -Recurse -Force
    Write-Host "✓ Удалена директория: $InstallDir" -ForegroundColor Green
} else {
    Write-Host "⚠ Директория установки не найдена" -ForegroundColor Yellow
}

# Удаление из PATH
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($CurrentPath -like "*$InstallDir*") {
    $NewPath = ($CurrentPath -split ';' | Where-Object { $_ -ne $InstallDir }) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
    Write-Host "✓ Удалено из PATH" -ForegroundColor Green
}

# [2/2] Запрос на удаление конфигурации
Write-Host "[2/2] Удаление конфигурации..." -ForegroundColor Yellow

$ConfigDir = Join-Path $env:USERPROFILE ".config\shell-gemini"

if (Test-Path $ConfigDir) {
    $Response = Read-Host "Удалить конфигурацию ($ConfigDir)? [y/N]"
    if ($Response -match '^[YyДд]$') {
        Remove-Item -Path $ConfigDir -Recurse -Force
        Write-Host "✓ Конфигурация удалена" -ForegroundColor Green
    } else {
        Write-Host "⚠ Конфигурация сохранена в $ConfigDir" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠ Директория конфигурации не найдена" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✓ Удаление завершено" -ForegroundColor Green
Write-Host ""
Write-Host "Примечание: " -ForegroundColor Yellow -NoNewline
Write-Host "Перезапустите терминал чтобы изменения PATH вступили в силу"
Write-Host ""
