#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Проверка запуска с правами root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Ошибка:${NC} Этот скрипт должен быть запущен с правами root (используйте sudo)"
   exit 1
fi

# Получаем реального пользователя (если запущено через sudo)
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(eval echo ~$REAL_USER)

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Установка ShellGemini CLI                          ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Проверка зависимостей
echo -e "${YELLOW}[1/5]${NC} Проверка зависимостей..."
MISSING_DEPS=()

command -v curl >/dev/null 2>&1 || MISSING_DEPS+=("curl")
command -v jq >/dev/null 2>&1 || MISSING_DEPS+=("jq")
command -v bat >/dev/null 2>&1 || MISSING_DEPS+=("bat")

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}Ошибка:${NC} Не установлены необходимые зависимости: ${MISSING_DEPS[*]}"
    echo ""
    echo "Установите их с помощью:"
    echo -e "${GREEN}sudo pacman -S ${MISSING_DEPS[*]}${NC}  # Arch/Manjaro"
    echo -e "${GREEN}sudo apt install ${MISSING_DEPS[*]}${NC}  # Ubuntu/Debian"
    exit 1
fi
echo -e "${GREEN}✓${NC} Все зависимости установлены"

# Копирование скрипта в /usr/local/bin
echo -e "${YELLOW}[2/5]${NC} Установка исполняемого файла..."
if [ ! -f "src/shell-gm.sh" ]; then
    echo -e "${RED}Ошибка:${NC} Файл src/shell-gm.sh не найден в текущей директории"
    exit 1
fi

cp src/shell-gm.sh /usr/local/bin/shell-gm
chmod +x /usr/local/bin/shell-gm
echo -e "${GREEN}✓${NC} Скрипт установлен в /usr/local/bin/shell-gm"

# Создание директории конфигурации
echo -e "${YELLOW}[3/5]${NC} Создание директории конфигурации..."
CONFIG_DIR="$REAL_HOME/.config/shell-gemini"
CONFIG_FILE="$CONFIG_DIR/.shell-gemini"

mkdir -p "$CONFIG_DIR"
chown -R $REAL_USER:$REAL_USER "$CONFIG_DIR"
echo -e "${GREEN}✓${NC} Директория создана: $CONFIG_DIR"

# Создание шаблона конфига (если не существует)
echo -e "${YELLOW}[4/5]${NC} Настройка конфигурационного файла..."
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}⚠${NC}  Конфигурация уже существует, пропускаем..."
else
    echo "# ShellGemini Configuration" > "$CONFIG_FILE"
    echo "# Получите API ключ: https://aistudio.google.com/app/apikey" >> "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    echo "GEMINI_API=your_api_key_here" >> "$CONFIG_FILE"
    chown $REAL_USER:$REAL_USER "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
    echo -e "${GREEN}✓${NC} Создан шаблон конфига: $CONFIG_FILE"
fi

# Проверка наличия .env (для обратной совместимости)
echo -e "${YELLOW}[5/5]${NC} Проверка .env файла..."
if [ -f ".env" ]; then
    echo -e "${GREEN}✓${NC} Найден .env файл (проект будет использовать его для проверки)"
else
    echo -e "${YELLOW}⚠${NC}  .env файл не найден (создайте его по образцу .env.example если нужно)"
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Установка завершена успешно!                          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Следующие шаги:${NC}"
echo ""
echo -e "1. Получите API ключ: ${YELLOW}https://aistudio.google.com/app/apikey${NC}"
echo -e "2. Отредактируйте конфиг: ${GREEN}nano $CONFIG_FILE${NC}"
echo -e "3. Замените ${YELLOW}your_api_key_here${NC} на ваш реальный API ключ"
echo -e "4. Запустите: ${GREEN}shell-gm \"Привет, Gemini!\"${NC}"
echo ""
echo -e "${BLUE}Полезные команды:${NC}"
echo -e "  ${GREEN}shell-gm \"ваш запрос\"${NC}     - отправить запрос к Gemini"
echo -e "  ${GREEN}shell-gm --help${NC}            - показать справку"
echo ""
echo -e "${YELLOW}Примечание:${NC} Команда ${GREEN}shell-gm${NC} теперь доступна из любой директории!"
echo ""
