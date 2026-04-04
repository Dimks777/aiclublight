# Factory CLI — управление Фабрикой Контента

> CLI-утилита для управления Фабрикой. Устанавливается автоматически. Работает на всех тарифах.

---

## Команды

| Команда | Что делает |
|---|---|
| `factory` | Интерактивное меню (стрелки ↑↓ + Enter) |
| `factory update` | Обновить всё (CLI + скиллы + VERSION) |
| `factory skills` | Список установленных скиллов |
| `factory agents` | Список агентов (только 5agents и VIP) |
| `factory tokens` | Настройка токенов (Claude, OpenAI, Telegram) |
| `factory doctor` | Диагностика системы (10 проверок) |
| `factory status` | Статус системы |
| `factory -v` | Текущая версия |

---

## factory doctor — диагностика

Проверяет 9-10 пунктов:
1. ✅/❌ OpenClaw установлен
2. ✅/❌ Gateway запущен
3. ✅/❌ Claude подключён (API key / OAuth / env)
4. ✅/❌ Telegram ID настроен
5. ✅/❌ Telegram боты подключены
6. ✅/❌ Агенты на месте (только 5agents/VIP)
7. ✅/❌ Скиллы установлены
8. ✅/❌ Токен фабрики есть
9. ✅/❌ Версия актуальная
10. ✅/❌ Workspace найден

Красные ✗ — с подсказкой что исправить.

---

## Настройка токенов

### Claude (через factory → Настройка токенов → Claude)
1. **OAuth** (рекомендовано) — factory запускает `openclaw models auth paste-token --provider anthropic`
2. **API ключ** — вводишь `sk-ant-...`, записывается в openclaw.json

### Telegram ID
Записывается в `channels.telegram.allowFrom` в openclaw.json.

### Telegram боты
Для каждого агента — токен от @BotFather.

---

## Структура файлов

### Конструктор
```
~/clawd-factory/
├── SOUL.md
├── VERSION
├── brand/
├── learning/
└── projects/
~/.openclaw/skills/      (скиллы)
~/.openclaw/openclaw.json
```

### 5 Агентов / VIP
```
~/openclaw-factory/
├── agents/
├── coordinator/
├── copywriter/
├── designer/
├── marketer/
├── producer/
├── tech/
├── brain/
├── memory/
├── shared/
└── VERSION
~/.openclaw/skills/
~/.openclaw/openclaw.json
```

---

## Тарифы и маркеры

| Тариф | Маркер-файл | Скиллов | Агентов |
|---|---|---|---|
| 5 Агентов | `.5agents-token` | ~34 | 7 |

---

## Частые проблемы

### "factory: command not found"
```bash
curl -sL https://скрипт управления фабрикой -o ~/.local/bin/factory && chmod +x ~/.local/bin/factory
```
Если `~/.local/bin` не в PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

### "Токен невалидный"
Получить новый через бота Фабрики Контента.

### "Скиллы не найдены"
```bash
factory update
```

### authorizedSenders — Unrecognized key
Старый формат. `factory` → Настройка токенов → Telegram ID → ввести ID заново.
