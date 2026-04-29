# ShellGemini - Установщик для Windows
# Требует запуска от имени администратора

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# Цвета для вывода
function Write-Step {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "Ошибка: $Message" -ForegroundColor Red
}

Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║        Установка ShellGemini CLI для Windows              ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

# [1/5] Проверка PowerShell версии
Write-Step "[1/5] Проверка версии PowerShell..."
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "Требуется PowerShell 5.1 или выше. Текущая версия: $($PSVersionTable.PSVersion)"
    exit 1
}
Write-Success "PowerShell версия $($PSVersionTable.PSVersion) подходит"

# [2/5] Копирование скрипта
Write-Step "[2/5] Установка исполняемого файла..."

# Определяем директорию установки
$InstallDir = "$env:ProgramFiles\ShellGemini"
$ScriptPath = Join-Path $InstallDir "shell-gm.ps1"

# Проверка наличия исходного файла
if (-not (Test-Path "src\shell-gm.ps1")) {
    Write-Error "Файл src\shell-gm.ps1 не найден в текущей директории"
    exit 1
}

# Создаем директорию установки
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Копируем скрипт
Copy-Item "src\shell-gm.ps1" -Destination $ScriptPath -Force
Write-Success "Скрипт установлен в $ScriptPath"

# [3/5] Создание bat-обёртки для удобного запуска
Write-Step "[3/5] Создание команды shell-gm..."

$BatchWrapper = @"
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$ScriptPath" %*
"@

$BatchPath = Join-Path $InstallDir "shell-gm.bat"
Set-Content -Path $BatchPath -Value $BatchWrapper -Encoding ASCII
Write-Success "Создан wrapper: $BatchPath"

# [4/5] Добавление в PATH
Write-Step "[4/5] Добавление в PATH..."

$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($CurrentPath -notlike "*$InstallDir*") {
    $NewPath = "$CurrentPath;$InstallDir"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
    Write-Success "Директория добавлена в PATH"
    Write-Warning "Перезапустите терминал чтобы изменения вступили в силу"
} else {
    Write-Success "Директория уже в PATH"
}

# [5/5] Создание конфигурации
Write-Step "[5/5] Настройка конфигурационного файла..."

$ConfigDir = Join-Path $env:USERPROFILE ".config\shell-gemini"
$ConfigFile = Join-Path $ConfigDir ".shell-gemini"

if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
    Write-Success "Создана директория конфигурации: $ConfigDir"
}

if (Test-Path $ConfigFile) {
    Write-Warning "Конфигурация уже существует, пропускаем..."
} else {
    $ConfigContent = @"
# ShellGemini Configuration
# Получите API ключ: https://aistudio.google.com/app/apikey

GEMINI_API=your_api_key_here
"@
    Set-Content -Path $ConfigFile -Value $ConfigContent -Encoding UTF8
    Write-Success "Создан шаблон конфига: $ConfigFile"
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✓ Установка завершена успешно!                          ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Следующие шаги:" -ForegroundColor Blue
Write-Host ""
Write-Host "1. Получите API ключ: " -NoNewline
Write-Host "https://aistudio.google.com/app/apikey" -ForegroundColor Yellow
Write-Host "2. Отредактируйте конфиг: " -NoNewline
Write-Host "notepad `"$ConfigFile`"" -ForegroundColor Green
Write-Host "3. Замените " -NoNewline
Write-Host "your_api_key_here" -ForegroundColor Yellow -NoNewline
Write-Host " на ваш реальный API ключ"
Write-Host "4. " -NoNewline
Write-Host "ПЕРЕЗАПУСТИТЕ ТЕРМИНАЛ" -ForegroundColor Red
Write-Host "5. Запустите: " -NoNewline
Write-Host "shell-gm `"Привет, Gemini!`"" -ForegroundColor Green
Write-Host ""
Write-Host "Полезные команды:" -ForegroundColor Blue
Write-Host "  shell-gm `"ваш запрос`"" -ForegroundColor Green -NoNewline
Write-Host "     - отправить запрос к Gemini"
Write-Host "  shell-gm -Help" -ForegroundColor Green -NoNewline
Write-Host "              - показать справку"
Write-Host ""
Write-Host "Примечание: Команда " -ForegroundColor Yellow -NoNewline
Write-Host "shell-gm" -ForegroundColor Green -NoNewline
Write-Host " доступна из любой директории после перезапуска терминала!" -ForegroundColor Yellow
Write-Host ""
