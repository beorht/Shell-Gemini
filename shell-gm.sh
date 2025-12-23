#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Функция для вывода ошибок
error() {
    echo -e "${RED}Ошибка:${NC} $1" >&2
    exit 1
} 

# Функция для вывода справки по команде
show_help() {
    cat << EOF
Использование: $0 "ваш запрос к Gemini"

  Примеры:
      $0 "Что такое Linux?"
      $0 "Напиши скрипт для бэкапа файлов"

  Опции:
      -h, --help    Показать эту справку

  Требования:
      - curl (для API запросов)
      - jq (для парсинга JSON)
      - .env файл с GEMINI_API ключом
EOF
    exit 0
}

# Проверка аргументов
if [[ $# -eq 0  ]]; then
    error "Не указан запрос. Используйте -h для справки"
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

PROMPT=$1

# Загрузка .env файла
if [[ ! -f .env ]]; then
    error "Файл .env не найден. Создайте его по образцу .env.example"
fi

source .env

if [[ -z "$GEMINI_API" ]]; then
    error "GEMINI_API не установлен в .env файле"
fi

# Проверка необходимых зависимостей
command -v curl >/dev/null 2>&1 || error "curl не установлен."
command -v jq >/dev/null 2>&1 || error "jq не установлен."

ESCAPED_PROMPT=$(echo "$PROMPT" | jq -Rs .)

echo -e "${YELLOW}Отправка запроса к Gemini...${NC}"

# API запрос
RESPONSE=$(curl -s -w "\n%{http_code}" \
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent" \
        -H 'Content-Type: application/json' \
        -H "x-goog-api-key: $GEMINI_API" \
        -d "{
            \"systemInstruction\": {
                \"parts\": [{
                    \"text\": \"Ты полезный ассистент командной строки. Давай краткие, точные и практичные ответы. Для кода используй markdown форматирование. Отвечай на русском языке, если запрос на русском.\"
                }]
            },
            \"contents\": [{
                \"parts\": [{
                    \"text\": $ESCAPED_PROMPT
                }]
            }]
        }")

# Разделям тело ответа и HTTP код
HTTP_BODY=$(echo "$RESPONSE" | head -n -1)
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

# Проверка статуса
if [[ "$HTTP_CODE" -ne 200 ]]; then
    echo -e "${RED}API вернул ошибку (HTTP $HTTP_CODE):${NC}"
    echo "$HTTP_BODY" | jq -r ".error.message // .error // ." 2>/dev/null || echo "$HTTP_BODY"
    exit 1
fi

# Извлечение текста
ANSWER=$(echo "$HTTP_BODY" | jq -r '.candidates[0].content.parts[0].text // empty')

if [[ -z "$ANSWER" ]]; then
    error "Не удалось получить ответ от API"
fi

# Вывод ответа
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     ${YELLOW} ██████╗ ███████╗███╗   ███╗██╗███╗   ██╗██╗${GREEN}        ║${NC}"
echo -e "${GREEN}║     ${YELLOW}██╔════╝ ██╔════╝████╗ ████║██║████╗  ██║██║${GREEN}        ║${NC}"
echo -e "${GREEN}║     ${YELLOW}██║  ███╗█████╗  ██╔████╔██║██║██╔██╗ ██║██║${GREEN}        ║${NC}"
echo -e "${GREEN}║     ${YELLOW}██║   ██║██╔══╝  ██║╚██╔╝██║██║██║╚██╗██║██║${GREEN}        ║${NC}"
echo -e "${GREEN}║     ${YELLOW}╚██████╔╝███████╗██║ ╚═╝ ██║██║██║ ╚████║██║${GREEN}        ║${NC}"
echo -e "${GREEN}║     ${YELLOW} ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝${GREEN}        ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "$ANSWER" | bat --style=plain --language=markdown --theme="OneHalfDark"
