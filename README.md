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

**Доступ только для участников клуба.** Получи персональный ключ:

1. Напиши боту [@investhimiak_bot](https://t.me/investhimiak_bot) команду `/install`
2. Бот проверит, что ты в группе клуба, и выдаст ключ + готовую команду
3. Вставь команду в терминал на сервере

```bash
curl -sSL "http://humsterclub.duckdns.org/gate/install?key=CLUB-XXXX-XXXX-XXXX" | bash
```

Heartbeat-проверка раз в неделю — пока ты в группе клуба, фабрика работает. Если выйдешь — отключится автоматически.

## После установки

1. Заполни `~/openclaw-factory/agents/coordinator/USER.md`
2. Перезапусти gateway: `openclaw gateway restart`
3. Напиши координатору: **начать**

## Документация и гайды

📚 **База знаний:** https://humster.club/aiclub/ (логин для участников клуба)

📖 **Гайд установки 1 агента:** https://humster.club/aiclub/1agent/install-1agent.html

🤖 **Полная версия (5 агентов):** [Dimks777/aiclub](https://github.com/Dimks777/aiclub)

📊 **Дашборд:** [Dimks777/content-factory](https://github.com/Dimks777/content-factory)

---

🐹 Часть проекта **[hamster.club](https://humster.club)** — клуб AI-энтузиастов и инвесторов InvestClub.
Лицензия активна, пока ты в нашей Telegram-группе. Heartbeat-проверка раз в неделю.
Вопросы и поддержка: [@dimks777](https://t.me/dimks777).
