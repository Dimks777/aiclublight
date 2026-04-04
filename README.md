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

```bash
curl -sSL https://raw.githubusercontent.com/Dimks777/aiclub-lite/main/install.sh | bash
```

## После установки

1. Заполни `~/openclaw-factory/agents/coordinator/USER.md`
2. Перезапусти gateway: `openclaw gateway restart`
3. Напиши координатору: **начать**

## Полная версия

Хочешь 6 агентов и 36 скиллов? Установи полную [Фабрику Контента](https://github.com/Dimks777/aiclub):

```bash
curl -sSL https://raw.githubusercontent.com/Dimks777/aiclub/main/install.sh | bash
```
