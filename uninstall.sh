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

REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(eval echo ~$REAL_USER)

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Удаление ShellGemini CLI                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Удаление исполняемого файла
echo -e "${YELLOW}[1/2]${NC} Удаление исполняемого файла..."
if [ -f "/usr/local/bin/shell-gm" ]; then
    rm /usr/local/bin/shell-gm
    echo -e "${GREEN}✓${NC} Удалён /usr/local/bin/shell-gm"
else
    echo -e "${YELLOW}⚠${NC}  Файл /usr/local/bin/shell-gm не найден"
fi

# Запрос на удаление конфигурации
echo -e "${YELLOW}[2/2]${NC} Удаление конфигурации..."
CONFIG_DIR="$REAL_HOME/.config/shell-gemini"

if [ -d "$CONFIG_DIR" ]; then
    read -p "Удалить конфигурацию ($CONFIG_DIR)? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[YyДд]$ ]]; then
        rm -rf "$CONFIG_DIR"
        echo -e "${GREEN}✓${NC} Конфигурация удалена"
    else
        echo -e "${YELLOW}⚠${NC}  Конфигурация сохранена в $CONFIG_DIR"
    fi
else
    echo -e "${YELLOW}⚠${NC}  Директория конфигурации не найдена"
fi

echo ""
echo -e "${GREEN}✓ Удаление завершено${NC}"
echo ""
