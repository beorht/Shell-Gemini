# 🚀 ShellGemini

> Кроссплатформенная CLI утилита для взаимодействия с Google Gemini API из командной строки

ShellGemini - это легковесная CLI утилита, которая позволяет общаться с AI моделью Google Gemini прямо из терминала. Идеально подходит для быстрых вопросов, генерации кода, объяснения команд и решения задач без необходимости открывать браузер.

**Поддерживаемые платформы:**
- 🐧 **Linux** (bash) - зависимости: curl, jq, bat
- 🍎 **macOS** (bash) - зависимости: curl, jq, bat
- 🪟 **Windows** (PowerShell) - без внешних зависимостей, только PowerShell 5.1+

---

## ✨ Возможности

- 🎯 **Простота** - один скрипт, минимум зависимостей
- ⚡ **Быстро** - получайте ответы за секунды
- 🎨 **Красиво** - стильный ASCII баннер и подсветка синтаксиса кода
- 🔒 **Безопасно** - API ключ в конфиге, не хардкодится в скрипте
- 📝 **Markdown** - ответы с форматированием кода
- 🌍 **Кроссплатформенность** - работает на Linux, macOS и Windows
- 🛠️ **Настраиваемо** - возможность кастомизации системных промптов

---

## 📦 Установка

Выберите инструкцию для вашей операционной системы:

<details open>
<summary><b>🐧 Linux / 🍎 macOS</b></summary>

### Вариант 1: Автоматическая установка (рекомендуется)

```bash
# Клонировать репозиторий
git clone https://github.com/beorht/Shell-Gemini.git
cd Shell-Gemini

# Запустить скрипт установки
sudo bash install.sh
```

Скрипт автоматически:
- ✅ Проверит и установит зависимости (curl, jq, bat)
- ✅ Скопирует `shell-gm` в `/usr/local/bin` (доступно из любой директории)
- ✅ Создаст конфигурацию в `~/.config/shell-gemini/.shell-gemini`
- ✅ Настроит правильные права доступа

**После установки:**

1. Получите API ключ в [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Отредактируйте конфиг:
   ```bash
   nano ~/.config/shell-gemini/.shell-gemini
   ```
3. Замените `your_api_key_here` на ваш реальный API ключ
4. Готово! Запустите:
   ```bash
   shell-gm "Привет, Gemini!"
   ```

### Вариант 2: Ручная установка

**Шаг 1: Клонировать репозиторий**

```bash
git clone https://github.com/beorht/Shell-Gemini.git
cd Shell-Gemini
```

**Шаг 2: Установить зависимости**

```bash
# Arch/Manjaro
sudo pacman -S curl jq bat

# Ubuntu/Debian
sudo apt install curl jq bat

# macOS
brew install curl jq bat
```

**Зависимости:**
- `curl` - для HTTP запросов к API
- `jq` - для парсинга JSON ответов
- `bat` - для красивой подсветки markdown и кода

**Шаг 3: Настроить конфигурацию**

```bash
# Создать директорию конфига
mkdir -p ~/.config/shell-gemini

# Создать файл конфигурации
nano ~/.config/shell-gemini/.shell-gemini
```

Содержимое файла:
```bash
# ShellGemini Configuration
# Получите API ключ: https://aistudio.google.com/app/apikey

GEMINI_API=ваш_api_ключ_здесь
```

Установите правильные права:
```bash
chmod 600 ~/.config/shell-gemini/.shell-gemini
```

**Шаг 4: Сделать исполняемым и добавить в PATH**

```bash
chmod +x src/shell-gm.sh
sudo ln -s "$(pwd)/src/shell-gm.sh" /usr/local/bin/shell-gm
```

### Удаление

```bash
cd Shell-Gemini
sudo bash uninstall.sh
```

</details>

<details>
<summary><b>🪟 Windows</b></summary>

### Вариант 1: Автоматическая установка (рекомендуется)

**1. Скачайте репозиторий:**

```powershell
git clone https://github.com/beorht/Shell-Gemini.git
cd Shell-Gemini
```

**2. Запустите установщик от имени администратора:**

```powershell
# Щёлкните правой кнопкой на PowerShell и выберите "Запуск от имени администратора"
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install.ps1
```

Скрипт автоматически:
- ✅ Проверит версию PowerShell (требуется 5.1+)
- ✅ Установит `shell-gm.ps1` в `C:\Program Files\ShellGemini\`
- ✅ Создаст команду `shell-gm` доступную из любой директории
- ✅ Добавит в PATH системы
- ✅ Создаст конфиг в `%USERPROFILE%\.config\shell-gemini\.shell-gemini`

**3. Настройте API ключ:**

1. Получите бесплатный API ключ в [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Откройте конфиг:
   ```powershell
   notepad "$env:USERPROFILE\.config\shell-gemini\.shell-gemini"
   ```
3. Замените `your_api_key_here` на ваш реальный API ключ
4. Сохраните файл

**4. Перезапустите терминал и проверьте:**

```powershell
shell-gm "Привет, Gemini!"
```

### Вариант 2: Ручная установка

**1. Скачайте репозиторий:**

```powershell
git clone https://github.com/beorht/Shell-Gemini.git
cd Shell-Gemini
```

**2. Создайте конфигурацию:**

```powershell
# Создать директорию конфига
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\shell-gemini"

# Создать файл конфигурации
@"
# ShellGemini Configuration
# Получите API ключ: https://aistudio.google.com/app/apikey

GEMINI_API=ваш_api_ключ_здесь
"@ | Out-File -FilePath "$env:USERPROFILE\.config\shell-gemini\.shell-gemini" -Encoding UTF8
```

**3. Отредактируйте конфиг:**

```powershell
notepad "$env:USERPROFILE\.config\shell-gemini\.shell-gemini"
```

**4. Запускайте напрямую:**

```powershell
cd src
.\shell-gm.ps1 "ваш запрос"
```

**Опционально: Создайте алиас:**

Добавьте в ваш PowerShell профиль (`notepad $PROFILE`):

```powershell
function shell-gm {
    param([string]$prompt)
    & "C:\путь\к\Shell-Gemini\src\shell-gm.ps1" $prompt
}
```

### Удаление

```powershell
# Запустить от имени администратора
.\uninstall.ps1
```

</details>

---

## 🎯 Использование

### Базовое использование

<details open>
<summary><b>🐧 Linux / 🍎 macOS</b></summary>

**После установки через install.sh:**
```bash
shell-gm "ваш вопрос к Gemini"
```

**При ручном запуске (без установки):**
```bash
cd src
./shell-gm.sh "ваш вопрос к Gemini"
```

</details>

<details>
<summary><b>🪟 Windows</b></summary>

**После установки:**
```powershell
shell-gm "ваш вопрос к Gemini"
```

**При ручном запуске (без установки):**
```powershell
cd src
.\shell-gm.ps1 "ваш вопрос к Gemini"
```

</details>

---

При запросе вы увидите красивый ASCII баннер:

```
╔═══════════════════════════════════════════════════════════╗
║      ██████╗ ███████╗███╗   ███╗██╗███╗   ██╗██╗        ║
║     ██╔════╝ ██╔════╝████╗ ████║██║████╗  ██║██║        ║
║     ██║  ███╗█████╗  ██╔████╔██║██║██╔██╗ ██║██║        ║
║     ██║   ██║██╔══╝  ██║╚██╔╝██║██║██║╚██╗██║██║        ║
║     ╚██████╔╝███████╗██║ ╚═╝ ██║██║██║ ╚████║██║        ║
║      ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝        ║
╚═══════════════════════════════════════════════════════════╝
```

### Примеры

**Простой вопрос:**
```bash
shell-gm "Что такое Linux?"
```

**Генерация кода:**
```bash
shell-gm "Напиши bash скрипт для создания бэкапа директории /home"
```

**Объяснение команды:**
```bash
shell-gm "Объясни что делает: find . -name '*.log' -mtime +7 -delete"
```

**Отладка ошибок:**
```bash
shell-gm "Как исправить ошибку: Permission denied"
```

**Помощь с Git:**
```bash
shell-gm "Как откатить последний коммит в Git?"
```

**Конвертация форматов:**
```bash
shell-gm "Преобразуй JSON в YAML: {\"name\": \"test\", \"value\": 123}"
```

**Помощь с кодом:**
```bash
shell-gm "Напиши функцию на Python для сортировки списка словарей по ключу"
```

### Справка

<details open>
<summary><b>🐧 Linux / 🍎 macOS</b></summary>

```bash
shell-gm --help
# или
shell-gm -h
```

</details>

<details>
<summary><b>🪟 Windows</b></summary>

```powershell
shell-gm -Help
```

</details>

---

## 📂 Структура проекта

```
shellgemini/
├── src/
│   ├── shell-gm.sh      # Linux/macOS версия (bash)
│   └── shell-gm.ps1     # Windows версия (PowerShell)
├── install.sh           # Установщик Linux/macOS
├── install.ps1          # Установщик Windows
├── uninstall.sh         # Деинсталлятор Linux/macOS
├── uninstall.ps1        # Деинсталлятор Windows
├── .env.example         # Шаблон конфигурации
├── .gitignore           # Игнорируемые файлы
├── README.md            # Документация (этот файл)
├── TODO.md              # Планируемые улучшения
└── CLAUDE.md            # Инструкции для Claude Code AI
├── README.md            # Документация (этот файл)
├── TODO.md              # Планируемые улучшения
└── CLAUDE.md            # Инструкции для Claude Code AI
```

**После установки:**

<details open>
<summary><b>🐧 Linux / 🍎 macOS</b></summary>

```
/usr/local/bin/
└── shell-gm             # Установленный исполняемый файл

~/.config/shell-gemini/
└── .shell-gemini        # Основной конфиг с API ключом
```

</details>

<details>
<summary><b>🪟 Windows</b></summary>

```
C:\Program Files\ShellGemini\
├── shell-gm.ps1         # PowerShell скрипт
└── shell-gm.bat         # Wrapper для удобного запуска

%USERPROFILE%\.config\shell-gemini\
└── .shell-gemini        # Основной конфиг с API ключом
```

</details>

---

## 🔧 Troubleshooting

### Общие проблемы

<details>
<summary><b>Ошибка: "API вернул ошибку (HTTP 400)"</b></summary>

**Возможные причины:**
- Неправильный API ключ
- Истек срок действия ключа
- Невалидный формат запроса

**Решение:**
1. Проверьте правильность ключа в конфиге
2. Создайте новый ключ в [Google AI Studio](https://aistudio.google.com/app/apikey)
3. Убедитесь, что переменная `GEMINI_API` установлена корректно

**Linux/macOS:**
```bash
nano ~/.config/shell-gemini/.shell-gemini
```

**Windows:**
```powershell
notepad "$env:USERPROFILE\.config\shell-gemini\.shell-gemini"
```

</details>

<details>
<summary><b>Ошибка: "Quota exceeded" (HTTP 429)</b></summary>

**Причина:** Превышен лимит бесплатных запросов

**Бесплатные лимиты Gemini 2.5 Flash:**
- 15 запросов в минуту
- 1,500 запросов в день
- 1 миллион токенов в день

**Решения:**
1. Подождите несколько минут перед следующим запросом
2. Проверьте квоту: https://ai.dev/usage?tab=rate-limit
3. Перейдите на платный план в Google Cloud Console
4. Используйте несколько API ключей с ротацией

</details>

### Проблемы Linux/macOS

<details>
<summary><b>Ошибка: "curl не установлен" или "jq не установлен"</b></summary>

**Решение:**
```bash
# Arch/Manjaro
sudo pacman -S curl jq bat

# Ubuntu/Debian
sudo apt install curl jq bat

# macOS
brew install curl jq bat
```

</details>

<details>
<summary><b>Ошибка: "Файл конфигурации не найден"</b></summary>

**Решение (если установлено через install.sh):**
```bash
nano ~/.config/shell-gemini/.shell-gemini  # Проверьте API ключ здесь
```

**Решение (если ручная установка):**
```bash
cp .env.example ~/.config/shell-gemini/.shell-gemini
nano ~/.config/shell-gemini/.shell-gemini  # добавьте ваш API ключ
chmod 600 ~/.config/shell-gemini/.shell-gemini
```

</details>

<details>
<summary><b>bat показывает слишком много пробелов</b></summary>

**Решение:** Скрипт уже использует `bat --style=plain` для компактного вывода.

Если нужен еще более компактный вывод без подсветки, замените строку 112 в `src/shell-gm.sh`:
```bash
echo "$ANSWER"  # Вместо bat
```

</details>

### Проблемы Windows

<details>
<summary><b>Ошибка: "Не удается загрузить файл, выполнение скриптов отключено"</b></summary>

**Причина:** PowerShell блокирует выполнение скриптов по умолчанию

**Решение:**
```powershell
# Временно для текущей сессии
Set-ExecutionPolicy Bypass -Scope Process

# Или постоянно для текущего пользователя
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

</details>

<details>
<summary><b>Команда shell-gm не найдена после установки</b></summary>

**Решение:**
1. **Перезапустите терминал** (обязательно!)
2. Проверьте PATH:
   ```powershell
   $env:Path -split ';' | Select-String "ShellGemini"
   ```
3. Если не найдено, переустановите:
   ```powershell
   .\install.ps1
   ```

</details>

---

## 🔒 Безопасность

### ⚠️ ВАЖНО: Защита API ключа

**Для всех платформ:**

1. **Никогда не коммитьте конфиг с ключом в git**
    - Конфиг `.shell-gemini` находится вне репозитория
    - Файл `.env.example` в `.gitignore` как мера предосторожности

2. **Проверьте права доступа к конфигу:**

   **Linux/macOS:**
   ```bash
   chmod 600 ~/.config/shell-gemini/.shell-gemini
   ls -la ~/.config/shell-gemini/.shell-gemini
   # Должно быть: -rw------- (только владелец может читать/писать)
   ```

   **Windows:**
   - Windows автоматически ограничивает доступ к файлам в профиле пользователя

3. **Ротация ключей:**
   - Периодически создавайте новые ключи
   - Удаляйте старые в [Google AI Studio](https://aistudio.google.com/app/apikey)

4. **Если ключ скомпрометирован:**
   - Немедленно удалите ключ в Google AI Studio
   - Создайте новый ключ
   - Обновите конфиг

---

## 🚀 Продвинутое использование

### Использование в скриптах

<details open>
<summary><b>🐧 Linux / 🍎 macOS</b></summary>

```bash
#!/bin/bash

# Получить ответ и сохранить в переменную (без баннера)
ANSWER=$(shell-gm "Что такое Docker?" 2>/dev/null | tail -n +9)

echo "Gemini ответил: $ANSWER"
```

</details>

<details>
<summary><b>🪟 Windows</b></summary>

```powershell
# Получить ответ и сохранить в переменную
$Answer = shell-gm "Что такое Docker?"

Write-Host "Gemini ответил: $Answer"
```

</details>

### Создание алиасов

<details open>
<summary><b>🐧 Linux / 🍎 macOS</b></summary>

Добавьте в `~/.bashrc` или `~/.zshrc`:

```bash
# Если установлено через install.sh, команда shell-gm уже доступна глобально
# Можно создать короткие алиасы:

# Базовый алиас
alias ask='shell-gm'

# Специализированные алиасы
alias explain='shell-gm "Объясни команду: "'
alias code='shell-gm "Напиши код для: "'
alias debug='shell-gm "Как исправить ошибку: "'
alias translate='shell-gm "Переведи на русский: "'
```

Затем перезагрузите конфигурацию:
```bash
source ~/.bashrc  # или source ~/.zshrc
```

Теперь можно использовать:
```bash
ask "Что такое Kubernetes?"
explain "docker-compose up -d"
code "парсинг JSON в Python"
debug "TypeError: unsupported operand type"
translate "Hello, how are you?"
```

</details>

<details>
<summary><b>🪟 Windows</b></summary>

Добавьте в PowerShell профиль (`notepad $PROFILE`):

```powershell
# Короткие алиасы
function ask { shell-gm $args }
function explain { shell-gm "Объясни команду: $args" }
function code { shell-gm "Напиши код для: $args" }
function debug { shell-gm "Как исправить ошибку: $args" }
```

После перезапуска терминала:
```powershell
ask "Что такое Kubernetes?"
explain "Get-Process | Sort-Object CPU -Descending"
code "парсинг JSON в PowerShell"
debug "UnauthorizedAccessException"
```

</details>

---

## 📊 Технические детали

### Используемая модель

**По умолчанию:** `gemini-2.5-flash`
- ✅ Новейшая модель
- ✅ Быстрая
- ✅ Бесплатная (щедрые лимиты)
- ✅ Улучшенная точность
- ✅ Поддержка 1M контекста

### Другие доступные модели

Чтобы сменить модель, отредактируйте строку 67 в соответствующем скрипте:

**Linux/macOS:** `src/shell-gm.sh` (или `/usr/local/bin/shell-gm` после установки)
**Windows:** `src/shell-gm.ps1` (или `C:\Program Files\ShellGemini\shell-gm.ps1` после установки)

```bash
"https://generativelanguage.googleapis.com/v1beta/models/НАЗВАНИЕ_МОДЕЛИ:generateContent"
```

Доступные модели:
- `gemini-2.5-flash` - новейшая, рекомендуется (по умолчанию)
- `gemini-1.5-flash` - предыдущая версия, стабильная
- `gemini-1.5-pro` - более умная, но медленнее и с меньшими лимитами
- `gemini-2.0-flash-exp` - экспериментальная, очень низкие лимиты

### Лимиты API (бесплатный tier)

| Параметр | Gemini 2.5 Flash |
|----------|------------------|
| Запросов в минуту | 15 |
| Запросов в день | 1,500 |
| Токенов в день | 1,000,000 |
| Максимальная длина запроса | 32,000 токенов |
| Максимальная длина ответа | 8,192 токена |

### Сравнение версий

| Особенность | Linux/macOS (bash) | Windows (PowerShell) |
|-------------|-------------------|---------------------|
| **Зависимости** | curl, jq, bat | Только PowerShell 5.1+ |
| **JSON парсинг** | jq (внешняя утилита) | Встроенный `ConvertFrom-Json` |
| **Markdown рендеринг** | bat (внешняя утилита) | Встроенная подсветка |
| **Конфиг** | `~/.config/shell-gemini/` | `%USERPROFILE%\.config\shell-gemini\` |
| **Установка** | `/usr/local/bin/` | `C:\Program Files\ShellGemini\` |
| **Размер скрипта** | 4.7 KB | 6.9 KB |

---

## 🤝 Вклад в проект

Хотите помочь улучшить ShellGemini?

1. Fork репозитория
2. Создайте feature ветку: `git checkout -b feature/amazing-feature`
3. Сделайте изменения и коммит
4. Push в ветку: `git push origin feature/amazing-feature`
5. Откройте Pull Request

### Идеи для вклада

Смотрите [TODO.md](TODO.md) для списка планируемых улучшений, включая:
- Системные промпты для разных сценариев
- История запросов
- Интерактивный chat-режим
- Поддержка других LLM (OpenAI, Claude, Ollama)
- Web UI
- И многое другое...

---

## 📜 Лицензия

MIT License - свободное использование для любых целей.

---

## 🔗 Полезные ссылки

- [GitHub репозиторий](https://github.com/beorht/Shell-Gemini)
- [Google AI Studio](https://aistudio.google.com/) - получить API ключ
- [Gemini API Documentation](https://ai.google.dev/gemini-api/docs) - документация API
- [Проверка квоты](https://ai.dev/usage?tab=rate-limit) - мониторинг использования
- [bat](https://github.com/sharkdp/bat) - утилита для подсветки синтаксиса (Linux/macOS)
- [PowerShell Documentation](https://docs.microsoft.com/powershell/) - документация PowerShell (Windows)

---

## ❓ FAQ

**Q: Это бесплатно?**
A: Да! Google Gemini API имеет щедрый бесплатный tier (1,500 запросов/день).

**Q: Работает без интернета?**
A: Нет, требуется подключение к Gemini API. Поддержка локальных моделей (Ollama) планируется.

**Q: Поддерживает ли изображения/мультимодальность?**
A: Пока нет, но это в планах (см. TODO.md).

**Q: Сохраняется ли история запросов?**
A: Пока нет, каждый запрос независимый. История и chat-режим в разработке.

**Q: Можно ли использовать другие LLM?**
A: Пока только Gemini. Поддержка OpenAI, Claude, Ollama планируется.

**Q: Безопасно ли отправлять конфиденциальные данные?**
A: Читайте [Privacy Policy Google](https://policies.google.com/privacy). Не отправляйте секреты, пароли, персональные данные.

**Q: Почему две версии (bash и PowerShell)?**
A: Для оптимального опыта на каждой платформе. Bash версия использует нативные Unix-утилиты, PowerShell версия - встроенные возможности Windows.

---

## 💬 Поддержка

Если у вас проблемы или вопросы:

1. Проверьте раздел [Troubleshooting](#-troubleshooting)
2. Посмотрите [Issues на GitHub](https://github.com/beorht/Shell-Gemini/issues)
3. Создайте новый issue с подробным описанием проблемы

---

**Сделано с ❤️ для Linux, macOS и Windows сообществ**

*Последнее обновление: 2025-12-24*
