# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## OpenRouter

- Документация: https://openrouter.ai/docs/quickstart
- API models list: `curl https://openrouter.ai/api/v1/models -H "Authorization: Bearer $OPENROUTER_API_KEY"`
- API ключ: env `OPENROUTER_API_KEY`
- Base URL: `https://openrouter.ai/api/v1` (OpenAI-совместимый)

### Топ дешёвых моделей для чата (март 2026)

**БЕСПЛАТНЫЕ (free tier):**
- `meta-llama/llama-3.3-70b-instruct:free` — $0, ctx 65k, хорошее качество
- `google/gemma-3-27b-it:free` — $0, ctx 131k, Google
- `qwen/qwen3-next-80b-a3b-instruct:free` — $0, ctx 262k, мощный

**ПЛАТНЫЕ дешёвые:**
- `mistralai/mistral-nemo` — $0.02/$0.04 за 1M, ctx 131k
- `mistralai/mistral-small-3.1-24b-instruct` — $0.03/$0.11 за 1M, ctx 131k

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.
## Exa Search API
- Документация: https://exa.ai/docs/reference/search-api-guide
- API ключ: `e2388c42-1bc4-4ec5-bdc7-ddbd3432efb3` (env: `EXA_API_KEY`)
- Endpoint: `https://api.exa.ai/search` (POST)
- Auth header: `x-api-key: $EXA_API_KEY`
- Цена: $7/1k запросов (Search neural), $12/1k (Deep Search)
- Баланс: смотреть на https://dashboard.exa.ai

### Пример запроса:
```bash
curl -s -X POST https://api.exa.ai/search \
  -H "x-api-key: $EXA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"query": "insider trades today", "numResults": 5}'
```
