# ShellGemini - PowerShell версия для Windows
# Автор: Shell-Gemini Project
# Лицензия: MIT

param(
    [Parameter(Position=0)]
    [string]$Prompt,

    [switch]$Help
)

# Функция для вывода ошибок
function Write-Error-Message {
    param([string]$Message)
    Write-Host "Ошибка: " -ForegroundColor Red -NoNewline
    Write-Host $Message
    exit 1
}

# Функция справки
function Show-Help {
    Write-Host @"
Использование: shell-gm "ваш запрос к Gemini"

  Примеры:
      shell-gm "Что такое Windows?"
      shell-gm "Напиши PowerShell скрипт для бэкапа файлов"

  Опции:
      -Help    Показать эту справку

  Требования:
      - PowerShell 5.1 или выше
      - Интернет соединение
      - Конфигурационный файл с GEMINI_API ключом
"@
    exit 0
}

# Проверка аргументов
if ($Help) {
    Show-Help
}

if (-not $Prompt) {
    Write-Error-Message "Не указан запрос. Используйте -Help для справки"
}

# Пути к конфигурации
$ConfigDir = Join-Path $env:USERPROFILE ".config\shell-gemini"
$ConfigFile = Join-Path $ConfigDir ".shell-gemini"
$LegacyEnvFile = ".env"

# Загрузка конфигурации
$ApiKey = $null

# Проверяем глобальный конфиг
if (Test-Path $ConfigFile) {
    Get-Content $ConfigFile | ForEach-Object {
        if ($_ -match '^GEMINI_API=(.+)$') {
            $ApiKey = $matches[1]
        }
    }
}

# Fallback на .env если глобальный конфиг не найден
if (-not $ApiKey -and (Test-Path $LegacyEnvFile)) {
    Get-Content $LegacyEnvFile | ForEach-Object {
        if ($_ -match '^GEMINI_API=(.+)$') {
            $ApiKey = $matches[1]
        }
    }
}

if (-not $ApiKey) {
    Write-Error-Message "GEMINI_API не установлен. Создайте файл конфигурации:`n  $ConfigFile`nили .env в текущей директории"
}

# Проверка версии PowerShell
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error-Message "Требуется PowerShell 5.1 или выше. Текущая версия: $($PSVersionTable.PSVersion)"
}

Write-Host "Отправка запроса к Gemini..." -ForegroundColor Yellow

# Подготовка JSON payload
$SystemInstruction = "Ты полезный ассистент командной строки. Давай краткие, точные и практичные ответы. Для кода используй markdown форматирование. Отвечай на русском языке, если запрос на русском."

$Body = @{
    systemInstruction = @{
        parts = @(
            @{
                text = $SystemInstruction
            }
        )
    }
    contents = @(
        @{
            parts = @(
                @{
                    text = $Prompt
                }
            )
        }
    )
} | ConvertTo-Json -Depth 10

# API запрос
try {
    $Response = Invoke-RestMethod `
        -Uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent" `
        -Method Post `
        -Headers @{
            "Content-Type" = "application/json"
            "x-goog-api-key" = $ApiKey
        } `
        -Body $Body `
        -ErrorAction Stop
} catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "API вернул ошибку (HTTP $StatusCode):" -ForegroundColor Red

    if ($_.ErrorDetails.Message) {
        $ErrorObj = $_.ErrorDetails.Message | ConvertFrom-Json
        Write-Host $ErrorObj.error.message
    } else {
        Write-Host $_.Exception.Message
    }
    exit 1
}

# Извлечение текста ответа
try {
    $Answer = $Response.candidates[0].content.parts[0].text
} catch {
    Write-Error-Message "Не удалось получить ответ от API"
}

if (-not $Answer) {
    Write-Error-Message "Пустой ответ от API"
}

# Вывод ASCII баннера
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║       " -ForegroundColor Green -NoNewline
Write-Host " ██████╗ ███████╗███╗   ███╗██╗███╗   ██╗██╗" -ForegroundColor Yellow -NoNewline
Write-Host "        ║" -ForegroundColor Green
Write-Host "║       " -ForegroundColor Green -NoNewline
Write-Host "██╔════╝ ██╔════╝████╗ ████║██║████╗  ██║██║" -ForegroundColor Yellow -NoNewline
Write-Host "        ║" -ForegroundColor Green
Write-Host "║       " -ForegroundColor Green -NoNewline
Write-Host "██║  ███╗█████╗  ██╔████╔██║██║██╔██╗ ██║██║" -ForegroundColor Yellow -NoNewline
Write-Host "        ║" -ForegroundColor Green
Write-Host "║       " -ForegroundColor Green -NoNewline
Write-Host "██║   ██║██╔══╝  ██║╚██╔╝██║██║██║╚██╗██║██║" -ForegroundColor Yellow -NoNewline
Write-Host "        ║" -ForegroundColor Green
Write-Host "║       " -ForegroundColor Green -NoNewline
Write-Host "╚██████╔╝███████╗██║ ╚═╝ ██║██║██║ ╚████║██║" -ForegroundColor Yellow -NoNewline
Write-Host "        ║" -ForegroundColor Green
Write-Host "║       " -ForegroundColor Green -NoNewline
Write-Host " ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝" -ForegroundColor Yellow -NoNewline
Write-Host "        ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# Вывод ответа с базовым markdown форматированием
# Простая обработка markdown для консоли
$Lines = $Answer -split "`n"
foreach ($Line in $Lines) {
    # Код блоки ```
    if ($Line -match '^```') {
        Write-Host $Line -ForegroundColor Cyan
    }
    # Заголовки
    elseif ($Line -match '^#+\s') {
        Write-Host $Line -ForegroundColor Yellow
    }
    # Списки
    elseif ($Line -match '^[\*\-]\s' -or $Line -match '^\d+\.\s') {
        Write-Host $Line -ForegroundColor White
    }
    # Обычный текст
    else {
        Write-Host $Line
    }
}

Write-Host ""
