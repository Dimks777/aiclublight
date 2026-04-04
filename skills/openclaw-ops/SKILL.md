---
name: openclaw-ops
description: "Установка, настройка, диагностика и поддержка OpenClaw + Фабрики Контента. Конфиг, агенты, каналы, модели, бэкапы, фиксы, онбординг, скиллы, обновления, VPS, Telegram, FAQ."
triggers:
  - openclaw
  - конфиг openclaw
  - бот не отвечает
  - настройка агентов
  - обновить openclaw
  - openclaw config
  - openclaw fix
  - не работает
  - ошибка 401
  - как установить
  - как обновить
  - factory doctor
  - скиллы не найдены
  - помоги настроить
  - что делать
---

# OpenClaw Ops — Полная поддержка Фабрики Контента

> Всё про OpenClaw и Фабрику: установка, настройка, диагностика, фиксы, обновления, скиллы, агенты. Самый короткий путь к решению.

## Когда использовать

- Установка и первый запуск OpenClaw / Фабрики
- Бот не отвечает / не видит сообщения / ошибки
- Настройка агентов, каналов, моделей
- Обновление скиллов и OpenClaw
- Бэкап и восстановление конфига
- Любой вопрос "как сделать X в OpenClaw"
- Помощь с онбордингом нового участника
- Диагностика и фиксы любых проблем

## File Router

| Запрос содержит | Файл |
|-----------------|------|
| ошибка, не работает, 401, 403, молчит, crash | references/troubleshooting.md |
| конфиг, openclaw.json, настроить, аудит | references/config-audit.md |
| онбординг, установка, первый запуск, начать | references/onboarding.md |
| скилл, связки, комбинации, что использовать | references/skills-guide.md |
| кейс, эксперт, психолог, тренер, SMM | references/use-cases.md |
| factory, CLI, doctor, update, команда | references/factory-cli.md |

---

## Архитектура (кратко)

```
OpenClaw = Gateway (сервер) + Agents (ИИ-агенты) + Channels (Telegram, Discord...)

Telegram → Gateway → выбирает агента по binding → агент думает → ответ → Telegram

Конфиг: ~/.openclaw/openclaw.json (ВСЁ настраивается тут)
Агенты: каждый в своей папке (workspace) с SOUL.md
Скиллы: ./skills/ в workspace каждого агента или ~/.openclaw/skills/
```

### Три уровня системы

```
СКИЛЛ (skills/)     → "КАК делать"  (рецепт/методика)
       ↓
АГЕНТ (agents/)     → "КТО делает"  (роль/специалист)
       ↓
ПРОЕКТ (projects/)  → "ДЛЯ КОГО"   (конкретный эксперт)
```

### Что есть что

- **Claude Code** — терминальный AI-ассистент от Anthropic. Работает локально на компе
- **OpenClaw** — платформа для запуска AI-агентов в Telegram. Работает 24/7 на VPS
- **Фабрика Контента** — набор скиллов и настроек. Ставится поверх Claude Code ИЛИ OpenClaw
- Агенты Claude Code и агенты OpenClaw — совершенно разные вещи. Можно совмещать

---

## Быстрая установка

### Порядок установки (правильный)

1. **Node.js 18+** → `node -v` (если нет: macOS `brew install node`, Linux/Windows — nodejs.org)
2. **OpenClaw** → `npm install -g openclaw`
3. **Первый запуск** → `openclaw init` (wizard)
4. **Telegram бот** → @BotFather → /newbot → получить токен
5. **Фабрика** → `curl -sSL https://открой Telegram-бота Фабрики Контента`
6. **Старт** → `openclaw gateway start`

❌ НЕ используй git clone / git pull — установщик единственная система обновления.

### Как обновить

Одна команда для всех тарифов:

```bash
curl -sSL https://открой Telegram-бота Фабрики Контента
```

Скрипт сам определяет тариф по токену. Обновит только скиллы — НЕ трогает brand/, learning/ и настройки.
После обновления: `openclaw gateway restart`

❌ Старые ссылки НЕ использовать (factory-api-endpoint/5agents, /vip-factory, /update и т.д.)

Или через factory CLI: `factory update`

---

## Конфиг (openclaw.json)

Путь: `~/.openclaw/openclaw.json`

### Эталонный конфиг

```json
{
  "model": "anthropic/claude-sonnet-4-6",
  "auth": {
    "providers": [
      {
        "type": "api-key",
        "provider": "anthropic",
        "apiKey": "sk-ant-api03-..."
      }
    ]
  },
  "agents": {
    "defaults": {
      "thinking": "high",
      "thinkingDefault": "high",
      "streaming": "partial",
      "imageMaxDimensionPx": 1120
    }
  },
  "channels": {
    "telegram": {
      "token": "123456789:AAF...",
      "dmPolicy": "allow"
    }
  },
  "skills": ["./skills"],
  "memory": {
    "memorySearch": true
  },
  "compaction": {
    "mode": "safeguard",
    "memoryFlush": {
      "enabled": true
    }
  }
}
```

### Ключевые настройки

| Параметр | Что делает | Рекомендация |
|----------|-----------|--------------|
| `model` | Модель ИИ | `anthropic/claude-sonnet-4-6` |
| `thinking` / `thinkingDefault` | Глубина мышления | `"high"` |
| `streaming` | Стриминг ответов | `"partial"` (обязательно для Telegram!) |
| `imageMaxDimensionPx` | Макс. размер картинок | `1120` (для скринов — `2400`) |
| `dmPolicy` | Личные сообщения | `"allow"` или `"allowlist"` |
| `groupPolicy` | Группы | `"allowlist"` или `"open"` |
| `compaction.mode` | Сжатие контекста | `"safeguard"` (обязательно!) |
| `memorySearch` | Поиск по памяти | `true` для рабочих агентов |

> Подробный чеклист аудита конфига → `references/config-audit.md`

---

## Быстрая диагностика

### Бот не отвечает — 5 шагов

```
Шаг 1: openclaw gateway status
  → Запущен? Если НЕТ → openclaw gateway start

Шаг 2: openclaw doctor
  → Покажет проблемы

Шаг 3: openclaw gateway restart
  → 80% проблем решается рестартом

Шаг 4: Проверь логи
  openclaw gateway logs --tail 50
  → Ищи "error", "unauthorized", "timeout"

Шаг 5: factory doctor
  → 10 проверок системы
```

### Самые частые ошибки и решения

| Ошибка / Симптом | Решение |
|-----------------|---------|
| **401 authentication_error** | Токен истёк → `openclaw models auth paste-token --provider anthropic` → restart |
| **401 invalid x-api-key** | В конфиге ANTHROPIC_API_KEY перебивает токен → удалить из openclaw.json → restart |
| **403 forbidden** | VPN не покрывает терминал → `curl -s https://ipinfo.io/country` → если RU, нужен VPN-приложение на весь Mac |
| **model not found** | Нет API ключа или устаревшая модель → обновить model в конфиге |
| **Бот молчит в группе** | Privacy Mode у бота → BotFather → /mybots → Group Privacy → Disable → restart |
| **not allowed** | Telegram ID не в allowFrom → добавить ID → restart |
| **Group migrated** | Группа стала супергруппой → обновить chat_id (логи покажут новый) |
| **context overflow** | compaction.mode: "safeguard" → restart |
| **0 скиллов** | Неверный путь в конфиге → `openclaw config get skills` → исправить |
| **Агент тупит / долго** | Раздутый контекст → `/restart` в чате |
| **Rate limit** | Лимиты подписки → отключить heartbeat у неосновных агентов |
| **tools profile "messaging"** | Агент не может читать файлы → сменить на `"profile": "full"` → restart |
| **Скриншоты не читаются** | `imageMaxDimensionPx: 2400` + отправлять как документ |
| **Heartbeat жрёт лимиты** | `openclaw config set agents.defaults.heartbeat.interval "0"` |
| **JSON parse error** | Лишняя запятая / кавычки → `openclaw doctor --fix` |

> Полный справочник с деревьями решений → `references/troubleshooting.md`

### Как узнать свой Telegram ID

1. Написать боту @userinfobot в Telegram
2. Он ответит твой ID (число)
3. Вставить в allowFrom в конфиг

### Как создать Telegram бота

1. Открыть @BotFather → /newbot → имя → username (на "bot")
2. Скопировать токен (вида `123456789:AAF...`)
3. Вставить в конфиг
4. Между созданием ботов ждать 5-10 мин (лимит BotFather)

---

## Авторизация: API vs Подписка

### Как определить что у пользователя

| Признак | Тип | Что делать |
|---------|-----|-----------|
| Платит на claude.ai ($20/$100) | Подписка | `claude setup-token` → oat01 токен |
| Платит на console.anthropic.com | API | Ключ из Console (sk-ant-api03-) |

### Подключение подписки (oat-токен)

```bash
# 1. На Mac (не VPS!):
npm install -g @anthropic-ai/claude-code
claude /login  # OAuth через браузер

# 2. Достать токен:
security find-generic-password -s "Claude Code-credentials" -a "USERNAME" -w
# Скопировать accessToken (sk-ant-oat01-...)

# 3. На VPS:
openclaw models auth paste-token --provider anthropic
# Вставить oat01 токен

# 4. Перезапуск
openclaw gateway restart
```

**Проверка:** `openclaw models status` → anthropic: ok

**Важно:** НЕ вставляй API key (sk-ant-api03-) туда, где нужен OAuth (sk-ant-oat01-) и наоборот!

### auth-profiles.json для нескольких агентов

`openclaw models auth paste-token --provider anthropic` сохраняет для всех агентов.

Если у агента есть отдельный `agentDir` — глобальный auth-profiles.json НЕ подхватывается. Нужен файл в agentDir:
```bash
ln -sf ~/.openclaw/auth-profiles.json ~/.openclaw/agents/[agent]/agent/auth-profiles.json
```

---

## Обновление

```bash
# Проверить текущую версию
openclaw --version

# Обновить OpenClaw
npm update -g openclaw

# Обновить скиллы Фабрики
curl -sSL https://открой Telegram-бота Фабрики Контента

# Или через factory CLI
factory update

# Перезапустить
openclaw gateway restart
```

---

## Бэкап и восстановление

### ⚠️ ПРЕДОХРАНИТЕЛЬ

`openclaw doctor --fix` может ПЕРЕЗАПИСАТЬ конфиг, удалив настройки агентов!

```bash
# ВСЕГДА перед doctor --fix:
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# Если doctor сломал конфиг:
cp ~/.openclaw/openclaw.json.backup ~/.openclaw/openclaw.json
openclaw gateway restart
```

### Регулярный бэкап
```bash
cp -r ~/.openclaw ~/.openclaw-backup-$(date +%Y%m%d)
```

### Если установщик перезаписал конфиг
```bash
# OpenClaw хранит до 4 бэкапов:
ls ~/.openclaw/openclaw.json.bak*
cp ~/.openclaw/openclaw.json.bak ~/.openclaw/openclaw.json
openclaw gateway restart
```

---

## Память (Memory)

### Как работает
- Каждый агент имеет `MEMORY.md` + `memory/` папку
- `memory/YYYY-MM-DD.md` — дневные логи
- `learning/` — паттерны и антипаттерны
- При перезапуске агент читает MEMORY.md → помнит контекст

### Настройка
```json
"memorySearch": {
  "enabled": true,
  "provider": "openai",
  "model": "text-embedding-3-small"
}
```

### Compaction (сжатие контекста)
```json
"compaction": {
  "mode": "safeguard",
  "memoryFlush": {
    "enabled": true
  }
}
```
**safeguard** = агент автоматически сохраняет контекст перед сжатием. БЕЗ ЭТОГО память теряется!

### Агент не помнит что было вчера

Это нормально — сессия = текущий диалог. При рестарте gateway сессии сбрасываются.

Что делать:
1. Важное записывай в MEMORY.md — агент читает его при каждом старте
2. Результаты работы → memory/YYYY-MM-DD.md
3. Для автоматического сохранения: включи memoryFlush

---

## Межагентное взаимодействие

### Включение
```json
"agentToAgent": {
  "enabled": true,
  "allow": ["coordinator", "copywriter", "marketer", "designer", "techie"]
}
```

### Как работает
- Координатор отправляет задачу копирайтеру через `sessions_send`
- Агенты видят друг друга через `sessions_list`
- Каждый агент изолирован (свой workspace, своя память)
- Боты друг друга НЕ видят в группах Telegram — это ограничение Telegram

### Настройка 5 агентов

Для 5 агентов нужно 5 отдельных Telegram-ботов через @BotFather.

Каждый бот привязан к своему агенту через bindings:
```json
{
  "bindings": [
    { "agentId": "coordinator", "match": { "channel": "telegram", "accountId": "coordinator-bot" } },
    { "agentId": "copywriter", "match": { "channel": "telegram", "accountId": "copywriter-bot" } },
    { "agentId": "designer", "match": { "channel": "telegram", "accountId": "designer-bot" } },
    { "agentId": "marketer", "match": { "channel": "telegram", "accountId": "marketer-bot" } },
    { "agentId": "techie", "match": { "channel": "telegram", "accountId": "techie-bot" } }
  ]
}
```

### Два бота в группе — requireMention

Чтобы боты видели ВСЕ сообщения, но отвечали ТОЛЬКО когда тегнут:
```json
{
  "channels": {
    "telegram": {
      "groupPolicy": "open",
      "groups": {
        "-100XXXXXX": { "requireMention": true }
      }
    }
  }
}
```

---

## Где хранятся файлы агента

### Рабочая директория (workspace) — `~/openclaw-ai/<agent>/`
- `SOUL.md` — личность, инструкции, правила
- `MEMORY.md` — долгосрочная память
- `memory/` — ежедневные логи
- `learning/` — антипаттерны, коррекции
- `brand/` — профиль эксперта
- `skills/` — скиллы (наивысший приоритет)

### Служебная директория — `~/.openclaw/agents/<agent>/`
- `sessions/` — логи сессий (НЕ трогай)
- `qmd/` — индексы для поиска
- `agent/` — auth, кэш

Размер служебки: ~100-400 МБ на агента. Если удалить — пересоздаст, но потеряются логи.

---

## CLI команды (справочник)

### OpenClaw

| Команда | Что делает |
|---------|-----------|
| `openclaw status` | Статус системы |
| `openclaw doctor` | Диагностика |
| `openclaw doctor --fix` | Автоисправление (⚠️ бэкап!) |
| `openclaw gateway start` | Запуск |
| `openclaw gateway stop` | Остановка |
| `openclaw gateway restart` | Перезапуск |
| `openclaw gateway logs` | Логи |
| `openclaw gateway logs --tail 50` | Последние 50 строк логов |
| `openclaw init` | Первоначальная настройка |
| `openclaw --version` | Версия |
| `openclaw models status` | Статус моделей |
| `openclaw models auth paste-token --provider anthropic` | Вставить OAuth токен |
| `openclaw config get [path]` | Прочитать настройку |
| `openclaw config set [path] [value]` | Изменить настройку |
| `openclaw pairing approve telegram [КОД]` | Подтвердить pairing |

### Factory CLI

| Команда | Что делает |
|---------|-----------|
| `factory` | Интерактивное меню |
| `factory update` | Обновить всё (CLI + скиллы) |
| `factory skills` | Список скиллов |
| `factory agents` | Список агентов |
| `factory tokens` | Настройка токенов |
| `factory doctor` | Диагностика (10 проверок) |
| `factory status` | Статус системы |
| `factory -v` | Версия |

---

## Стоимость

### Подписка Фабрики

| Платёж | Стоимость |
|--------|-----------|
| Вход | 7 990 ₽ |
| Далее ежемесячно | 1 490 ₽/мес |

### Стоимость ИИ (отдельно)

| Вариант | Стоимость |
|---------|-----------|
| Claude Code + Claude Pro | $20/мес (с лимитами) |
| Claude Code + Claude Max | $100/мес (без ограничений) |
| OpenClaw + API ключ | ~$20-50/мес (по потреблению) |
| OpenClaw + подписка Claude | $20-100/мес (через paste-token) |

Дополнительно: LaoZhang для картинок ($1-5/мес), VPS ($5+/мес), MoreLogin ($9+/мес)

### $100 vs $200 подписка

- $100/мес = ~$1350 эквивалент API
- $200/мес = ровно вдвое больше лимитов. НЕ безлимит
- Лимиты бывают часовые, дневные и недельные

---

## Безопасность — 4 проверки

| Проблема | Как проверить | Как починить |
|----------|--------------|-------------|
| groupPolicy="open" + elevated tools | `openclaw config get channels.telegram.groupPolicy` | Сменить на "allowlist" |
| DM открыты для всех | `openclaw config get channels.telegram.dmPolicy` | Сменить на "allowlist" |
| Нет списка разрешённых | `openclaw config get channels.telegram.allowFrom` | Добавить свой Telegram ID |
| credentials 755 | `ls -la ~/.openclaw/credentials` | `chmod 700 ~/.openclaw/credentials` |

---

## Экономия токенов

1. Отключи heartbeat у неосновных агентов: `openclaw config set agents.defaults.heartbeat.interval "0"`
2. Ограничь сессии: `openclaw config set agents.defaults.session.maxAge "4h"`
3. SOUL.md — максимум 100-150 строк
4. Не отправляй тяжёлые файлы — жрут контекст
5. `/restart` когда контекст раздут

---

## Основные команды конструктора

| Команда | Что делает |
|---------|-----------|
| `начать` | Первичная настройка, интервью |
| `интервью` | Перенастроить голос |
| `threads 5` | 5 постов для Threads |
| `напиши пост про [тема]` | Пост на тему |
| `сценарий youtube про [тема]` | Скрипт для YouTube |
| `карусель про [тема]` | Instagram карусель |
| `reels про [тема]` | Идея для вертикального видео |
| `статья про [тема]` | SEO-статья для блога |
| `распаковка личности` | Глубокий разбор эксперта |
| `проверь пост` / `критика` | Проверка качества контента |

---

## Документация

- Полная документация: https://docs.openclaw.ai
- База знаний Фабрики: https://factory-site
- Скиллы: https://clawhub.com
- Доступ: Telegram-бот?start=access
- Партнёрская программа: https://factory-site/start/affiliate/

*OpenClaw Ops v2.0 — интегрирована база знаний поддержки Фабрики Контента*
