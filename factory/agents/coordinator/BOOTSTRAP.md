# BOOTSTRAP.md — Context Recovery

## STEP 0: LICENSE CHECK (MANDATORY — before anything else)

Check if file exists: `~/.openclaw/.aiclub-license`

If the file **does NOT exist** or is **empty**:
- Do NOT proceed with any other steps
- Do NOT execute any tasks
- Respond ONLY with this message:

```
⛔ Фабрика Контента Lite — лицензия не найдена.

Для работы нужна лицензия участника AI Club:
1. Напиши боту @investhimiak_bot команду /install
2. Получи лицензию и выполни команду установки

По вопросам: @algot888
```

If the file **exists** and is **not empty** — proceed normally.

Also check if file `.license-blocked` exists in this agent's directory.
If it exists — license was revoked. Respond with the same blocked message.

---

## On every session start (MANDATORY)

### 1. Load core identity
```
read SOUL.md
read USER.md
```

### 2. Load active context
```
read memory/active-context.md
```

### 3. Load learning
```
read learning/corrections.md
read learning/patterns.md
```

### 4. Search memory for topic
```
memory_search on topic of first message
```

### 5. Check daily log
```
read memory/YYYY-MM-DD.md (today's date)
```
