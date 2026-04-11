#!/bin/bash
# Фабрика Контента Lite — Установщик v3.1
# 1 агент + 5 скиллов для участников AI Club
# НЕ используем set -e — все ошибки обрабатываем явно

# === Цвета ===
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"
GREEN="\033[32m"
CYAN="\033[36m"
RED="\033[31m"
YELLOW="\033[33m"
GOLD="\033[33;1m"
CHECK="${GREEN}✓${RESET}"
CROSS="${RED}✗${RESET}"
ARROW="${CYAN}→${RESET}"

# ============================================================
#  ЛИЦЕНЗИОННАЯ ПРОВЕРКА (InvestClub)
#  Этот установщик предназначен только для участников клуба.
#  Lite-лицензию выдаёт бот @investhimiak_bot после проверки членства.
# ============================================================

GATE_VERIFY_URL="${GATE_VERIFY_URL:-http://humsterclub.duckdns.org/gate/verify}"
LICENSE_FILE="$HOME/.openclaw/.aiclub-license"

LICENSE_KEY="${AICLUB_LICENSE_KEY:-}"
if [ -z "$LICENSE_KEY" ] && [ -f "$LICENSE_FILE" ]; then
  LICENSE_KEY=$(cat "$LICENSE_FILE" 2>/dev/null | tr -d '[:space:]')
fi

if [ -z "$LICENSE_KEY" ]; then
  echo ""
  echo -e "  ${RED}❌ Лицензионный ключ не найден${RESET}"
  echo ""
  echo -e "  Этот установщик предназначен только для участников ${BOLD}клуба InvestClub${RESET}."
  echo ""
  echo -e "  ${BOLD}Получи персональный ключ Lite:${RESET}"
  echo -e "    1. Открой бота ${CYAN}@investhimiak_bot${RESET} в Telegram"
  echo -e "    2. Напиши команду ${CYAN}/install${RESET}"
  echo -e "    3. Бот проверит твоё членство в группе и пришлёт готовую команду установки"
  echo ""
  echo -e "  ${DIM}Документация: https://humster.club/aiclub/1agent/install-1agent.html${RESET}"
  echo ""
  exit 1
fi

echo ""
echo -e "  ${ARROW} Проверяю лицензию Lite..."
RESULT=$(curl -sf --max-time 10 "${GATE_VERIFY_URL}?key=${LICENSE_KEY}" 2>/dev/null || echo "")

if echo "$RESULT" | grep -q '"valid":true'; then
  MEMBER=$(echo "$RESULT" | sed -n 's/.*"member":"\([^"]*\)".*/\1/p')
  echo -e "  ${CHECK} Лицензия активна (участник: ${BOLD}${MEMBER:-unknown}${RESET})"
elif echo "$RESULT" | grep -q '"valid":false'; then
  REASON=$(echo "$RESULT" | sed -n 's/.*"reason":"\([^"]*\)".*/\1/p')
  echo -e "  ${CROSS} Лицензия не действительна (${REASON:-unknown})"
  echo ""
  echo -e "  Возможно, ты вышел из группы клуба. Получи новый ключ:"
  echo -e "  → @investhimiak_bot → /install"
  echo ""
  exit 1
else
  echo -e "  ${CROSS} Не удалось связаться с gate-сервером ($GATE_VERIFY_URL)"
  echo -e "  Проверь интернет и повтори установку."
  exit 1
fi
echo ""

# ============================================================
#  ОРИГИНАЛЬНЫЙ УСТАНОВЩИК
# ============================================================

clear 2>/dev/null || true
echo ""
echo -e "  ${BOLD}${CYAN}🏭 Фабрика Контента Lite${RESET}"
echo -e "  ${BOLD}One-Command Installer v3.1${RESET}"
echo -e "  ${BOLD}1 агент · 5 скиллов · быстрый старт${RESET}"
echo -e "  ═══════════════════════════════════════"
echo ""

# =============================================
# Шаг 1 из 6 — Проверка системы
# =============================================
echo -e "${BOLD}Шаг 1 из 6${RESET} ${DIM}— Проверка системы${RESET}"
echo ""

MISSING=""
command -v curl &>/dev/null || MISSING="$MISSING curl"
command -v tar &>/dev/null || MISSING="$MISSING tar"

if command -v git &>/dev/null; then
  HAS_GIT=true
else
  HAS_GIT=false
  MISSING="$MISSING git"
fi

if command -v node &>/dev/null; then
  HAS_NODE=true
else
  HAS_NODE=false
  MISSING="$MISSING nodejs"
fi

if command -v openclaw &>/dev/null; then
  OC_VER=$(openclaw --version 2>/dev/null | head -1)
  HAS_OPENCLAW=true
else
  HAS_OPENCLAW=false
fi

if [ -n "$MISSING" ]; then
  echo -e "  ${YELLOW}⚠ Не хватает:${RESET}${MISSING}"
  if [ "$HAS_OPENCLAW" = false ]; then
    echo ""
    echo -e "  ${BOLD}Сначала установи OpenClaw:${RESET}"
    echo -e "  ${CYAN}curl -fsSL https://openclaw.ai/install.sh | bash${RESET}"
  fi
  for dep in $MISSING; do
    case "$dep" in
      git) echo -e "  ${CYAN}sudo apt install -y git${RESET}" ;;
      curl) echo -e "  ${CYAN}sudo apt install -y curl${RESET}" ;;
      tar) echo -e "  ${CYAN}sudo apt install -y tar${RESET}" ;;
      nodejs) echo -e "  ${CYAN}curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && sudo apt install -y nodejs${RESET}" ;;
    esac
  done
  exit 1
fi

if [ "$HAS_OPENCLAW" = true ]; then
  echo -e "  ${CHECK} OpenClaw: ${DIM}${OC_VER}${RESET}"
else
  echo -e "  ${CROSS} OpenClaw не установлен"
  echo ""
  echo -e "  Фабрика Контента работает на платформе ${BOLD}OpenClaw${RESET}."
  echo -e "  Сначала нужно установить OpenClaw, потом запустить этот установщик."
  echo ""
  echo -e "  ${BOLD}Как установить:${RESET}"
  echo -e "  ${CYAN}curl -fsSL https://openclaw.ai/install.sh | bash${RESET}"
  echo ""
  echo -e "  После установки запусти ${CYAN}openclaw onboard${RESET}, затем повтори установку."
  exit 1
fi

# =============================================
# Шаг 2 из 6 — Скачивание и установка
# =============================================
echo ""
echo -e "${BOLD}Шаг 2 из 6${RESET} ${DIM}— Скачивание и установка${RESET}"
echo ""

# --- Выбор папки ---
GUIDE_WS="$HOME/openclaw-factory"

echo -e "  Папка установки:"
echo ""
echo -e "    ${CYAN}1${RESET}) 📁 ${BOLD}${GUIDE_WS}${RESET} ${GREEN}(рекомендуется)${RESET}"
if [ -d "$GUIDE_WS" ]; then
  echo -e "       ${DIM}Папка уже существует${RESET}"
fi
echo -e "    ${CYAN}2${RESET}) ✏️  Указать путь вручную"
echo ""
echo -e "  ${DIM}Enter = вариант 1${RESET}"
echo ""

read -p "  Выбор (1-2): " DIR_CHOICE < /dev/tty
[ -z "$DIR_CHOICE" ] && DIR_CHOICE=1

if [ "$DIR_CHOICE" = "2" ]; then
  read -p "  Полный путь: " CUSTOM_DIR < /dev/tty
  if [ -z "$CUSTOM_DIR" ]; then
    echo -e "  ${CROSS} Путь не указан"
    exit 1
  fi
  INSTALL_DIR="${CUSTOM_DIR/#\~/$HOME}"
else
  INSTALL_DIR="$GUIDE_WS"
fi

# Если папка уже существует — спрашиваем
if [ -d "$INSTALL_DIR" ] && [ "$(ls -A "$INSTALL_DIR" 2>/dev/null)" ]; then
  echo ""
  echo -e "  ${YELLOW}⚠${RESET} Папка ${BOLD}${INSTALL_DIR}${RESET} уже существует"
  echo ""
  echo -e "    ${CYAN}1${RESET}) Перезаписать (скиллы обновятся, проекты сохранятся)"
  echo -e "    ${CYAN}2${RESET}) Выбрать другую папку"
  echo -e "    ${CYAN}3${RESET}) Отмена"
  echo ""
  read -p "  Вариант (1/2/3): " OVERWRITE_CHOICE < /dev/tty
  case "$OVERWRITE_CHOICE" in
    1)
      echo -e "  ${CHECK} Обновляю в ${INSTALL_DIR}"
      ;;
    2)
      read -p "  Полный путь: " CUSTOM_DIR < /dev/tty
      INSTALL_DIR="${CUSTOM_DIR/#\~/$HOME}"
      ;;
    *)
      echo "  Отменено."
      exit 0
      ;;
  esac
fi

mkdir -p "$INSTALL_DIR"
echo -e "  ${CHECK} Папка готова"

# --- Скачиваем с GitHub ---
echo ""
echo -ne "  Скачиваю Фабрику Lite... "

TMPDIR=$(mktemp -d)

if $HAS_GIT; then
  git clone --depth 1 https://github.com/Dimks777/aiclublight.git "$TMPDIR/factory" 2>/dev/null
else
  curl -sfL https://github.com/Dimks777/aiclublight/archive/main.tar.gz -o "$TMPDIR/factory.tar.gz"
  tar xzf "$TMPDIR/factory.tar.gz" -C "$TMPDIR" 2>/dev/null
  mv "$TMPDIR/aiclublight-main" "$TMPDIR/factory" 2>/dev/null || true
fi

if [ ! -d "$TMPDIR/factory" ]; then
  echo -e "${RED}ошибка скачивания${RESET}"
  rm -rf "$TMPDIR"
  exit 1
fi
echo -e "${CHECK}"

# --- Установка скиллов ---
echo -ne "  Устанавливаю скиллы... "
SKILLS_TARGET="$HOME/.openclaw/skills"
mkdir -p "$SKILLS_TARGET"

if [ -d "$TMPDIR/factory/skills" ]; then
  for skill_dir in "$TMPDIR/factory/skills"/*/; do
    [ ! -d "$skill_dir" ] && continue
    skill=$(basename "$skill_dir")
    mkdir -p "$SKILLS_TARGET/$skill"
    cp -r "$skill_dir"/* "$SKILLS_TARGET/$skill/" 2>/dev/null || true
  done
fi

SKILL_COUNT=$(ls -d "$SKILLS_TARGET"/*/ 2>/dev/null | wc -l | tr -d ' ')
echo -e "${CHECK} (${SKILL_COUNT} скиллов)"

# --- Установка агента ---
echo -ne "  Устанавливаю агента... "
AGENT_DIR="$INSTALL_DIR"

# SOUL.md — обновляем
if [ -f "$TMPDIR/factory/factory/agents/coordinator/SOUL.md" ]; then
  cp "$TMPDIR/factory/factory/agents/coordinator/SOUL.md" "$INSTALL_DIR/SOUL.md" 2>/dev/null
fi

# Остальные файлы агента — только если не существуют
for f in AGENTS.md BOOTSTRAP.md HEARTBEAT.md IDENTITY.md MEMORY.md USER.md TOOLS.md; do
  if [ ! -f "$INSTALL_DIR/$f" ] && [ -f "$TMPDIR/factory/factory/agents/coordinator/$f" ]; then
    cp "$TMPDIR/factory/factory/agents/coordinator/$f" "$INSTALL_DIR/$f"
  fi
done

# Директории
mkdir -p "$INSTALL_DIR/memory" "$INSTALL_DIR/learning" "$INSTALL_DIR/projects"

[ ! -f "$INSTALL_DIR/memory/active-context.md" ] && printf "# Active Context\n\n## Last task\n(none yet)\n" > "$INSTALL_DIR/memory/active-context.md"
[ ! -f "$INSTALL_DIR/learning/patterns.md" ] && echo "# Patterns" > "$INSTALL_DIR/learning/patterns.md"
[ ! -f "$INSTALL_DIR/learning/anti-patterns.md" ] && echo "# Anti-patterns" > "$INSTALL_DIR/learning/anti-patterns.md"
[ ! -f "$INSTALL_DIR/learning/corrections.md" ] && echo "# Corrections" > "$INSTALL_DIR/learning/corrections.md"

echo -e "${CHECK} (coordinator)"

# Карта скиллов
SKILLS_MAP_FILE="$INSTALL_DIR/SKILLS-MAP.md"
{
  echo "# Карта скиллов"
  echo ""
  echo "Автоматически сгенерировано установщиком $(date +%Y-%m-%d)"
  echo ""
  echo "| Скилл | Описание |"
  echo "|-------|----------|"
  for skill_dir in "$SKILLS_TARGET"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    if [ -f "$skill_file" ]; then
      desc=$(grep -m1 '^description:' "$skill_file" 2>/dev/null | sed 's/^description: *//' | cut -c1-80)
      [ -z "$desc" ] && desc="—"
      echo "| $skill_name | $desc |"
    fi
  done
} > "$SKILLS_MAP_FILE" 2>/dev/null

rm -rf "$TMPDIR"

echo -e "  ${CHECK} Скиллы и агент установлены"

# =============================================
# Шаг 3 из 6 — Подключение модели
# =============================================
echo ""
echo -e "${BOLD}Шаг 3 из 6${RESET} ${DIM}— Подключение модели${RESET}"
echo ""

OC_CONFIG="$HOME/.openclaw/openclaw.json"
HAS_AUTH=false
DETECTED_PROVIDER=""

if [ -f "$OC_CONFIG" ]; then
  grep -q '"ANTHROPIC_API_KEY"' "$OC_CONFIG" 2>/dev/null && HAS_AUTH=true && DETECTED_PROVIDER="Anthropic"
  grep -q '"OPENAI_API_KEY"' "$OC_CONFIG" 2>/dev/null && HAS_AUTH=true && DETECTED_PROVIDER="OpenAI"
  grep -q '"OPENROUTER_API_KEY"' "$OC_CONFIG" 2>/dev/null && HAS_AUTH=true && DETECTED_PROVIDER="OpenRouter"
fi

if [ -f "$HOME/.openclaw/agents/default/agent/auth-profiles.json" ]; then
  if grep -q "anthropic" "$HOME/.openclaw/agents/default/agent/auth-profiles.json" 2>/dev/null; then
    HAS_AUTH=true
    DETECTED_PROVIDER="Claude (подписка)"
  fi
fi

if [ "$HAS_AUTH" = true ]; then
  echo -e "  ${CHECK} Модель уже подключена${DETECTED_PROVIDER:+ ($DETECTED_PROVIDER)}"
else
  echo -e "  ${YELLOW}⚠${RESET}  ${BOLD}Важно:${RESET} архитектура Фабрики выстроена под модели Claude."
  echo -e "     Все скиллы и промпты оптимизированы под Claude."
  echo -e "     Другие модели могут дать совершенно другой результат."
  echo ""
  echo -e "  Выбери провайдер модели:"
  echo ""
  echo -e "    ${CYAN}1${RESET}) ${BOLD}Claude подписка${RESET} ${GREEN}(рекомендовано)${RESET}"
  echo -e "       Если есть подписка Pro (\$20) или Max (\$100/\$200)."
  echo ""
  echo -e "    ${CYAN}2${RESET}) ${BOLD}Anthropic API ключ${RESET}"
  echo -e "       console.anthropic.com — оплата за использование."
  echo ""
  echo -e "    ${CYAN}3${RESET}) ${BOLD}OpenAI API ключ${RESET} ${YELLOW}(результат может отличаться)${RESET}"
  echo -e "       platform.openai.com — GPT-4.1 и другие модели."
  echo ""
  echo -e "    ${CYAN}4${RESET}) ${BOLD}OpenRouter API ключ${RESET} ${YELLOW}(результат может отличаться)${RESET}"
  echo -e "       openrouter.ai — доступ к 200+ моделям через один ключ."
  echo ""
  echo -e "    ${CYAN}5${RESET}) ${DIM}Пропустить (настрою позже)${RESET}"
  echo ""

  read -p "  Выбор (1-5): " AUTH_CHOICE < /dev/tty

  write_api_key() {
    local KEY_NAME="$1"
    local KEY_VALUE="$2"
    local MODEL_ID="$3"

    mkdir -p "$HOME/.openclaw"
    if [ -f "$OC_CONFIG" ]; then
      if command -v node &>/dev/null; then
        node -e "
          const fs = require('fs');
          const cfg = JSON.parse(fs.readFileSync('$OC_CONFIG', 'utf8'));
          if (!cfg.env) cfg.env = {};
          if (!cfg.env.vars) cfg.env.vars = {};
          cfg.env.vars['$KEY_NAME'] = '$KEY_VALUE';
          if ('$MODEL_ID') cfg.default_model = '$MODEL_ID';
          fs.writeFileSync('$OC_CONFIG', JSON.stringify(cfg, null, 2));
        " 2>/dev/null && return 0
      elif command -v python3 &>/dev/null; then
        python3 -c "
import json, os
p = os.path.expanduser('$OC_CONFIG')
with open(p) as f: cfg = json.load(f)
cfg.setdefault('env', {}).setdefault('vars', {})['$KEY_NAME'] = '$KEY_VALUE'
model = '$MODEL_ID'
if model: cfg['default_model'] = model
with open(p, 'w') as f: json.dump(cfg, f, indent=2)
        " 2>/dev/null && return 0
      fi
    else
      if command -v node &>/dev/null; then
        node -e "
          const fs = require('fs');
          const cfg = { env: { vars: { '$KEY_NAME': '$KEY_VALUE' } } };
          if ('$MODEL_ID') cfg.default_model = '$MODEL_ID';
          fs.writeFileSync('$OC_CONFIG', JSON.stringify(cfg, null, 2));
        " 2>/dev/null && return 0
      fi
    fi
    return 1
  }

  case $AUTH_CHOICE in
    1)
      echo ""
      echo -e "  ${BOLD}Подключение через подписку Claude${RESET}"
      echo ""
      HAS_CLAUDE_CLI=false
      command -v claude &>/dev/null && HAS_CLAUDE_CLI=true
      if [ "$HAS_CLAUDE_CLI" = true ]; then
        echo -e "  ${CHECK} Claude Code CLI обнаружен."
        echo ""
        echo -e "  Выполни в ${BOLD}отдельном терминале${RESET}:"
        echo -e "    ${CYAN}claude setup-token${RESET}"
        echo -e "  Скопируй полученный токен и вставь сюда."
      else
        echo -e "  Для получения токена нужен Claude Code CLI."
        echo ""
        echo -e "  Выполни в ${BOLD}отдельном терминале${RESET}:"
        echo -e "    ${CYAN}npm install -g @anthropic-ai/claude-code${RESET}"
        echo -e "    ${CYAN}claude login${RESET}"
        echo -e "    ${CYAN}claude setup-token${RESET}"
        echo -e "  Скопируй полученный токен и вставь сюда."
      fi
      echo ""
      read -p "  Setup-token (или Enter — пропустить): " MANUAL_TOKEN < /dev/tty
      if [ -n "$MANUAL_TOKEN" ]; then
        if command -v openclaw &>/dev/null; then
          echo "$MANUAL_TOKEN" | openclaw models auth paste-token --provider anthropic 2>/dev/null \
            && echo -e "  ${CHECK} Токен подписки подключен" \
            || echo -e "  ${CROSS} Не удалось подключить. Выполни вручную: openclaw models auth paste-token --provider anthropic"
        fi
      else
        echo -e "  ${DIM}Пропущено. Подключи подписку позже:${RESET}"
        echo -e "  ${CYAN}claude setup-token${RESET}  →  ${CYAN}openclaw models auth paste-token --provider anthropic${RESET}"
      fi
      ;;
    2)
      echo ""
      echo -e "  ${BOLD}Подключение Anthropic API${RESET}"
      echo ""
      echo -e "  1. Зайди на ${BOLD}console.anthropic.com/settings/keys${RESET}"
      echo -e "  2. Нажми ${BOLD}Create Key${RESET}"
      echo -e "  3. Скопируй ключ (начинается с sk-ant-...)"
      echo ""
      while true; do
        read -p "  Anthropic API ключ: " API_KEY < /dev/tty
        if [[ "$API_KEY" == sk-* ]]; then
          echo -e "  ${CHECK} Ключ принят"
          write_api_key "ANTHROPIC_API_KEY" "$API_KEY" "" \
            && echo -e "  ${CHECK} Записано в openclaw.json" \
            || echo -e "  ${YELLOW}⚠${RESET}  Добавь вручную: openclaw.json → env.vars.ANTHROPIC_API_KEY"
          break
        elif [ -z "$API_KEY" ]; then
          echo -e "  ${CROSS} Ключ обязателен. Получи на console.anthropic.com/settings/keys"
        else
          echo -e "  ${CROSS} Ключ начинается с sk-ant-... или sk-"
        fi
      done
      ;;
    3)
      echo ""
      echo -e "  ${BOLD}Подключение OpenAI API${RESET}"
      echo ""
      echo -e "  1. Зайди на ${BOLD}platform.openai.com/api-keys${RESET}"
      echo -e "  2. Нажми ${BOLD}Create new secret key${RESET}"
      echo -e "  3. Скопируй ключ (начинается с sk-...)"
      echo ""
      while true; do
        read -p "  OpenAI API ключ: " API_KEY < /dev/tty
        if [[ "$API_KEY" == sk-* ]]; then
          echo -e "  ${CHECK} Ключ принят"
          write_api_key "OPENAI_API_KEY" "$API_KEY" "openai/gpt-4.1" \
            && echo -e "  ${CHECK} Записано в openclaw.json (модель: gpt-4.1)" \
            || echo -e "  ${YELLOW}⚠${RESET}  Добавь вручную: openclaw.json → env.vars.OPENAI_API_KEY"
          break
        elif [ -z "$API_KEY" ]; then
          echo -e "  ${CROSS} Ключ обязателен. Получи на platform.openai.com/api-keys"
        else
          echo -e "  ${CROSS} Ключ начинается с sk-..."
        fi
      done
      ;;
    4)
      echo ""
      echo -e "  ${BOLD}Подключение OpenRouter${RESET}"
      echo ""
      echo -e "  1. Зайди на ${BOLD}openrouter.ai/keys${RESET}"
      echo -e "  2. Нажми ${BOLD}Create Key${RESET}"
      echo -e "  3. Скопируй ключ (начинается с sk-or-...)"
      echo ""
      while true; do
        read -p "  OpenRouter API ключ: " API_KEY < /dev/tty
        if [ -n "$API_KEY" ]; then
          echo -e "  ${CHECK} Ключ принят"
          echo ""
          echo -e "  Какую модель использовать?"
          echo -e "    ${CYAN}1${RESET}) Claude Sonnet 4.6 ${GREEN}(рекомендовано)${RESET}"
          echo -e "    ${CYAN}2${RESET}) GPT-4.1"
          echo -e "    ${CYAN}3${RESET}) Gemini 2.5 Pro"
          echo ""
          read -p "  Выбор (1-3): " MODEL_CHOICE < /dev/tty
          case $MODEL_CHOICE in
            1) OR_MODEL="openrouter/anthropic/claude-sonnet-4-6" ;;
            2) OR_MODEL="openrouter/openai/gpt-4.1" ;;
            3) OR_MODEL="openrouter/google/gemini-2.5-pro" ;;
            *) OR_MODEL="openrouter/anthropic/claude-sonnet-4-6" ;;
          esac
          write_api_key "OPENROUTER_API_KEY" "$API_KEY" "$OR_MODEL" \
            && echo -e "  ${CHECK} Записано в openclaw.json" \
            || echo -e "  ${YELLOW}⚠${RESET}  Добавь вручную: openclaw.json → env.vars.OPENROUTER_API_KEY"
          break
        else
          echo -e "  ${CROSS} Ключ обязателен. Получи на openrouter.ai/keys"
        fi
      done
      ;;
    5|*)
      echo -e "  ${DIM}Пропущено. Подключи модель позже:${RESET}"
      echo -e "  ${DIM}Claude подписка: openclaw models auth setup-token --provider anthropic${RESET}"
      echo -e "  ${DIM}API ключ: openclaw.json → env.vars.ANTHROPIC_API_KEY${RESET}"
      ;;
  esac
fi

# =============================================
# Шаг 4 из 6 — Telegram бот
# =============================================
echo ""
echo -e "${BOLD}Шаг 4 из 6${RESET} ${DIM}— Telegram бот${RESET}"
echo ""

echo -e "  Чтобы общаться с агентом через Telegram,"
echo -e "  нужен бот. Создай его через ${CYAN}@BotFather${RESET}."
echo ""
echo -e "  ${DIM}1. Открой @BotFather в Telegram${RESET}"
echo -e "  ${DIM}2. Напиши /newbot${RESET}"
echo -e "  ${DIM}3. Придумай имя и username${RESET}"
echo -e "  ${DIM}4. Скопируй токен (вида 123456789:ABC...)${RESET}"
echo ""

BOT_TOKEN_TG=""
while true; do
  read -p "  Токен бота (или Enter — пропустить): " BOT_TOKEN_TG < /dev/tty
  if [ -z "$BOT_TOKEN_TG" ]; then
    echo -e "  ${DIM}Пропущено. Добавь позже в openclaw.json${RESET}"
    break
  elif [[ "$BOT_TOKEN_TG" =~ ^[0-9]+:.+$ ]]; then
    echo -e "  ${CHECK} Токен бота принят"
    break
  else
    echo -e "  ${CROSS} Неверный формат. Токен выглядит как: 123456789:ABCdefGHIjklMNOpqrSTUvwxyz"
  fi
done

# Telegram ID
TG_USER_ID=""
if [ -n "$BOT_TOKEN_TG" ]; then
  echo ""
  echo -e "  Твой Telegram ID (чтобы бот отвечал только тебе)"
  echo -e "  ${DIM}Напиши @userinfobot в Telegram — он покажет ID (число)${RESET}"
  echo ""
  while true; do
    read -p "  Telegram ID: " TG_USER_ID < /dev/tty
    if [[ "$TG_USER_ID" =~ ^[0-9]+$ ]]; then
      echo -e "  ${CHECK} ID: $TG_USER_ID"
      break
    elif [ -z "$TG_USER_ID" ]; then
      echo -e "  ${DIM}Пропущено. Добавь allowFrom позже.${RESET}"
      break
    else
      echo -e "  ${CROSS} ID — это число. Пример: 123456789"
    fi
  done
fi

# =============================================
# Шаг 5 из 6 — Генерация конфига
# =============================================
echo ""
echo -e "${BOLD}Шаг 5 из 6${RESET} ${DIM}— Конфигурация${RESET}"
echo ""

OC_DIR="$HOME/.openclaw"
OC_CONFIG="$OC_DIR/openclaw.json"
mkdir -p "$OC_DIR"
MODEL_PRIMARY="anthropic/claude-sonnet-4-6"

# Бэкап если есть
BACKUP_TS=$(date +%Y%m%d%H%M%S)
if [ -f "$OC_CONFIG" ]; then
  cp "$OC_CONFIG" "$OC_CONFIG.backup.$BACKUP_TS"
  echo -e "  ${CHECK} Бэкап конфига: openclaw.json.backup.$BACKUP_TS"
fi

echo -ne "  Генерирую конфиг... "

if command -v node &>/dev/null; then
  node -e "
const fs = require('fs');
const configPath = '$OC_CONFIG';
const botToken = '$BOT_TOKEN_TG';
const tgId = '$TG_USER_ID' ? parseInt('$TG_USER_ID') : null;
const installDir = '$INSTALL_DIR';
const model = '$MODEL_PRIMARY';

let c = {};
if (fs.existsSync(configPath)) {
  try { c = JSON.parse(fs.readFileSync(configPath, 'utf8')); } catch(e) {}
}

// Defaults
c.agents = c.agents || {};
if (!c.agents.defaults) c.agents.defaults = {};
if (!c.agents.defaults.model) c.agents.defaults.model = { primary: model };
if (!c.agents.defaults.thinkingDefault) c.agents.defaults.thinkingDefault = 'high';
if (!c.agents.defaults.heartbeat) c.agents.defaults.heartbeat = { every: '1h' };
if (!c.agents.defaults.contextPruning) c.agents.defaults.contextPruning = { mode: 'cache-ttl', ttl: '6h' };
if (!c.agents.defaults.compaction) c.agents.defaults.compaction = { mode: 'safeguard', reserveTokensFloor: 20000, memoryFlush: { enabled: true, softThresholdTokens: 4000 } };
if (!c.agents.defaults.memorySearch) c.agents.defaults.memorySearch = { enabled: true, sources: ['memory'], provider: 'openai', model: 'text-embedding-3-small', query: { maxResults: 8, minScore: 0.3 } };
if (!c.session) c.session = { reset: { mode: 'daily', atHour: 4 } };
if (!c.gateway) c.gateway = { mode: 'local', port: 18789, bind: 'loopback' };

// Skills
const home = require('os').homedir();
c.skills = c.skills || {};
c.skills.load = c.skills.load || {};
if (!c.skills.load.extraDirs) c.skills.load.extraDirs = [];
const managedSkillsDir = home + '/.openclaw/skills';
if (!c.skills.load.extraDirs.includes(managedSkillsDir)) c.skills.load.extraDirs.push(managedSkillsDir);
c.plugins = c.plugins || { entries: {} };
c.plugins.entries.telegram = c.plugins.entries.telegram || { enabled: true };

c.agents.list = c.agents.list || [];
c.bindings = c.bindings || [];
c.channels = c.channels || {};
c.channels.telegram = c.channels.telegram || { enabled: true, accounts: {} };
c.channels.telegram.enabled = true;
c.channels.telegram.accounts = c.channels.telegram.accounts || {};

// Single agent — default
if (!c.agents.list.some(a => a.id === 'default')) {
  c.agents.list.push({ id: 'default', name: 'Фабрика Lite', workspace: installDir, identity: { emoji: '🏭' } });
}

if (botToken) {
  c.channels.telegram.accounts.default = {
    botToken: botToken,
    dmPolicy: 'allowlist',
    allowFrom: tgId ? [tgId] : [],
    groupPolicy: 'open',
    groupAllowFrom: tgId ? [tgId] : [],
    streaming: 'partial',
    actions: { reactions: true, sendMessage: true }
  };
  if (!c.bindings.some(b => b.agentId === 'default')) {
    c.bindings.push({ agentId: 'default', match: { channel: 'telegram', accountId: 'default' } });
  }
}

fs.writeFileSync(configPath, JSON.stringify(c, null, 2));
console.log('1 агент');
  " 2>/dev/null

  if [ $? -eq 0 ]; then
    echo -e "${GREEN}ок${RESET}"
  else
    echo -e "${RED}ошибка${RESET}"
    [ -f "$OC_CONFIG.backup.$BACKUP_TS" ] && cp "$OC_CONFIG.backup.$BACKUP_TS" "$OC_CONFIG" 2>/dev/null
  fi

  # Валидация
  if [ -f "$OC_CONFIG" ] && ! node -e "JSON.parse(require('fs').readFileSync('$OC_CONFIG','utf8'))" 2>/dev/null; then
    echo -e "  ${RED}✗${RESET} JSON невалиден — восстанавливаю бэкап"
    [ -f "$OC_CONFIG.backup.$BACKUP_TS" ] && cp "$OC_CONFIG.backup.$BACKUP_TS" "$OC_CONFIG" 2>/dev/null
  fi

  echo -e "  ${CHECK} Конфиг: $OC_CONFIG"
  [ -n "$BOT_TOKEN_TG" ] && echo -e "  ${CHECK} Telegram бот подключен"
  [ -n "$TG_USER_ID" ] && echo -e "  ${CHECK} Отвечает только тебе (ID: $TG_USER_ID)"
else
  echo -e "${YELLOW}⚠${RESET} Node.js не найден — конфиг нужно настроить вручную"
fi

# =============================================
# Шаг 6 из 6 — Первый проект
# =============================================
echo ""
echo -e "${BOLD}Шаг 6 из 6${RESET} ${DIM}— Первый проект${RESET}"
echo ""

PROJECTS_DIR="$INSTALL_DIR/projects"
EXISTING_PROJECT=$(ls -d "$PROJECTS_DIR"/*/ 2>/dev/null | grep -v '_template\|example-' | head -1)

if [ -n "$EXISTING_PROJECT" ]; then
  PROJECT_NAME=$(basename "$EXISTING_PROJECT")
  echo -e "  ${CHECK} Проект уже есть: ${BOLD}$PROJECT_NAME${RESET}"
else
  echo -e "  Назови свой проект (например: ${CYAN}fitness-blog${RESET}, ${CYAN}psychologist${RESET})"
  echo -e "  ${DIM}Латиница, без пробелов. Enter = my-project. 0 = пропустить${RESET}"
  echo ""
  read -p "  Имя проекта: " PROJECT_NAME < /dev/tty
  if [ "$PROJECT_NAME" = "0" ]; then
    echo -e "  ${DIM}Пропущено. Создашь позже: mkdir projects/my-project${RESET}"
    PROJECT_NAME=""
  elif [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME="my-project"
  fi
  if [ -n "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
    [ -z "$PROJECT_NAME" ] && PROJECT_NAME="my-project"
    mkdir -p "$PROJECTS_DIR/$PROJECT_NAME/drafts"
    mkdir -p "$PROJECTS_DIR/$PROJECT_NAME/published"
    mkdir -p "$PROJECTS_DIR/$PROJECT_NAME/assets"
    echo -e "  ${CHECK} Создан: ${BOLD}projects/$PROJECT_NAME/${RESET}"
    echo -e "  ${DIM}drafts/ — черновики, published/ — готовое, assets/ — медиа${RESET}"
  fi
fi

# === Создаём update.sh ===
cd "$INSTALL_DIR"
cat > "update.sh" << 'UPDATEEOF'
#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

BOLD="\033[1m" DIM="\033[2m" RESET="\033[0m"
GREEN="\033[32m" CYAN="\033[36m" RED="\033[31m"
CHECK="${GREEN}✓${RESET}" CROSS="${RED}✗${RESET}" ARROW="${CYAN}→${RESET}"

echo ""
echo -e "  ${BOLD}🏭 Фабрика Контента Lite — Обновление${RESET}"
echo ""

TMPDIR=$(mktemp -d)

echo -ne "  ${ARROW} Скачиваю обновления... "
if command -v git &>/dev/null; then
  git clone --depth 1 https://github.com/Dimks777/aiclublight.git "$TMPDIR/factory" 2>/dev/null
else
  curl -sfL https://github.com/Dimks777/aiclublight/archive/main.tar.gz -o "$TMPDIR/factory.tar.gz"
  tar xzf "$TMPDIR/factory.tar.gz" -C "$TMPDIR" 2>/dev/null
  mv "$TMPDIR/aiclublight-main" "$TMPDIR/factory" 2>/dev/null || true
fi

if [ ! -d "$TMPDIR/factory" ]; then
  echo -e "${RED}ошибка${RESET}"
  rm -rf "$TMPDIR"
  exit 1
fi
echo -e "${GREEN}ок${RESET}"

# Скиллы
SKILLS_TARGET="$HOME/.openclaw/skills"
mkdir -p "$SKILLS_TARGET"
echo -ne "  ${ARROW} Обновляю скиллы... "
if [ -d "$TMPDIR/factory/skills" ]; then
  for skill_dir in "$TMPDIR/factory/skills"/*/; do
    [ ! -d "$skill_dir" ] && continue
    skill=$(basename "$skill_dir")
    mkdir -p "$SKILLS_TARGET/$skill"
    cp -r "$skill_dir"/* "$SKILLS_TARGET/$skill/" 2>/dev/null || true
  done
fi
SKILL_COUNT=$(ls -d "$SKILLS_TARGET"/*/ 2>/dev/null | wc -l | tr -d ' ')
echo -e "${GREEN}${SKILL_COUNT} скиллов${RESET}"

# SOUL.md
echo -ne "  ${ARROW} Обновляю SOUL.md... "
if [ -f "$TMPDIR/factory/factory/agents/coordinator/SOUL.md" ]; then
  cp "$TMPDIR/factory/factory/agents/coordinator/SOUL.md" "$DIR/SOUL.md" 2>/dev/null
  echo -e "${GREEN}ок${RESET}"
else
  echo -e "${DIM}не найден${RESET}"
fi

rm -rf "$TMPDIR"

echo ""
echo -e "  ${CHECK} Обновление завершено"
echo ""
UPDATEEOF
chmod +x "update.sh"

# =============================================
# Финал
# =============================================
echo ""
echo -e "${GOLD}  ╔══════════════════════════════════════╗${RESET}"
echo -e "${GOLD}  ║                                      ║${RESET}"
echo -e "${GOLD}  ║   ✅ Установка завершена!             ║${RESET}"
echo -e "${GOLD}  ║                                      ║${RESET}"
echo -e "${GOLD}  ╚══════════════════════════════════════╝${RESET}"
echo ""
echo -e "  ${BOLD}🏭 Фабрика Контента Lite${RESET}"
echo -e "  📁 Workspace: ${INSTALL_DIR}"
echo -e "  🧩 ${SKILL_COUNT} скиллов → ${SKILLS_TARGET}"
echo -e "  🤖 1 агент (coordinator)"
echo ""
echo -e "  ${BOLD}Что дальше:${RESET}"
echo -e "  ${ARROW} Заполни ${CYAN}USER.md${RESET} — расскажи агенту о себе"
echo -e "  ${ARROW} Запусти ${CYAN}openclaw gateway restart${RESET}"
echo -e "  ${ARROW} Напиши боту в Telegram — он готов к работе"
echo -e "  ${ARROW} Обновление: ${CYAN}bash update.sh${RESET}"
echo ""
