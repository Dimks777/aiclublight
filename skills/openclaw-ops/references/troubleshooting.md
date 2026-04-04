# Troubleshooting — Полный справочник решения проблем

> Каждая проблема = точный матч ошибки + короткое решение в 1-3 шага.
> Давай САМЫЙ КОРОТКИЙ путь решения. Не предлагай переустановку, если можно починить одной командой.

---

## Деревья диагностики

### Агент не отвечает

1. Проверь, запущен ли gateway → `openclaw gateway status`
   - Если НЕ запущен: `openclaw gateway start` → проверь снова

2. Проверь модель в `openclaw.json` → поле `model`
   - Если пустое или устаревшее: замени на `anthropic/claude-sonnet-4-6`

3. Проверь API-ключ → поле `auth.providers[].apiKey`
   - Если ключ не указан или неполный: вставь корректный ключ

4. Проверь конфиг канала → поле `channels.telegram`
   - Убедись что `token` бота указан (формат `123456789:AAF...`)
   - Убедись что `dmPolicy` не `deny`

5. Смотри логи gateway:
   - `openclaw gateway logs` → ищи `ERROR`, `WARN`, `connection refused`

---

### 401 authentication_error

1. Определи: API-ключ или подписка Claude?
   - Подписка (Pro/Max) → иди к 2
   - API-ключ → иди к 3

2. Подключи подписку через paste-token:
   ```bash
   openclaw models auth paste-token --provider anthropic
   ```
   - Токен получить: на Mac `claude setup-token` → скопировать oat01 токен

3. Проверь `auth-profiles.json`:
   - Путь: `~/.openclaw/auth-profiles.json`
   - API-ключ должен начинаться с `sk-ant-api03-`
   - Нет лишних пробелов и кавычек

4. Проверь баланс: console.anthropic.com → Billing
   - Баланс $0 → пополнить
   - Баланс есть → ключ заблокирован, создать новый

---

### Скиллы не найдены

1. Проверь, что папка `skills/` существует:
   - `ls ./skills` — если нет, обновить через установщик

2. Проверь путь в `openclaw.json`:
   ```json
   "skills": ["./skills"]
   ```
   - Путь относительно рабочей директории агента

3. Проверь SOUL.md агента:
   - Должно быть упоминание скиллов
   - Добавь: `Skills location: ./skills`

4. Перезапусти: `openclaw gateway restart`

---

### Контент не похож на голос

1. Проверь `brand/voice-style.md` — если пустой или нет → иди к 2

2. Перепройди интервью:
   - Напиши агенту: `начать` или `пересобери мой профиль`
   - Отвечай развёрнуто

3. Дай примеры своих текстов:
   - `вот мои лучшие посты: [вставь 3-5 постов]`
   - `обнови мой профиль голоса на основе этих примеров`

4. Давай конкретный фидбэк:
   - ❌ "не то" — слишком расплывчато
   - ✅ "слишком официально, я пишу проще и с юмором"

---

### Бот не видит сообщения в группе

1. Privacy Mode у бота:
   - @BotFather → /mybots → Bot Settings → Group Privacy → Disable
   - Удали бота из группы и добавь заново
   - `openclaw gateway restart`

2. Бот добавлен и имеет права:
   - Зайди в группу → Info → Administrators
   - Бот должен быть там с правами "Read Messages"

3. Группа была перенесена (Group Migration):
   - При конвертации в супергруппу chat_id меняется
   - Новый ID начинается с `-100...`
   - Ищи в логах: "Group migrated: old → new"

4. Проверь `chat_id` в конфиге:
   - Для групп и каналов ID **всегда отрицательный** (напр. `-1001234567890`)
   - Для личных чатов — положительное число

---

### Картинки не генерируются

1. Проверь скилл `nano-banana`:
   - Должна быть версия **Nano Banana Pro (Gemini 3 Pro)**
   - Если старая → обновить: `curl -sSL https://открой Telegram-бота Фабрики Контента`

2. Проверь API-ключ LaoZhang:
   - Получить: https://api.laozhang.ai/register/?aff_code=XTb4
   - Если нет → вставить при первой генерации

3. Проверь баланс на LaoZhang (~$0.05 за картинку)

4. Попробуй явно: `используй Nano Banana Pro через LaoZhang API, модель gemini-3-pro-image-preview`

---

### Claude Code — "subscription required"

1. Проверь подписку: claude.ai → Settings → Plan
2. Переавторизуйся: `claude` → пройди OAuth заново
3. Если не помогает: удали `~/.claude/` и пройди OAuth с нуля

---

### OpenClaw не стартует

1. Node.js 18+: `node -v`
2. OpenClaw установлен: `openclaw --version`
   - Если нет: `npm install -g openclaw`
   - Если EACCES: `sudo npm install -g openclaw`
3. Синтаксис openclaw.json: проверь через jsonlint.com
4. Логи: `openclaw gateway start --verbose`

---

## Ошибки авторизации (401/403)

### HTTP 401: Invalid bearer token
**Причина (90%):** токен скопирован с лишним символом или истёк.
**Решение:**
1. `claude setup-token` (на Mac)
2. `openclaw models auth paste-token --provider anthropic`
3. `openclaw gateway restart`

### HTTP 401: invalid x-api-key
**Причина:** ANTHROPIC_API_KEY в конфиге перебивает токен подписки.
**Решение:**
1. `cat ~/.openclaw/openclaw.json | grep -i "api.key\|ANTHROPIC"`
2. Удалить ANTHROPIC_API_KEY из конфига
3. `openclaw gateway restart`

### HTTP 401: OAuth token has expired
**Причина:** oat01 токен протух (живёт ~8-24 часа).
**Решение:** перевыпустить через `claude setup-token` → `paste-token` → restart.

### No API key found for provider "anthropic"
**Причина:** auth-profiles.json не в папке агента.
**Решение:**
1. `find ~/.openclaw -name "auth-profiles.json"`
2. Скопировать в нужного агента: `cp [путь] ~/.openclaw/agents/[agent]/agent/auth-profiles.json`
3. Или: `openclaw models auth paste-token --provider anthropic` (для всех)

### HTTP 403: Request not allowed
**Причины:**
1. VPN не покрывает терминал — `curl -s https://ipinfo.io/country` → если RU, нужен VPN-приложение
2. На VPS в России — нужен WireGuard/OpenVPN
3. Аккаунт заблокирован

---

## Бот молчит в Telegram

### groupPolicy "allowlist" + пустой allowFrom
**Диагностика:** `openclaw doctor` → warning
**Решение:**
- `openclaw config set channels.telegram.groupPolicy "open"` или
- `openclaw config set channels.telegram.allowFrom '["ТВОЙ_ID"]'`

### Privacy Mode включён
**Решение:** @BotFather → /mybots → Group Privacy → Disable → удалить/добавить бота → restart

### VPN слетел на сервере
**Проверка:** `curl -s https://api.telegram.org/bot[TOKEN]/getMe`
**Решение:** перезапустить VPN → `openclaw gateway restart`

---

## Rate Limits

### API rate limit reached
**Не баг.** Лимиты подписки исчерпаны.
1. Подождать 1-2 мин (часовой) или до следующего дня (дневной)
2. Отключить heartbeat: `openclaw config set agents.defaults.heartbeat.interval "0"`
3. Ограничить сессии: `openclaw config set agents.defaults.session.maxAge "4h"`

### Heartbeat жрёт токены
**Причина:** heartbeat каждые 30 мин × 5 агентов.
**Решение:** heartbeat ТОЛЬКО на main-агенте, остальные — отключить.

### Раздутый контекст (62%+)
1. `/restart` в чате с ботом
2. `openclaw config set agents.defaults.session.maxAge "4h"`
3. SOUL.md — сократить до 100-150 строк

---

## Gateway не стартует

### Timed out / status=stopped
1. `openclaw doctor --fix`
2. Логи: `cat ~/.openclaw/logs/gateway.err.log | tail -20`
3. Порт занят: `openclaw gateway stop && openclaw gateway start`
4. mode не задан: `openclaw config set gateway.mode local`

### Config invalid — Unrecognized key
**Решение:** `openclaw doctor --fix` — удалит неизвестные ключи.

### JSON parse error
1. Проверить: `cat ~/.openclaw/openclaw.json | python3 -m json.tool`
2. Частые ошибки: лишняя запятая, незакрытая скобка
3. ReferenceError → обновить OpenClaw: `npm install -g openclaw@latest`

### Gateway not installed
```bash
openclaw gateway install
openclaw gateway start
```

---

## Конфигурация

### Два бота отвечают одним агентом
**Причина:** нет bindings.
**Решение:** добавить bindings бот→агент в openclaw.json, restart.

### commands.native: false
**НЕ советовать!** Кладёт всех ботов. Убрать из конфига → restart.

---

## Агенты

### Агент не выполняет свою роль
**Решение:** в SOUL.md добавить:
```
## Boundaries
- I ONLY do: [конкретные задачи]
- I NEVER do: [чужие задачи]
- If asked about [чужая тема] → redirect to [нужный агент]
```

### Unexpected non-whitespace character after JSON
**Причина:** битая сессия (после отправки фото/файла).
**Решение:** `/restart`. Если не помогает: `rm ~/.openclaw/agents/[agent]/sessions/current*` → restart.

### tool_use без tool_result
**Решение:** `/restart` — единственный надёжный способ.

---

## Установка

### Xcode Developer Tools (macOS)
`xcode-select --install` → подтвердить → ждать 5-10 мин.

### npm/claude command not found
- npm: установить Node.js с nodejs.org
- claude: `npm install -g @anthropic-ai/claude-code`

### 48 скиллов с "missing requirements" при онбординге
Выбрать **No** — это встроенные скиллы OpenClaw. Скиллы Фабрики ставятся через установщик.

---

## VPS

### credentials 755
`chmod 700 /root/.openclaw/credentials`

### SSH port forwarding для дашборда
`ssh -L 18789:localhost:18789 vps` → `http://localhost:18789`

### Место на диске
```bash
du -sh ~/.openclaw/agents/*/sessions/ | sort -h
find ~/.openclaw/agents -name "*.jsonl" -mtime +7 -delete
> ~/.openclaw/logs/gateway.log
```

### Как запустить на VPS
1. VPS с Ubuntu 22+ и Node.js 18+
2. `npm install -g openclaw` → настроить openclaw.json
3. `openclaw gateway start` (через pm2/systemd для автозапуска)

### Логи на VPS
- pm2: `pm2 logs openclaw`
- systemd: `journalctl -u openclaw-gateway -n 50 --no-pager`

### Минимум для 5 агентов
1 vCPU, 1GB RAM, Ubuntu 22+. GPU не нужен.

### Где взять VPS
- Бегет (beget.com) — от $5/мес
- Vdsina — от $5/мес
- DigitalOcean — $6/мес (1-2 агента), $12/мес (3+)
- Hetzner — дешёвые серверы в Европе

---

## Telegram

### Боты друг друга НЕ видят в группах
Ограничение Telegram, не баг. Обход: тегать вручную или `sessions_send` между агентами.

### Pairing code
В терминале: `openclaw pairing approve telegram [КОД]`

### Как настроить чтобы бот отвечал только когда тегнут
```json
{
  "channels": {
    "telegram": {
      "groupPolicy": "open",
      "groups": { "-100XXXXXX": { "requireMention": true } }
    }
  }
}
```

### Как узнать ID группы/топика
- Группа: добавить @userinfobot
- Топик: открыть в web-Telegram → последнее число в URL = threadId

---

## Notion интеграция

### API token is invalid
1. Проверь ключ: `curl -s -H "Authorization: Bearer [КЛЮЧ]" -H "Notion-Version: 2022-06-28" https://api.notion.com/v1/users/me`
2. Пропиши обе переменные: `NOTION_TOKEN` и `NOTION_API_KEY` с одним значением

---

## Голосовые сообщения

Варианты распознавания:
- Whisper (OpenAI) — лучшее качество, нужен API key OpenAI
- Встроенный TTS в OpenClaw — базовый
Добавить OpenAI API key → OpenClaw подхватит для STT.

---

## Миграция на другую машину

1. Скопировать `~/.openclaw/` и workspace агентов
2. Перенести openclaw.json
3. `npm install -g openclaw` на новой машине
4. Обновить токены: `openclaw models auth paste-token --provider anthropic`
5. `openclaw gateway start`
