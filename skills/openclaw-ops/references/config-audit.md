# Аудит openclaw.json — Секция за секцией

> Когда участник присылает конфиг и что-то не работает — проверяй по этому чеклисту.

---

## Эталонный конфиг

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
  }
}
```

---

## 1. Секция model

| Что проверить | Как исправить |
|---|---|
| Поле `model` существует | Добавить `"model": "anthropic/claude-sonnet-4-6"` |
| Модель не устаревшая | Обновить до актуальной |
| Haiku для творческих задач | Заменить на Sonnet минимум |
| Модель совпадает с оплатой | API → любая; подписка → через paste-token |

```json
// ❌ Haiku слабый для контента
"model": "anthropic/claude-haiku-3"

// ✅ Хорошо
"model": "anthropic/claude-sonnet-4-6"
```

---

## 2. Секция auth

| Что проверить | Как исправить |
|---|---|
| Тип указан | `"type": "api-key"` или `"type": "oauth"` |
| API-ключ начинается с `sk-ant-api03-` | Вставить из Console |
| Нет лишних пробелов | Удалить пробелы |
| Providers — массив | Обернуть в `[]` |

```json
// ❌ Providers — объект, а не массив
"auth": {
  "providers": {
    "type": "api-key",
    "apiKey": "sk-ant-..."
  }
}

// ✅ Правильно — массив
"auth": {
  "providers": [
    {
      "type": "api-key",
      "provider": "anthropic",
      "apiKey": "sk-ant-api03-ПОЛНЫЙ_КЛЮЧ"
    }
  ]
}
```

---

## 3. Секция agents.defaults

| Что проверить | Как исправить |
|---|---|
| `thinking` = `"high"` | Добавить |
| `thinkingDefault` = `"high"` | Добавить |
| `streaming` = `"partial"` | Для Telegram обязательно `"partial"` |
| `imageMaxDimensionPx` указан | `1120` (для скринов — `2400`) |

```json
// ❌ streaming off = ответы приходят целиком (долго)
"defaults": { "streaming": "off" }

// ❌ Нет imageMaxDimensionPx → скриншоты нечитабельны
"defaults": { "thinking": "high", "streaming": "partial" }

// ✅ Полный набор
"defaults": {
  "thinking": "high",
  "thinkingDefault": "high",
  "streaming": "partial",
  "imageMaxDimensionPx": 1120
}
```

---

## 4. Секция channels.telegram

| Что проверить | Как исправить |
|---|---|
| `token` формат `123456789:AAFxxx...` | Получить у @BotFather |
| `dmPolicy` не `"deny"` | Поставить `"allow"` |
| `chat_id` отрицательный для групп | С минусом: `-1001234567890` |
| Название секции строчными | `telegram` не `Telegram` |

```json
// ❌ dmPolicy deny блокирует личку
"telegram": { "token": "123...", "dmPolicy": "deny" }

// ❌ chat_id без минуса
"telegram": { "chat_id": "1001234567890" }

// ✅ Правильно
"telegram": {
  "token": "123456789:AAFxxx...",
  "dmPolicy": "allow",
  "chat_id": -1001234567890
}
```

---

## 5. Секция skills

| Что проверить | Как исправить |
|---|---|
| Пути существуют | `ls ./skills` |
| Путь в workspace, не в корне | Относительный `./skills` |
| Нет дублей | Оставить одну копию |
| `skills` — массив | Обернуть в `[]` |

```json
// ❌ Путь в корень системы
"skills": ["/skills"]

// ❌ Дубли
"skills": ["./skills", "./skills/nano-banana"]

// ✅ Правильно
"skills": ["./skills"]
```

---

## 6. Секция memory

| Что проверить | Как исправить |
|---|---|
| `memorySearch` включён для рабочих агентов | `true` |
| Выключен для новых (пустая память) | `false` |

---

## Быстрый чеклист

- [ ] `model` — Sonnet или выше, не Haiku
- [ ] `auth.providers` — массив, ключ полный, начинается с `sk-ant-api03-`
- [ ] `agents.defaults.thinking` — `"high"`
- [ ] `agents.defaults.thinkingDefault` — `"high"`
- [ ] `agents.defaults.streaming` — `"partial"`
- [ ] `agents.defaults.imageMaxDimensionPx` — `1120`
- [ ] `channels.telegram.token` — указан, формат верный
- [ ] `channels.telegram.dmPolicy` — не `"deny"`
- [ ] `channels.telegram.chat_id` — отрицательный для групп
- [ ] `skills` — массив, пути существуют, нет дублей
- [ ] `memory.memorySearch` — включён или отключён осознанно
- [ ] `compaction.mode` — `"safeguard"`
- [ ] `tools.profile` — `"full"` (не `"messaging"`)

---

## Комбо-ошибки

| Симптом | Вероятная причина |
|---|---|
| Агент думает долго и не отвечает | `streaming: "off"` |
| Скриншоты мелкие / нечитабельны | Нет `imageMaxDimensionPx` |
| Агент не видит скиллы | Путь неверный или папка не там |
| Не отвечает в группе | Неверный `chat_id` или Privacy Mode |
| Контент слабый / без нюансов | Haiku вместо Sonnet |
| 401 ошибка | Ключ обрезан или истёк |
| Агент не может читать файлы | `tools.profile: "messaging"` |
| Лимиты улетают мгновенно | heartbeat у всех агентов |
