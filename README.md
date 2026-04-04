# Фабрика Контента Lite

Лайт-версия [Фабрики Контента](https://github.com/Dimks777/aiclub) — 1 агент + 5 скиллов для быстрого старта с OpenClaw.

## Что внутри

**Агент:**
- **Координатор** — точка входа, маршрутизация задач, онбординг пользователей

**Скиллы (5):**
| Скилл | Назначение |
|-------|-----------|
| `copywriting` | Посты по методу Халилова, формулы, крючки |
| `telegram` | Telegram-контент, воронки, форматирование |
| `openclaw-ops` | Диагностика и настройка OpenClaw |
| `prompt-engineer` | Создание и оптимизация промптов |
| `editing` | Редактура и инфостиль |

## Установка

Требования: [OpenClaw](https://openclaw.ai), Node.js 18+

**Доступ только для участников клуба.** Получи персональный токен:

1. Напиши боту [@aiclub_gate_bot](https://t.me/aiclub_gate_bot) команду `/install`
2. Бот выдаст токен и готовую команду для установки
3. Вставь команду в терминал на сервере

```bash
curl -sSL "https://gate.yourserver.com/install?token=ТВОЙ_ТОКЕН" | bash
```

Токен действует 24 часа и рассчитан на 3 установки.

## После установки

1. Заполни `~/openclaw-factory/agents/coordinator/USER.md`
2. Перезапусти gateway: `openclaw gateway restart`
3. Напиши координатору: **начать**

## Полная версия

Хочешь 6 агентов и 36 скиллов? Установи полную [Фабрику Контента](https://github.com/Dimks777/aiclub):

```bash
curl -sSL https://raw.githubusercontent.com/Dimks777/aiclub/main/install.sh | bash
```
