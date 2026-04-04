# Онбординг — Пошаговая установка Фабрики Контента

> Выбери путь и следуй шагам по порядку.

---

## Путь A: Claude Code (терминал)

Подходит если хочешь работать через терминал и GitHub. Требует подписку Claude Max.

### Шаг 1: Подписка Claude
- Зайди на claude.ai → Settings → Upgrade
- **Pro ($20/мес)** — работает, но с лимитами. **Max ($100/мес)** — без ограничений

### Шаг 2: Node.js 18+
- Проверь: `node -v`
- Если нет: macOS `brew install node`, Windows/Linux — nodejs.org

### Шаг 3: Claude Code
- `npm install -g @anthropic-ai/claude-code`
- Проверь: `claude --version`

### Шаг 4: Авторизация
- Запусти: `claude` → пройди OAuth → войди через тот же claude.ai аккаунт

### Шаг 5: Установи Конструктор
- Получи ссылку: Telegram-бот?start=access
- Запусти установщик
- Зайди в папку: `cd ~/content-factory`

### Шаг 6: Интервью
- В папке: `claude` → напиши `начать`
- Пройди интервью (~10 мин) → создаётся `brand/voice-style.md`

### Шаг 7: Первые посты
- `напиши 3 поста для Threads` → оцени результат

### Шаг 8: Обратная связь
- `вот этот пост зашёл, вот этот нет — почему?` → система скорректирует

---

## Путь B: OpenClaw (Telegram)

Подходит если хочешь работать через Telegram-бота. Требует API-ключ или подписку Claude.

### Шаг 1: Доступ к Anthropic
- **API-ключ:** console.anthropic.com → API Keys → Create Key
- **Подписка Claude:** через paste-token (см. шаг 4)

### Шаг 2: OpenClaw
- `npm install -g openclaw`
- Проверь: `openclaw --version`

### Шаг 3: Telegram-бот
- Напиши @BotFather → /newbot → получи токен (`123456789:AAF...`)

### Шаг 4: Конфиг openclaw.json
Минимальный конфиг:
```json
{
  "model": "anthropic/claude-sonnet-4-6",
  "auth": {
    "providers": [
      {
        "type": "api-key",
        "provider": "anthropic",
        "apiKey": "sk-ant-ВАШ_КЛЮЧ"
      }
    ]
  },
  "agents": {
    "defaults": {
      "thinking": "high",
      "streaming": "partial",
      "imageMaxDimensionPx": 1120
    }
  },
  "channels": {
    "telegram": {
      "token": "ВАШ_ТОКЕН_БОТА",
      "dmPolicy": "allow"
    }
  }
}
```

Если используешь подписку Claude (без API-ключа):
```bash
openclaw models auth paste-token --provider anthropic
```

### Шаг 5: Установи Конструктор
- Получи ссылку: Telegram-бот?start=access
- Запусти установщик — он скачает скиллы и настроит workspace
- ❌ НЕ используй git clone / git pull

### Шаг 6: Запусти gateway
- `openclaw gateway start`
- Проверь: `openclaw gateway status`

### Шаг 7: Интервью
- Напиши боту в Telegram: `начать` → пройди интервью (~10 мин)

### Шаг 8: Первые посты
- `напиши 3 поста для Threads`

### Шаг 9: Обратная связь
- Укажи что понравилось, что нет — система скорректируется

---

## Какой вариант выбрать?

| | Claude Code | OpenClaw |
|---|---|---|
| **Где работаешь** | Терминал / VS Code | Telegram |
| **Стоимость** | Claude Pro $20 или Max $100/мес | API ~$20-50/мес или подписка |
| **Плюсы** | Мощнее, полный контроль | Удобно с телефона, 24/7 |
| **Минусы** | Нужен компьютер | Нужен API ключ или подписка |

Можно совмещать оба варианта.

---

## Если что-то пошло не так

1. На каком шаге застрял
2. Текст ошибки (скриншот или копипаст)
3. Claude Code или OpenClaw
4. → Смотри troubleshooting.md
